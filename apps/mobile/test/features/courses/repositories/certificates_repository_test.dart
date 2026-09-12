import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/courses/data/models/certificate_model.dart';
import 'package:mobile/features/courses/data/repositories/certificates_repository.dart';
import 'package:mobile/features/courses/data/services/certificates_api_service.dart';

class FakeCertificatesApiService extends CertificatesApiService {
  @override
  Future<Result<List<CertificateModel>>> getMyCertificates() async {
    return Success([
      CertificateModel(
        id: 1,
        certificateCode: 'CERT-100',
        courseId: 5,
        courseTitle: 'Flutter Expert',
        studentName: 'Mohamed Gasser',
        issuedDate: DateTime(2026, 1, 1),
        verifyUrl: 'https://edulab.com/verify/CERT-100',
      ),
    ]);
  }

  @override
  Future<Result<Map<String, dynamic>>> verifyCertificate(String code) async {
    return const Success({'valid': true, 'certificateCode': 'CERT-100'});
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CertificatesRepository Tests', () {
    late CertificatesRepository repository;
    late FakeCertificatesApiService fakeService;

    setUp(() {
      fakeService = FakeCertificatesApiService();
      repository = CertificatesRepository(apiService: fakeService);
    });

    test('getMyCertificates returns certificate models', () async {
      final res = await repository.getMyCertificates();
      expect(res is Success<List<CertificateModel>>, isTrue);
      if (res is Success<List<CertificateModel>>) {
        expect(res.data.length, 1);
        expect(res.data.first.certificateCode, 'CERT-100');
      }
    });

    test('verifyCertificate returns verification payload', () async {
      final res = await repository.verifyCertificate('CERT-100');
      expect(res is Success<Map<String, dynamic>>, isTrue);
      expect((res as Success<Map<String, dynamic>>).data['valid'], isTrue);
    });
  });
}
