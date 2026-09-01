class ActiveSessionModel {
  final String id;
  final String deviceName;
  final String deviceType; // 'phone' | 'desktop' | 'tablet'
  final String location;
  final String ipAddress;
  final DateTime? lastActive;
  final bool isCurrent;

  const ActiveSessionModel({
    required this.id,
    required this.deviceName,
    required this.deviceType,
    required this.location,
    this.ipAddress = '',
    this.lastActive,
    this.isCurrent = false,
  });

  factory ActiveSessionModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json['loginTime'] != null || json['lastActive'] != null || json['createdAt'] != null) {
      try {
        parsedDate = DateTime.parse(
          (json['loginTime'] ?? json['lastActive'] ?? json['createdAt']).toString(),
        );
      } catch (_) {}
    }

    final info = json['deviceInfo']?.toString() ?? json['deviceName']?.toString() ?? 'Device';
    String inferredType = 'phone';
    final lower = info.toLowerCase();
    if (lower.contains('windows') || lower.contains('mac') || lower.contains('linux') || lower.contains('chrome') || lower.contains('firefox')) {
      inferredType = 'desktop';
    } else if (lower.contains('ipad') || lower.contains('tablet')) {
      inferredType = 'tablet';
    }

    return ActiveSessionModel(
      id: json['id']?.toString() ?? '',
      deviceName: info,
      deviceType: json['deviceType']?.toString() ?? inferredType,
      location: json['location']?.toString() ?? 'الرياض، السعودية',
      ipAddress: json['ipAddress']?.toString() ?? '',
      lastActive: parsedDate,
      isCurrent: json['isCurrent'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'deviceInfo': deviceName,
        'location': location,
        'loginTime': lastActive?.toIso8601String(),
        'isCurrent': isCurrent,
      };
}

class TwoFactorSetupModel {
  final String qrCodeUrl;
  final String secret;
  final List<String> recoveryCodes;

  const TwoFactorSetupModel({
    required this.qrCodeUrl,
    required this.secret,
    this.recoveryCodes = const [],
  });

  factory TwoFactorSetupModel.fromJson(Map<String, dynamic> json) {
    List<String> codes = [];
    if (json['recoveryCodes'] is List) {
      codes = (json['recoveryCodes'] as List).map((e) => e.toString()).toList();
    }
    return TwoFactorSetupModel(
      qrCodeUrl: json['qrCodeUrl']?.toString() ?? '',
      secret: json['secret']?.toString() ?? '',
      recoveryCodes: codes,
    );
  }
}
