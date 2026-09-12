import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/courses/data/models/certificate_model.dart';

void main() {
  group('CertificateModel', () {
    test('fromJson parses certificate details correctly', () {
      final json = {
        'id': 1001,
        'courseId': 50,
        'certificateCode': 'EL-CERT-998877',
        'issuedAt': '2026-05-15T00:00:00.000Z',
        'studentName': 'Mohamed Gasser',
        'courseTitle': 'Advanced Mobile Architecture',
        'verifyUrl': 'https://edulab.com/verify/EL-CERT-998877',
      };

      final cert = CertificateModel.fromJson(json);

      expect(cert.id, 1001);
      expect(cert.courseId, 50);
      expect(cert.certificateCode, 'EL-CERT-998877');
      expect(cert.studentName, 'Mohamed Gasser');
      expect(cert.courseTitle, 'Advanced Mobile Architecture');
      expect(cert.verifyUrl, 'https://edulab.com/verify/EL-CERT-998877');
      expect(cert.formattedDate, '15/05/2026');
    });

    test('fullVerifyUrl and downloadUrl compute fallback URLs properly', () {
      final cert = CertificateModel(
        id: 1,
        courseId: 2,
        certificateCode: 'CERT-1234',
        issuedDate: DateTime(2026, 1, 1),
        studentName: 'Student',
        courseTitle: 'Title',
        verifyUrl: '',
      );

      expect(cert.fullVerifyUrl, contains('CERT-1234'));
      expect(cert.downloadUrl, contains('CERT-1234'));
    });
  });
}
