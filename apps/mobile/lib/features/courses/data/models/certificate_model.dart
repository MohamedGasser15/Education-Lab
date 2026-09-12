import 'package:mobile/core/constants/api_constants.dart';

class CertificateModel {
  final int id;
  final int courseId;
  final String certificateCode;
  final DateTime issuedDate;
  final String studentName;
  final String courseTitle;
  final String verifyUrl;

  const CertificateModel({
    required this.id,
    required this.courseId,
    required this.certificateCode,
    required this.issuedDate,
    required this.studentName,
    required this.courseTitle,
    required this.verifyUrl,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateTime.now();
    if (json['issuedAt'] != null) {
      parsedDate =
          DateTime.tryParse(json['issuedAt'].toString()) ?? DateTime.now();
    } else if (json['issueDate'] != null) {
      parsedDate =
          DateTime.tryParse(json['issueDate'].toString()) ?? DateTime.now();
    } else if (json['createdAt'] != null) {
      parsedDate =
          DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now();
    }

    return CertificateModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      courseId: json['courseId'] is int
          ? json['courseId'] as int
          : int.tryParse(json['courseId']?.toString() ?? '0') ?? 0,
      certificateCode:
          json['certificateCode']?.toString() ??
          json['code']?.toString() ??
          'EL-CERT-${DateTime.now().millisecondsSinceEpoch}',
      issuedDate: parsedDate,
      studentName: json['studentName']?.toString() ?? 'طالب EduLab',
      courseTitle: json['courseTitle']?.toString() ?? 'كورس معتمد',
      verifyUrl: json['verifyUrl']?.toString() ?? '',
    );
  }

  String get formattedDate {
    return '${issuedDate.day.toString().padLeft(2, '0')}/${issuedDate.month.toString().padLeft(2, '0')}/${issuedDate.year}';
  }

  String get fullVerifyUrl {
    if (verifyUrl.isNotEmpty) return verifyUrl;
    return ApiConstants.fullUrl(
      ApiConstants.verifyCertificatePath(certificateCode),
    );
  }

  String get downloadUrl {
    return ApiConstants.fullUrl(
      ApiConstants.downloadCertificatePath(certificateCode),
    );
  }
}
