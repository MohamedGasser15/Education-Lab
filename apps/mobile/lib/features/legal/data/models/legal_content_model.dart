class LegalContentModel {
  final String type;
  final String title;
  final String subtitle;
  final String lastUpdated;
  final String appVersion;
  final String contactEmail;
  final String websiteUrl;
  final List<LegalSectionModel> sections;

  LegalContentModel({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.lastUpdated,
    required this.appVersion,
    required this.contactEmail,
    required this.websiteUrl,
    required this.sections,
  });

  factory LegalContentModel.fromJson(Map<String, dynamic> json) {
    return LegalContentModel(
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      lastUpdated: json['lastUpdated'] as String? ?? '',
      appVersion: json['appVersion'] as String? ?? '1.0.0',
      contactEmail: json['contactEmail'] as String? ?? 'support@edulab.com',
      websiteUrl: json['websiteUrl'] as String? ?? 'https://edulabapi.runasp.net',
      sections: (json['sections'] as List<dynamic>?)
              ?.map((e) => LegalSectionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'subtitle': subtitle,
      'lastUpdated': lastUpdated,
      'appVersion': appVersion,
      'contactEmail': contactEmail,
      'websiteUrl': websiteUrl,
      'sections': sections.map((e) => e.toJson()).toList(),
    };
  }
}

class LegalSectionModel {
  final String title;
  final String content;
  final String? icon;
  final List<String> bulletPoints;

  LegalSectionModel({
    required this.title,
    required this.content,
    this.icon,
    this.bulletPoints = const [],
  });

  factory LegalSectionModel.fromJson(Map<String, dynamic> json) {
    return LegalSectionModel(
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      icon: json['icon'] as String?,
      bulletPoints: (json['bulletPoints'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'icon': icon,
      'bulletPoints': bulletPoints,
    };
  }
}
