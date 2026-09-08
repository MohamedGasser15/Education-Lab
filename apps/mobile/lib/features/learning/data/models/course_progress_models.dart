import 'package:mobile/core/constants/api_constants.dart';

class CourseProgressSummaryModel {
  final int enrollmentId;
  final int courseId;
  final String courseTitle;
  final int totalLectures;
  final int completedLectures;
  final double progressPercentage;
  final DateTime? lastActivity;
  final int totalDuration;
  final int watchedDuration;

  const CourseProgressSummaryModel({
    this.enrollmentId = 0,
    required this.courseId,
    this.courseTitle = '',
    this.totalLectures = 0,
    this.completedLectures = 0,
    this.progressPercentage = 0.0,
    this.lastActivity,
    this.totalDuration = 0,
    this.watchedDuration = 0,
  });

  bool get isCompleted => progressPercentage >= 100 || (totalLectures > 0 && completedLectures >= totalLectures);
  double get progressRatio => (progressPercentage / 100).clamp(0.0, 1.0);

  factory CourseProgressSummaryModel.fromJson(Map<String, dynamic> json) {
    final rawProgress = json['progressPercentage'] ?? json['ProgressPercentage'] ?? json['progress'] ?? 0;
    final double progressVal = (rawProgress is num) ? rawProgress.toDouble() : (double.tryParse(rawProgress.toString()) ?? 0.0);

    return CourseProgressSummaryModel(
      enrollmentId: int.tryParse(json['enrollmentId']?.toString() ?? json['EnrollmentId']?.toString() ?? '0') ?? 0,
      courseId: int.tryParse(json['courseId']?.toString() ?? json['CourseId']?.toString() ?? '0') ?? 0,
      courseTitle: json['courseTitle']?.toString() ?? json['CourseTitle']?.toString() ?? '',
      totalLectures: int.tryParse(json['totalLectures']?.toString() ?? json['TotalLectures']?.toString() ?? '0') ?? 0,
      completedLectures: int.tryParse(json['completedLectures']?.toString() ?? json['CompletedLectures']?.toString() ?? '0') ?? 0,
      progressPercentage: progressVal,
      lastActivity: json['lastActivity'] != null ? DateTime.tryParse(json['lastActivity'].toString()) : null,
      totalDuration: int.tryParse(json['totalDuration']?.toString() ?? json['TotalDuration']?.toString() ?? '0') ?? 0,
      watchedDuration: int.tryParse(json['watchedDuration']?.toString() ?? json['WatchedDuration']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'enrollmentId': enrollmentId,
    'courseId': courseId,
    'courseTitle': courseTitle,
    'totalLectures': totalLectures,
    'completedLectures': completedLectures,
    'progressPercentage': progressPercentage,
    'lastActivity': lastActivity?.toIso8601String(),
    'totalDuration': totalDuration,
    'watchedDuration': watchedDuration,
  };
}

class LectureResourceModel {
  final int id;
  final int lectureId;
  final String title;
  final String? fileUrl;
  final String fileType;
  final String? fileSize;

  const LectureResourceModel({
    required this.id,
    required this.lectureId,
    required this.title,
    this.fileUrl,
    this.fileType = 'file',
    this.fileSize,
  });

  String get formattedUrl => ApiConstants.formatImageUrl(fileUrl);

  factory LectureResourceModel.fromJson(Map<String, dynamic> json) {
    return LectureResourceModel(
      id: int.tryParse(json['id']?.toString() ?? json['Id']?.toString() ?? '0') ?? 0,
      lectureId: int.tryParse(json['lectureId']?.toString() ?? json['LectureId']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? json['Title']?.toString() ?? json['name']?.toString() ?? 'ملف مرفق',
      fileUrl: json['fileUrl']?.toString() ?? json['FileUrl']?.toString() ?? json['url']?.toString(),
      fileType: json['fileType']?.toString() ?? json['FileType']?.toString() ?? json['type']?.toString() ?? 'file',
      fileSize: json['fileSize']?.toString() ?? json['FileSize']?.toString() ?? json['size']?.toString(),
    );
  }
}
