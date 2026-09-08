class NotificationSummaryModel {
  final int totalCount;
  final int unreadCount;
  final int systemCount;
  final int promotionalCount;

  const NotificationSummaryModel({
    required this.totalCount,
    required this.unreadCount,
    required this.systemCount,
    required this.promotionalCount,
  });

  factory NotificationSummaryModel.fromJson(Map<String, dynamic> json) {
    return NotificationSummaryModel(
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      systemCount: (json['systemCount'] as num?)?.toInt() ?? 0,
      promotionalCount: (json['promotionalCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'unreadCount': unreadCount,
      'systemCount': systemCount,
      'promotionalCount': promotionalCount,
    };
  }
}
