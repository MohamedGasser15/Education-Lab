class SupportConversationModel {
  final int id;
  final String subject;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int unreadCount;
  final String? lastMessage;
  final DateTime? lastMessageAt;

  const SupportConversationModel({
    required this.id,
    required this.subject,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.unreadCount = 0,
    this.lastMessage,
    this.lastMessageAt,
  });

  bool get isOpen => status.trim().toLowerCase() == 'open';

  factory SupportConversationModel.fromJson(Map<String, dynamic> json) {
    return SupportConversationModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      subject: json['subject']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Open',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      unreadCount: json['unreadCount'] is int
          ? json['unreadCount']
          : int.tryParse(json['unreadCount']?.toString() ?? '0') ?? 0,
      lastMessage: json['lastMessage']?.toString(),
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.tryParse(json['lastMessageAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'unreadCount': unreadCount,
      'lastMessage': lastMessage,
      'lastMessageAt': lastMessageAt?.toIso8601String(),
    };
  }

  SupportConversationModel copyWith({
    int? id,
    String? subject,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? unreadCount,
    String? lastMessage,
    DateTime? lastMessageAt,
  }) {
    return SupportConversationModel(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      unreadCount: unreadCount ?? this.unreadCount,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
  }
}

class SupportMessageModel {
  final int id;
  final int conversationId;
  final String senderId;
  final String senderRole;
  final String content;
  final DateTime createdAt;
  final bool isRead;

  const SupportMessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderRole,
    required this.content,
    required this.createdAt,
    this.isRead = false,
  });

  bool get isUser => senderRole.trim().toLowerCase() == 'user';

  factory SupportMessageModel.fromJson(Map<String, dynamic> json) {
    return SupportMessageModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      conversationId: json['conversationId'] is int
          ? json['conversationId']
          : int.tryParse(json['conversationId']?.toString() ?? '0') ?? 0,
      senderId: json['senderId']?.toString() ?? '',
      senderRole: json['senderRole']?.toString() ?? 'User',
      content: json['content']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isRead: json['isRead'] == true || json['isRead']?.toString().toLowerCase() == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'senderRole': senderRole,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  SupportMessageModel copyWith({
    int? id,
    int? conversationId,
    String? senderId,
    String? senderRole,
    String? content,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return SupportMessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderRole: senderRole ?? this.senderRole,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
