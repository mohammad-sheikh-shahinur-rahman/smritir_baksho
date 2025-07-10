import 'package:hive/hive.dart';
import '../models/memory_model.dart';

class HiveBoxes {
  static const String memoriesBoxName = 'memories';
  static const String settingsBoxName = 'settings';

  static Box<MemoryModel>? _memoriesBox;
  static Box? _settingsBox;

  // Getters for boxes
  static Box<MemoryModel> get memoriesBox {
    if (_memoriesBox == null || !_memoriesBox!.isOpen) {
      throw Exception('Memories box is not initialized');
    }
    return _memoriesBox!;
  }

  static Box get settingsBox {
    if (_settingsBox == null || !_settingsBox!.isOpen) {
      throw Exception('Settings box is not initialized');
    }
    return _settingsBox!;
  }

  // Initialize all boxes
  static Future<void> openBoxes() async {
    try {
      _memoriesBox = await Hive.openBox<MemoryModel>(memoriesBoxName);
      _settingsBox = await Hive.openBox(settingsBoxName);
    } catch (e) {
      throw Exception('Failed to open Hive boxes: $e');
    }
  }

  // Close all boxes
  static Future<void> closeBoxes() async {
    await _memoriesBox?.close();
    await _settingsBox?.close();
    _memoriesBox = null;
    _settingsBox = null;
  }

  // Memory operations
  static Future<void> addMemory(MemoryModel memory) async {
    await memoriesBox.put(memory.id, memory);
  }

  static Future<void> updateMemory(MemoryModel memory) async {
    await memoriesBox.put(memory.id, memory);
  }

  static Future<void> deleteMemory(String id) async {
    await memoriesBox.delete(id);
  }

  static MemoryModel? getMemory(String id) {
    return memoriesBox.get(id);
  }

  static List<MemoryModel> getAllMemories() {
    return memoriesBox.values.toList();
  }

  static List<MemoryModel> getMemoriesByCategory(String category) {
    return memoriesBox.values
        .where((memory) => memory.category == category)
        .toList();
  }

  static List<MemoryModel> searchMemories(String query) {
    final lowercaseQuery = query.toLowerCase();
    return memoriesBox.values
        .where((memory) =>
            memory.title.toLowerCase().contains(lowercaseQuery) ||
            memory.description.toLowerCase().contains(lowercaseQuery))
        .toList();
  }

  // Settings operations
  static Future<void> saveSetting(String key, dynamic value) async {
    await settingsBox.put(key, value);
  }

  static T? getSetting<T>(String key, {T? defaultValue}) {
    return settingsBox.get(key, defaultValue: defaultValue) as T?;
  }

  static Future<void> deleteSetting(String key) async {
    await settingsBox.delete(key);
  }

  // Backup and restore
  static Map<String, dynamic> exportData() {
    final memories = getAllMemories().map((memory) => memory.toJson()).toList();
    final settings = Map<String, dynamic>.from(settingsBox.toMap());
    
    return {
      'memories': memories,
      'settings': settings,
      'exportDate': DateTime.now().toIso8601String(),
      'version': '1.0.0',
    };
  }

  static Future<void> importData(Map<String, dynamic> data) async {
    try {
      // Clear existing data
      await memoriesBox.clear();
      await settingsBox.clear();

      // Import memories
      if (data['memories'] != null) {
        final memoriesList = data['memories'] as List;
        for (final memoryJson in memoriesList) {
          final memory = MemoryModel.fromJson(memoryJson);
          await addMemory(memory);
        }
      }

      // Import settings
      if (data['settings'] != null) {
        final settingsMap = data['settings'] as Map<String, dynamic>;
        for (final entry in settingsMap.entries) {
          await saveSetting(entry.key, entry.value);
        }
      }
    } catch (e) {
      throw Exception('Failed to import data: $e');
    }
  }

  // Statistics
  static int get totalMemories => memoriesBox.length;

  static Map<String, int> get memoriesByCategory {
    final Map<String, int> categoryCount = {};
    for (final memory in memoriesBox.values) {
      categoryCount[memory.category] = (categoryCount[memory.category] ?? 0) + 1;
    }
    return categoryCount;
  }

  static List<MemoryModel> getRecentMemories({int limit = 10}) {
    final memories = getAllMemories();
    memories.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return memories.take(limit).toList();
  }

  static List<MemoryModel> getMemoriesFromPast({int daysAgo = 365}) {
    final targetDate = DateTime.now().subtract(Duration(days: daysAgo));
    return memoriesBox.values
        .where((memory) => 
            memory.date.year == targetDate.year &&
            memory.date.month == targetDate.month &&
            memory.date.day == targetDate.day)
        .toList();
  }
}

