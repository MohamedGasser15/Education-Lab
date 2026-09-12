import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/legal/data/models/legal_content_model.dart';

void main() {
  group('LegalContentModel & LegalSectionModel', () {
    test('fromJson parses legal sections, bullet points, and metadata', () {
      final json = {
        'type': 'PrivacyPolicy',
        'title': 'سياسة الخصوصية',
        'subtitle': 'حماية بيانات المستخدمين',
        'lastUpdated': '2026-09-01',
        'sections': [
          {
            'title': 'جمع البيانات',
            'content': 'نحن نجمع البيانات لتحسين تجربتك.',
            'bulletPoints': ['الاسم', 'البريد الإلكتروني'],
          }
        ]
      };

      final legal = LegalContentModel.fromJson(json);

      expect(legal.type, 'PrivacyPolicy');
      expect(legal.title, 'سياسة الخصوصية');
      expect(legal.lastUpdated, '2026-09-01');
      expect(legal.sections.length, 1);
      expect(legal.sections.first.title, 'جمع البيانات');
      expect(legal.sections.first.bulletPoints.length, 2);
    });

    test('toJson serializes model back to Map', () {
      final model = LegalContentModel(
        type: 'Terms',
        title: 'الشروط والأحكام',
        subtitle: 'قواعد الاستخدام',
        lastUpdated: '2026-01-01',
        appVersion: '1.0.0',
        contactEmail: 'legal@edulab.com',
        websiteUrl: 'https://edulab.com',
        sections: [
          LegalSectionModel(
            title: 'الاستخدام المقبول',
            content: 'ممنوع مشاركة الحسابات.',
          ),
        ],
      );

      final json = model.toJson();

      expect(json['type'], 'Terms');
      expect(json['title'], 'الشروط والأحكام');
      expect(json['sections'], isA<List>());
      expect((json['sections'] as List).length, 1);
    });
  });
}
