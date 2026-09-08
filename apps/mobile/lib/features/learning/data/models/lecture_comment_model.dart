import 'package:mobile/core/constants/api_constants.dart';

class LectureCommentModel {
  final int id;
  final int lectureId;
  final String userId;
  final String userName;
  final String? userProfileImage;
  final String content;
  final int? parentCommentId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? timeAgo;
  final bool isInstructorReply;
  final List<LectureCommentModel> replies;

  const LectureCommentModel({
    required this.id,
    required this.lectureId,
    this.userId = '',
    required this.userName,
    this.userProfileImage,
    required this.content,
    this.parentCommentId,
    this.createdAt,
    this.updatedAt,
    this.timeAgo,
    this.isInstructorReply = false,
    this.replies = const [],
  });

  String get formattedAvatarUrl => ApiConstants.formatImageUrl(userProfileImage);

  String get displayTimeAgo {
    if (timeAgo != null && timeAgo!.trim().isNotEmpty) {
      return timeAgo!;
    }
    if (createdAt == null) return '';
    final diff = DateTime.now().difference(createdAt!);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inHours < 1) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inDays < 1) return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays < 30) return 'منذ ${diff.inDays} يوم';
    return '${createdAt!.year}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}';
  }

  factory LectureCommentModel.fromJson(Map<String, dynamic> json) {
    final rawReplies = json['replies'] ?? json['Replies'];
    List<LectureCommentModel> repliesList = [];
    if (rawReplies is List) {
      for (final r in rawReplies) {
        if (r is Map) {
          repliesList.add(LectureCommentModel.fromJson(Map<String, dynamic>.from(r)));
        }
      }
    }

    return LectureCommentModel(
      id: int.tryParse(json['id']?.toString() ?? json['Id']?.toString() ?? '0') ?? 0,
      lectureId: int.tryParse(json['lectureId']?.toString() ?? json['LectureId']?.toString() ?? '0') ?? 0,
      userId: json['userId']?.toString() ?? json['UserId']?.toString() ?? '',
      userName: json['userName']?.toString() ?? json['UserName']?.toString() ?? 'طالب',
      userProfileImage: json['userProfileImage']?.toString() ?? json['UserProfileImage']?.toString(),
      content: json['content']?.toString() ?? json['Content']?.toString() ?? '',
      parentCommentId: int.tryParse(json['parentCommentId']?.toString() ?? json['ParentCommentId']?.toString() ?? ''),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
      timeAgo: json['timeAgo']?.toString() ?? json['TimeAgo']?.toString(),
      isInstructorReply: json['isInstructorReply'] == true || json['IsInstructorReply'] == true,
      replies: repliesList,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'lectureId': lectureId,
    'userId': userId,
    'userName': userName,
    'userProfileImage': userProfileImage,
    'content': content,
    'parentCommentId': parentCommentId,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'timeAgo': timeAgo,
    'isInstructorReply': isInstructorReply,
    'replies': replies.map((r) => r.toJson()).toList(),
  };
}
