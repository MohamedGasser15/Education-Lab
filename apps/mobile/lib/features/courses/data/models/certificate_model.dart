class CertificateModel {
  final int id;
  final int enrollmentId;
  final String certificateCode;
  final String pdfPath;
  final DateTime issuedDate;
  final String studentName;
  final String courseTitle;
  final String verifyUrl;

  const CertificateModel({
    required this.id,
    required this.enrollmentId,
    required this.certificateCode,
    required this.pdfPath,
    required this.issuedDate,
    required this.studentName,
    required this.courseTitle,
    required this.verifyUrl,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateTime.now();
    if (json['issuedDate'] != null || json['createdAt'] != null || json['date'] != null) {
      try {
        parsedDate = DateTime.parse(
          (json['issuedDate'] ?? json['createdAt'] ?? json['date']).toString(),
        );
      } catch (_) {}
    }

    return CertificateModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      enrollmentId: int.tryParse(json['enrollmentId']?.toString() ?? '0') ?? 0,
      certificateCode: json['certificateCode']?.toString() ?? 'EL-${DateTime.now().millisecondsSinceEpoch}',
      pdfPath: json['pdfPath']?.toString() ?? '',
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
    return 'https://edulabapi.runasp.net/api/Certificates/verify/$certificateCode';
  }

  String get downloadUrl {
    return 'https://edulabapi.runasp.net/api/Certificates/download/$certificateCode';
  }
}
