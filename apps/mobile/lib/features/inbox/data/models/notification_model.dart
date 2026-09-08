import 'package:flutter/material.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';

enum NotificationType {
  system,
  promotional,
  course,
  enrollment,
  reminder,
}

enum NotificationStatus {
  unread,
  read,
}

class NotificationModel {
  final int id;
  final String title;
  final String message;
  final int type; // 0: System, 1: Promotional, 2: Course, 3: Enrollment, 4: Reminder
  final int status; // 0: Unread, 1: Read
  final DateTime createdAt;
  final DateTime? readAt;
  final String? relatedEntityId;
  final String? relatedEntityType;
  final String? titleKey;
  final String? messageKey;
  final String? parameters;
  final String? iconClass;
  final String? colorClass;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.status,
    required this.createdAt,
    this.readAt,
    this.relatedEntityId,
    this.relatedEntityType,
    this.titleKey,
    this.messageKey,
    this.parameters,
    this.iconClass,
    this.colorClass,
  });

  bool get isRead => status == 1 || readAt != null;

  NotificationType get notificationType {
    switch (type) {
      case 0:
        return NotificationType.system;
      case 1:
        return NotificationType.promotional;
      case 2:
        return NotificationType.course;
      case 3:
        return NotificationType.enrollment;
      case 4:
        return NotificationType.reminder;
      default:
        return NotificationType.system;
    }
  }

  /// Categorization for UI Filter Chips: 'all', 'courses', 'promos', 'system'
  String get categoryGroup {
    switch (type) {
      case 2:
      case 3:
        return 'courses';
      case 1:
        return 'promos';
      case 0:
      case 4:
      default:
        return 'system';
    }
  }

  IconData get iconData {
    switch (type) {
      case 2:
        return Icons.play_circle_outline_rounded;
      case 3:
        return Icons.workspace_premium_outlined;
      case 1:
        return Icons.local_offer_outlined;
      case 4:
        return Icons.alarm_rounded;
      case 0:
      default:
        return Icons.notifications_none_rounded;
    }
  }

  Color get iconColor {
    switch (type) {
      case 2:
        return AppColors.primary;
      case 3:
        return const Color(0xFF059669); // Emerald
      case 1:
        return const Color(0xFFD97706); // Amber
      case 4:
        return const Color(0xFFEF4444); // Red
      case 0:
      default:
        return const Color(0xFF7C3AED); // Purple
    }
  }

  Color iconBgColor(bool isDark) {
    if (isDark) {
      return iconColor.withValues(alpha: 0.18);
    }
    switch (type) {
      case 2:
        return const Color(0xFFEFF6FF);
      case 3:
        return const Color(0xFFECFDF5);
      case 1:
        return const Color(0xFFFEF3C7);
      case 4:
        return const Color(0xFFFEE2E2);
      case 0:
      default:
        return const Color(0xFFF5F3FF);
    }
  }

  String? get targetRoute {
    final entityType = relatedEntityType?.toLowerCase().trim();
    if (entityType == 'course') {
      return '/course-details';
    } else if (entityType == 'certificate') {
      return '/certificate_view';
    } else if (entityType == 'lesson') {
      return '/lesson-player';
    } else if (entityType == 'cart') {
      return '/cart';
    }
    return null;
  }

  dynamic get routeArguments {
    final entityType = relatedEntityType?.toLowerCase().trim();
    if (entityType == 'course' && relatedEntityId != null) {
      return int.tryParse(relatedEntityId!) ?? relatedEntityId;
    }
    return relatedEntityId;
  }

  String timeAgo({required bool isAr, BuildContext? context}) {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (context != null) {
      if (diff.inSeconds < 60) {
        return context.loc.timeJustNow;
      } else if (diff.inMinutes < 60) {
        return context.loc.timeMinutesAgo(diff.inMinutes.toString());
      } else if (diff.inHours < 24) {
        return context.loc.timeHoursAgo(diff.inHours.toString());
      } else if (diff.inDays < 7) {
        return context.loc.timeDaysAgo(diff.inDays.toString());
      } else if (diff.inDays < 30) {
        return context.loc.timeWeeksAgo((diff.inDays / 7).floor().toString());
      } else {
        return context.loc.timeMonthsAgo((diff.inDays / 30).floor().toString());
      }
    }

    if (diff.inSeconds < 60) {
      return isAr ? 'الآن' : 'Just now';
    } else if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return isAr ? 'منذ $m دقيقة' : '$m min ago';
    } else if (diff.inHours < 24) {
      final h = diff.inHours;
      return isAr ? 'منذ $h ساعة' : '$h hr ago';
    } else if (diff.inDays < 7) {
      final d = diff.inDays;
      return isAr ? 'منذ $d يوم' : '$d days ago';
    } else if (diff.inDays < 30) {
      final w = (diff.inDays / 7).floor();
      return isAr ? 'منذ $w أسبوع' : '$w weeks ago';
    } else {
      final mo = (diff.inDays / 30).floor();
      return isAr ? 'منذ $mo شهر' : '$mo months ago';
    }
  }

  NotificationModel copyWith({
    int? id,
    String? title,
    String? message,
    int? type,
    int? status,
    DateTime? createdAt,
    DateTime? readAt,
    String? relatedEntityId,
    String? relatedEntityType,
    String? titleKey,
    String? messageKey,
    String? parameters,
    String? iconClass,
    String? colorClass,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      relatedEntityId: relatedEntityId ?? this.relatedEntityId,
      relatedEntityType: relatedEntityType ?? this.relatedEntityType,
      titleKey: titleKey ?? this.titleKey,
      messageKey: messageKey ?? this.messageKey,
      parameters: parameters ?? this.parameters,
      iconClass: iconClass ?? this.iconClass,
      colorClass: colorClass ?? this.colorClass,
    );
  }

  static int _parseType(dynamic raw) {
    if (raw == null) return 0;
    if (raw is num) return raw.toInt();
    if (raw is String) {
      final s = raw.trim().toLowerCase();
      if (s == '1' || s.contains('promo') || s.contains('offer')) return 1;
      if (s == '2' || s.contains('course')) return 2;
      if (s == '3' || s.contains('enroll')) return 3;
      if (s == '4' || s.contains('remind')) return 4;
      return int.tryParse(s) ?? 0;
    }
    return 0;
  }

  static int _parseStatus(dynamic raw) {
    if (raw == null) return 0;
    if (raw is num) return raw.toInt();
    if (raw is String) {
      final s = raw.trim().toLowerCase();
      if (s == '1' || s == 'read') return 1;
      return int.tryParse(s) ?? 0;
    }
    return 0;
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['Id'];
    final rawTitle = json['title'] ?? json['Title'];
    final rawMessage = json['message'] ?? json['Message'];
    final rawType = json['type'] ?? json['Type'];
    final rawStatus = json['status'] ?? json['Status'];
    final rawCreatedAt = json['createdAt'] ?? json['CreatedAt'];
    final rawReadAt = json['readAt'] ?? json['ReadAt'];
    final rawEntityId = json['relatedEntityId'] ?? json['RelatedEntityId'];
    final rawEntityType = json['relatedEntityType'] ?? json['RelatedEntityType'];
    final rawTitleKey = json['titleKey'] ?? json['TitleKey'];
    final rawMessageKey = json['messageKey'] ?? json['MessageKey'];
    final rawParams = json['parameters'] ?? json['Parameters'];
    final rawIcon = json['iconClass'] ?? json['IconClass'];
    final rawColor = json['colorClass'] ?? json['ColorClass'];

    return NotificationModel(
      id: rawId is num ? rawId.toInt() : (int.tryParse(rawId?.toString() ?? '') ?? 0),
      title: rawTitle as String? ?? '',
      message: rawMessage as String? ?? '',
      type: _parseType(rawType),
      status: _parseStatus(rawStatus),
      createdAt: rawCreatedAt != null
          ? (DateTime.tryParse(rawCreatedAt.toString()) ?? DateTime.now())
          : DateTime.now(),
      readAt: rawReadAt != null ? DateTime.tryParse(rawReadAt.toString()) : null,
      relatedEntityId: rawEntityId?.toString(),
      relatedEntityType: rawEntityType as String?,
      titleKey: rawTitleKey as String?,
      messageKey: rawMessageKey as String?,
      parameters: rawParams as String?,
      iconClass: rawIcon as String?,
      colorClass: rawColor as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
      'relatedEntityId': relatedEntityId,
      'relatedEntityType': relatedEntityType,
      'titleKey': titleKey,
      'messageKey': messageKey,
      'parameters': parameters,
      'iconClass': iconClass,
      'colorClass': colorClass,
    };
  }
}
