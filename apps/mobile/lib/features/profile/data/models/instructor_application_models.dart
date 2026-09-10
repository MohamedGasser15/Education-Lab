import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/core/constants/api_constants.dart';

/// DTO for submitting an instructor application matching backend schema
class InstructorApplicationDTO {
  final String fullName;
  final String? email;
  final String phone;
  final String bio;
  final String specialization;
  final String experience;
  final List<String> skills;
  final XFile? profileImage;
  final XFile? cvFile;

  const InstructorApplicationDTO({
    required this.fullName,
    this.email,
    required this.phone,
    required this.bio,
    required this.specialization,
    required this.experience,
    required this.skills,
    this.profileImage,
    this.cvFile,
  });

  InstructorApplicationDTO copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? bio,
    String? specialization,
    String? experience,
    List<String>? skills,
    XFile? profileImage,
    XFile? cvFile,
  }) {
    return InstructorApplicationDTO(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      specialization: specialization ?? this.specialization,
      experience: experience ?? this.experience,
      skills: skills ?? this.skills,
      profileImage: profileImage ?? this.profileImage,
      cvFile: cvFile ?? this.cvFile,
    );
  }
}

/// Response DTO from GET /api/InstructorApplication/my-applications
class InstructorApplicationResponseDto {
  final String id;
  final String? fullName;
  final String? email;
  final String? specialization;
  final String? experience;
  final String status;
  final String? rejectionReason;
  final DateTime? appliedDate;
  final String? cvUrl;

  const InstructorApplicationResponseDto({
    required this.id,
    this.fullName,
    this.email,
    this.specialization,
    this.experience,
    required this.status,
    this.rejectionReason,
    this.appliedDate,
    this.cvUrl,
  });

  factory InstructorApplicationResponseDto.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json['appliedDate'] != null) {
      try {
        parsedDate = DateTime.parse(json['appliedDate'].toString());
      } catch (_) {}
    }

    final rawCv = json['cvUrl']?.toString();
    String? formattedCv;
    if (rawCv != null && rawCv.isNotEmpty) {
      formattedCv = ApiConstants.formatImageUrl(rawCv);
    }

    return InstructorApplicationResponseDto(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString(),
      email: json['email']?.toString(),
      specialization: json['specialization']?.toString(),
      experience: json['experience']?.toString(),
      status: json['status']?.toString() ?? 'Pending',
      rejectionReason: json['rejectionReason']?.toString(),
      appliedDate: parsedDate,
      cvUrl: formattedCv,
    );
  }

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isApproved => status.toLowerCase() == 'approved';
  bool get isRejected => status.toLowerCase() == 'rejected';

  String get statusDisplay {
    if (isApproved) return 'تم القبول';
    if (isRejected) return 'مرفوض';
    return 'قيد المراجعة';
  }

  Color get statusColor {
    if (isApproved) return const Color(0xFF059669);
    if (isRejected) return const Color(0xFFEF4444);
    return const Color(0xFFF59E0B);
  }

  Color get statusBgColor {
    if (isApproved) return const Color(0xFFECFDF5);
    if (isRejected) return const Color(0xFFFEF2F2);
    return const Color(0xFFFFFBEB);
  }

  String get experienceDisplay {
    switch (experience) {
      case '0-2':
        return 'أقل من سنتين';
      case '2-5':
        return 'من سنتين إلى 5 سنوات';
      case '5-10':
        return 'من 5 إلى 10 سنوات';
      case '10+':
        return 'أكثر من 10 سنوات';
      default:
        return experience ?? '-';
    }
  }
}
