import 'package:hive/hive.dart';

part 'memory_model.g.dart';

@HiveType(typeId: 0)
class MemoryModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String? imagePath;

  @HiveField(4)
  String? audioPath;

  @HiveField(5)
  String category;

  @HiveField(6)
  DateTime date;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime updatedAt;

  MemoryModel({
    required this.id,
    required this.title,
    required this.description,
    this.imagePath,
    this.audioPath,
    required this.category,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor for creating a new memory
  factory MemoryModel.create({
    required String title,
    required String description,
    String? imagePath,
    String? audioPath,
    required String category,
    required DateTime date,
  }) {
    final now = DateTime.now();
    return MemoryModel(
      id: now.millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      imagePath: imagePath,
      audioPath: audioPath,
      category: category,
      date: date,
      createdAt: now,
      updatedAt: now,
    );
  }

  // Copy with method for updating memories
  MemoryModel copyWith({
    String? title,
    String? description,
    String? imagePath,
    String? audioPath,
    String? category,
    DateTime? date,
  }) {
    return MemoryModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      audioPath: audioPath ?? this.audioPath,
      category: category ?? this.category,
      date: date ?? this.date,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  // Convert to JSON for backup/restore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'audioPath': audioPath,
      'category': category,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from JSON for backup/restore
  factory MemoryModel.fromJson(Map<String, dynamic> json) {
    return MemoryModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imagePath: json['imagePath'],
      audioPath: json['audioPath'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  String toString() {
    return 'MemoryModel(id: $id, title: $title, category: $category, date: $date)';
  }
}

// Predefined categories in Bengali
class MemoryCategories {
  static const String family = 'পরিবার';
  static const String friends = 'বন্ধুবান্ধব';
  static const String travel = 'ভ্রমণ';
  static const String work = 'কাজ';
  static const String love = 'ভালোবাসা';
  static const String achievement = 'অর্জন';
  static const String childhood = 'শৈশব';
  static const String education = 'শিক্ষা';
  static const String celebration = 'উৎসব';
  static const String other = 'অন্যান্য';

  static List<String> get allCategories => [
        family,
        friends,
        travel,
        work,
        love,
        achievement,
        childhood,
        education,
        celebration,
        other,
      ];
}

