import 'package:mobile/core/constants/admin_claims.dart';

class SocialLinksModel {
  final String? gitHub;
  final String? linkedIn;
  final String? twitter;
  final String? facebook;

  const SocialLinksModel({
    this.gitHub,
    this.linkedIn,
    this.twitter,
    this.facebook,
  });

  /// Cleans social link URL for backend validation compatibility.
  /// If empty, whitespace, or invalid placeholder, returns null so ASP.NET [Url] validation passes.
  static String? cleanUrl(String? value, {String? defaultDomain}) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;

    final lower = trimmed.toLowerCase();
    if (lower.contains('username') || lower == 'https://' || lower == 'http://') {
      return null;
    }

    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }

    if (defaultDomain != null && !trimmed.contains('.')) {
      final cleanPath = trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;
      return 'https://$defaultDomain/$cleanPath';
    }

    return 'https://$trimmed';
  }

  factory SocialLinksModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const SocialLinksModel();
    return SocialLinksModel(
      gitHub: json['gitHub']?.toString() ?? json['github']?.toString(),
      linkedIn: json['linkedIn']?.toString() ?? json['linkedin']?.toString(),
      twitter: json['twitter']?.toString(),
      facebook: json['facebook']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'gitHub': cleanUrl(gitHub, defaultDomain: 'github.com'),
        'linkedIn': cleanUrl(linkedIn, defaultDomain: 'linkedin.com/in'),
        'twitter': cleanUrl(twitter, defaultDomain: 'x.com'),
        'facebook': cleanUrl(facebook, defaultDomain: 'facebook.com'),
      };

  SocialLinksModel copyWith({
    String? gitHub,
    String? linkedIn,
    String? twitter,
    String? facebook,
  }) {
    return SocialLinksModel(
      gitHub: gitHub ?? this.gitHub,
      linkedIn: linkedIn ?? this.linkedIn,
      twitter: twitter ?? this.twitter,
      facebook: facebook ?? this.facebook,
    );
  }
}

class UserProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String? title;
  final String? location;
  final String? postalCode;
  final String? phoneNumber;
  final String? about;
  final String? profileImageUrl;
  final DateTime? createdAt;
  final SocialLinksModel socialLinks;
  final List<String> roles;
  final List<String> claims;

  const UserProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.title,
    this.location,
    this.postalCode,
    this.phoneNumber,
    this.about,
    this.profileImageUrl,
    this.createdAt,
    this.socialLinks = const SocialLinksModel(),
    this.roles = const [],
    this.claims = const [],
  });

  /// Formats relative server URLs (e.g. /Images/profiles/abc.jpg) to full absolute URLs
  static String? formatImageUrl(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final clean = raw.trim();
    if (clean.startsWith('http://') || clean.startsWith('https://')) {
      return clean;
    }
    final path = clean.startsWith('/') ? clean.substring(1) : clean;
    return 'https://edulabapi.runasp.net/$path';
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json['createdAt'] != null) {
      try {
        parsedDate = DateTime.parse(json['createdAt'].toString());
      } catch (_) {}
    }

    List<String> rolesList = [];
    if (json['roles'] is List) {
      rolesList = (json['roles'] as List).map((e) => e.toString().trim()).toList();
    } else if (json['Roles'] is List) {
      rolesList = (json['Roles'] as List).map((e) => e.toString().trim()).toList();
    } else if (json['role'] != null) {
      final r = json['role'].toString().trim();
      rolesList = r.contains(',') ? r.split(',').map((s) => s.trim()).toList() : [r];
    } else if (json['Role'] != null) {
      final r = json['Role'].toString().trim();
      rolesList = r.contains(',') ? r.split(',').map((s) => s.trim()).toList() : [r];
    } else if (json['userRole'] != null || json['UserRole'] != null) {
      final r = (json['userRole'] ?? json['UserRole']).toString().trim();
      rolesList = r.contains(',') ? r.split(',').map((s) => s.trim()).toList() : [r];
    }

    List<String> claimsList = [];
    if (json['claims'] is List) {
      claimsList = (json['claims'] as List).map((e) => e.toString().trim()).toList();
    } else if (json['Claims'] is List) {
      claimsList = (json['Claims'] as List).map((e) => e.toString().trim()).toList();
    }

    return UserProfileModel(
      id: json['id']?.toString() ?? json['userId']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      title: json['title']?.toString() ?? json['headline']?.toString(),
      location: json['location']?.toString() ?? json['city']?.toString(),
      postalCode: json['postalCode']?.toString(),
      phoneNumber: json['phoneNumber']?.toString() ?? json['phone']?.toString(),
      about: json['about']?.toString() ?? json['bio']?.toString(),
      profileImageUrl: formatImageUrl(
        json['profileImageUrl']?.toString() ??
            json['avatarUrl']?.toString() ??
            json['imageUrl']?.toString() ??
            json['profileImage']?.toString(),
      ),
      createdAt: parsedDate,
      socialLinks: SocialLinksModel.fromJson(json['socialLinks'] as Map<String, dynamic>?),
      roles: rolesList,
      claims: claimsList,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'title': title,
        'location': location,
        'postalCode': postalCode,
        'phoneNumber': phoneNumber,
        'about': about,
        'profileImageUrl': profileImageUrl,
        'createdAt': createdAt?.toIso8601String(),
        'socialLinks': socialLinks.toJson(),
        'roles': roles,
        'claims': claims,
      };

  String get displayName => fullName.trim().isNotEmpty ? fullName : email.split('@').first;

  String get displayInitials {
    final clean = displayName.trim();
    if (clean.isEmpty) return 'U';
    final parts = clean.split(' ').where((s) => s.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return clean[0].toUpperCase();
  }

  bool get hasAvatar =>
      profileImageUrl != null &&
      profileImageUrl!.trim().isNotEmpty &&
      (profileImageUrl!.startsWith('http://') || profileImageUrl!.startsWith('https://'));

  /// Returns true if user has the Admin role or any Admin panel claim.
  bool get isAdmin =>
      roles.any((r) => r.toLowerCase() == 'admin' || r.toLowerCase() == 'administrator') ||
      hasAdminClaim;

  /// Returns true if user possesses any of the AdminClaims defined in EduLab.
  bool get hasAdminClaim =>
      AdminClaims.hasAnyAdminClaim(claims) || AdminClaims.hasAnyAdminClaim(roles);

  bool get isInstructor => roles.any((r) => r.toLowerCase() == 'instructor');
  bool get isInstructorPending => roles.any((r) => r.toLowerCase() == 'instructorpending');
  bool get isStudent => roles.any((r) => r.toLowerCase() == 'student');

  /// Human-readable primary role label (Arabic / English aware)
  String primaryRoleLabel({bool isArabic = true}) {
    if (isAdmin) {
      return isArabic ? 'مسؤول النظام' : 'Admin';
    }
    if (isInstructor) {
      return isArabic ? 'مدرب' : 'Instructor';
    }
    if (isInstructorPending) {
      return isArabic ? 'طلب مدرب قيد المراجعة' : 'Pending Instructor';
    }
    return isArabic ? 'طالب' : 'Student';
  }

  UserProfileModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? title,
    String? location,
    String? postalCode,
    String? phoneNumber,
    String? about,
    String? profileImageUrl,
    DateTime? createdAt,
    SocialLinksModel? socialLinks,
    List<String>? roles,
    List<String>? claims,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      title: title ?? this.title,
      location: location ?? this.location,
      postalCode: postalCode ?? this.postalCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      about: about ?? this.about,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      socialLinks: socialLinks ?? this.socialLinks,
      roles: roles ?? this.roles,
      claims: claims ?? this.claims,
    );
  }
}

