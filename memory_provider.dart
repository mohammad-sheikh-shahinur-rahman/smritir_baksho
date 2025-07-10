import 'dart:io';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/memory_model.dart';
import '../utils/hive_boxes.dart';
import '../main.dart';

class MemoryProvider extends ChangeNotifier {
  List<MemoryModel> _memories = [];
  List<MemoryModel> _filteredMemories = [];
  String _selectedCategory = 'সব';
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isDarkMode = false;
  bool _isBiometricEnabled = false;
  bool _isAuthenticated = false;
  Color _primaryColor = Colors.brown;
  String _selectedFont = 'SolaimanLipi';

  // Getters
  List<MemoryModel> get memories => _filteredMemories;
  List<MemoryModel> get allMemories => _memories;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _isDarkMode;
  bool get isBiometricEnabled => _isBiometricEnabled;
  bool get isAuthenticated => _isAuthenticated;
  Color get primaryColor => _primaryColor;
  String get selectedFont => _selectedFont;

  final LocalAuthentication _localAuth = LocalAuthentication();

  MemoryProvider() {
    _loadSettings();
    _loadMemories();
    _scheduleNotifications();
  }

  // Load settings from Hive
  Future<void> _loadSettings() async {
    try {
      _isDarkMode = HiveBoxes.getSetting('isDarkMode', defaultValue: false) ?? false;
      _isBiometricEnabled = HiveBoxes.getSetting('isBiometricEnabled', defaultValue: false) ?? false;
      _primaryColor = Color(HiveBoxes.getSetting('primaryColor', defaultValue: Colors.brown.value) ?? Colors.brown.value);
      _selectedFont = HiveBoxes.getSetting('selectedFont', defaultValue: 'SolaimanLipi') ?? 'SolaimanLipi';
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  // Load memories from Hive
  Future<void> _loadMemories() async {
    _setLoading(true);
    try {
      _memories = HiveBoxes.getAllMemories();
      _memories.sort((a, b) => b.date.compareTo(a.date));
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading memories: $e');
    }
    _setLoading(false);
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Apply filters and search
  void _applyFilters() {
    _filteredMemories = _memories.where((memory) {
      final matchesCategory = _selectedCategory == 'সব' || memory.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          memory.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          memory.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
    notifyListeners();
  }

  // Memory operations
  Future<void> addMemory(MemoryModel memory) async {
    try {
      await HiveBoxes.addMemory(memory);
      _memories.insert(0, memory);
      _applyFilters();
    } catch (e) {
      debugPrint('Error adding memory: $e');
      rethrow;
    }
  }

  Future<void> updateMemory(MemoryModel updatedMemory) async {
    try {
      await HiveBoxes.updateMemory(updatedMemory);
      final index = _memories.indexWhere((m) => m.id == updatedMemory.id);
      if (index != -1) {
        _memories[index] = updatedMemory;
        _applyFilters();
      }
    } catch (e) {
      debugPrint('Error updating memory: $e');
      rethrow;
    }
  }

  Future<void> deleteMemory(String id) async {
    try {
      await HiveBoxes.deleteMemory(id);
      _memories.removeWhere((m) => m.id == id);
      _applyFilters();
    } catch (e) {
      debugPrint('Error deleting memory: $e');
      rethrow;
    }
  }

  // Filter and search operations
  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void clearFilters() {
    _selectedCategory = 'সব';
    _searchQuery = '';
    _applyFilters();
  }

  // Settings operations
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await HiveBoxes.saveSetting('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> setPrimaryColor(Color color) async {
    _primaryColor = color;
    await HiveBoxes.saveSetting('primaryColor', color.value);
    notifyListeners();
  }

  Future<void> setSelectedFont(String font) async {
    _selectedFont = font;
    await HiveBoxes.saveSetting('selectedFont', font);
    notifyListeners();
  }

  // Biometric authentication
  Future<bool> checkBiometricSupport() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } catch (e) {
      debugPrint('Error checking biometric support: $e');
      return false;
    }
  }

  Future<void> toggleBiometric() async {
    if (!_isBiometricEnabled) {
      final isSupported = await checkBiometricSupport();
      if (!isSupported) {
        throw Exception('বায়োমেট্রিক প্রমাণীকরণ সমর্থিত নয়');
      }
      
      final isAuthenticated = await authenticateWithBiometric();
      if (!isAuthenticated) {
        throw Exception('বায়োমেট্রিক প্রমাণীকরণ ব্যর্থ');
      }
    }
    
    _isBiometricEnabled = !_isBiometricEnabled;
    await HiveBoxes.saveSetting('isBiometricEnabled', _isBiometricEnabled);
    notifyListeners();
  }

  Future<bool> authenticateWithBiometric() async {
    try {
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'স্মৃতির বাক্স খুলতে আপনার পরিচয় যাচাই করুন',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      
      if (isAuthenticated) {
        _isAuthenticated = true;
        notifyListeners();
      }
      
      return isAuthenticated;
    } catch (e) {
      debugPrint('Error during biometric authentication: $e');
      return false;
    }
  }

  // Backup and restore
  Future<Map<String, dynamic>> exportData() async {
    try {
      return HiveBoxes.exportData();
    } catch (e) {
      debugPrint('Error exporting data: $e');
      rethrow;
    }
  }

  Future<void> importData(Map<String, dynamic> data) async {
    try {
      await HiveBoxes.importData(data);
      await _loadMemories();
    } catch (e) {
      debugPrint('Error importing data: $e');
      rethrow;
    }
  }

  // Notifications
  Future<void> _scheduleNotifications() async {
    try {
      // Schedule weekly memory reminder
      await _scheduleWeeklyReminder();
    } catch (e) {
      debugPrint('Error scheduling notifications: $e');
    }
  }

  Future<void> _scheduleWeeklyReminder() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'memory_reminder',
      'Memory Reminders',
      channelDescription: 'Weekly reminders to add new memories',
      importance: Importance.medium,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      'স্মৃতির বাক্স',
      'আজকের কোন সুন্দর মুহূর্ত সংরক্ষণ করুন! 📝',
      RepeatInterval.weekly,
      platformChannelSpecifics,
    );
  }

  // Statistics
  int get totalMemories => _memories.length;
  
  Map<String, int> get memoriesByCategory {
    final Map<String, int> categoryCount = {};
    for (final memory in _memories) {
      categoryCount[memory.category] = (categoryCount[memory.category] ?? 0) + 1;
    }
    return categoryCount;
  }

  List<MemoryModel> getMemoriesFromPast({int daysAgo = 365}) {
    final targetDate = DateTime.now().subtract(Duration(days: daysAgo));
    return _memories.where((memory) => 
        memory.date.year == targetDate.year &&
        memory.date.month == targetDate.month &&
        memory.date.day == targetDate.day).toList();
  }

  // Cleanup
  @override
  void dispose() {
    super.dispose();
  }
}

