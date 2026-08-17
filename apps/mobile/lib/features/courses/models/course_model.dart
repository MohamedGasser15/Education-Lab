class Instructor {
  final String name;
  final String title;
  final String avatar;

  Instructor({
    required this.name,
    required this.title,
    required this.avatar,
  });

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }
}

class CourseLesson {
  final String id;
  final String title;
  final String duration;
  final String type; // 'video' | 'pdf' | 'quiz'
  final bool isFree;
  final bool isCompleted;
  final bool isLocked;
  final String? videoUrl;

  CourseLesson({
    required this.id,
    required this.title,
    required this.duration,
    this.type = 'video',
    this.isFree = false,
    this.isCompleted = false,
    this.isLocked = false,
    this.videoUrl,
  });
}

class CourseSection {
  final String id;
  final int number;
  final String title;
  final int lecturesCount;
  final String duration;
  final List<CourseLesson> lessons;

  CourseSection({
    required this.id,
    required this.number,
    required this.title,
    required this.lecturesCount,
    required this.duration,
    required this.lessons,
  });
}

class Course {
  final String id;
  final String title;
  final String category;
  final String level; // مبتدئ | متوسط | متقدم
  final double rating;
  final int reviewsCount;
  final int studentsCount;
  final String duration;
  final double price;
  final double? originalPrice;
  final bool isFree;
  final String currency;
  final String image;
  final Instructor instructor;
  final String description;
  final double? progress;
  final String? currentLesson;
  final int totalLessons;
  final int totalSections;
  bool isWishlisted;
  final List<CourseSection>? sections;

  Course({
    required this.id,
    required this.title,
    required this.category,
    required this.level,
    required this.rating,
    this.reviewsCount = 0,
    this.studentsCount = 0,
    required this.duration,
    required this.price,
    this.originalPrice,
    this.isFree = false,
    required this.currency,
    required this.image,
    required this.instructor,
    this.description = '',
    this.progress,
    this.currentLesson,
    this.totalLessons = 0,
    this.totalSections = 0,
    this.isWishlisted = false,
    this.sections,
  });
}
