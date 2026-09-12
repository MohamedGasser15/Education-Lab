import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/features/legal/data/models/legal_content_model.dart';

class LegalApiService {
  final ApiClient _apiClient;

  LegalApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// GET /api/Legal/about?language=ar|en
  Future<Result<LegalContentModel>> getAbout({String? language}) async {
    return _fetchLegalDoc(ApiConstants.legalAbout, 'about', language);
  }

  /// GET /api/Legal/privacy-policy?language=ar|en
  Future<Result<LegalContentModel>> getPrivacyPolicy({String? language}) async {
    return _fetchLegalDoc(ApiConstants.legalPrivacy, 'privacy', language);
  }

  /// GET /api/Legal/terms?language=ar|en
  Future<Result<LegalContentModel>> getTermsOfService({String? language}) async {
    return _fetchLegalDoc(ApiConstants.legalTerms, 'terms', language);
  }

  /// GET /api/Legal/all?language=ar|en
  Future<Result<Map<String, LegalContentModel>>> getAllLegalInfo({String? language}) async {
    try {
      final queryParams = language != null ? {'language': language} : null;
      final result = await _apiClient.getSafe(
        ApiConstants.legalAll,
        queryParameters: queryParams,
      );

      if (result is Success) {
        dynamic data = result.data;
        if (data is String && data.isNotEmpty) {
          try {
            data = json.decode(data);
          } catch (_) {}
        }

        if (data is Map<String, dynamic>) {
          final map = <String, LegalContentModel>{};
          data.forEach((key, value) {
            if (value is Map<String, dynamic>) {
              map[key] = LegalContentModel.fromJson(value);
            }
          });
          if (map.isNotEmpty) {
            return Success(map);
          }
        }
      }

      // Fallback
      return Success(getDefaultLegalMap(language: language));
    } catch (e) {
      debugPrint('LegalApiService.getAllLegalInfo error: $e');
      return Success(getDefaultLegalMap(language: language));
    }
  }

  Future<Result<LegalContentModel>> _fetchLegalDoc(
    String endpoint,
    String type,
    String? language,
  ) async {
    try {
      final queryParams = language != null ? {'language': language} : null;
      final result = await _apiClient.getSafe(
        endpoint,
        queryParameters: queryParams,
      );

      if (result is Success) {
        dynamic data = result.data;
        if (data is String && data.isNotEmpty) {
          try {
            data = json.decode(data);
          } catch (_) {}
        }

        if (data is Map<String, dynamic>) {
          final model = LegalContentModel.fromJson(data);
          return Success(model);
        }
      }

      return Success(getDefaultDoc(type, language: language));
    } catch (e) {
      debugPrint('LegalApiService._fetchLegalDoc ($type) error: $e');
      return Success(getDefaultDoc(type, language: language));
    }
  }

  static Map<String, LegalContentModel> getDefaultLegalMap({String? language}) {
    return {
      'about': getDefaultDoc('about', language: language),
      'privacy': getDefaultDoc('privacy', language: language),
      'terms': getDefaultDoc('terms', language: language),
    };
  }

  static LegalContentModel getDefaultDoc(String type, {String? language}) {
    final isArabic = (language ?? '').toLowerCase().startsWith('ar') || language == null;
    switch (type.toLowerCase()) {
      case 'about':
        return isArabic ? _defaultAboutArabic() : _defaultAboutEnglish();
      case 'privacy':
      case 'privacy-policy':
        return isArabic ? _defaultPrivacyArabic() : _defaultPrivacyEnglish();
      case 'terms':
      case 'terms-of-service':
      default:
        return isArabic ? _defaultTermsArabic() : _defaultTermsEnglish();
    }
  }

  static LegalContentModel _defaultAboutArabic() {
    return LegalContentModel(
      type: 'about',
      title: 'عن منصة EduLab',
      subtitle: 'المنصة التعليمية الرائدة للتعلم الذكي وتطوير المهارات العملية',
      lastUpdated: 'سبتمبر 2026',
      appVersion: '1.0.0',
      contactEmail: 'support@edulab.com',
      websiteUrl: 'https://edulabapi.runasp.net',
      sections: [
        LegalSectionModel(
          title: 'من نحن',
          content:
              'EduLab هي بيئة تعليمية تفاعلية متكاملة تهدف إلى تمكين الطلاب والمهنيين من اكتساب مهارات المستقبل بأعلى جودة ممكنة وبأسلوب تعليمي عملي وممتع.',
          icon: 'info',
          bulletPoints: [
            'مسارات تعليمية شاملة في البرمجة والتصميم وإدارة الأعمال.',
            'سد الفجوة بين التعليم الأكاديمي واحتياجات سوق العمل.',
            'إتاحة التعلم للجميع في أي وقت ومن أي مكان عبر تطبيقات الموبايل والويب.',
          ],
        ),
        LegalSectionModel(
          title: 'رؤيتنا ورسالتنا',
          content:
              'نؤمن بأن التعليم هو المحرك الأساسي لبناء المستقبل، ولذلك نسعى لإعادة ابتكار تجربة التعلم الرقمي من خلال الجمع بين التكنولوجيا المتطورة والمحتوى المميز.',
          icon: 'rocket',
          bulletPoints: [
            'الريادة في تقديم تجارب تعليمية ذكية وتفاعلية.',
            'تمكين المحاضرين والخبراء من مشاركة معرفتهم وتدريب أجيال جديدة.',
            'الالتزام بأعلى معايير الجودة والمصداقية في المحتوى والشهادات.',
          ],
        ),
        LegalSectionModel(
          title: 'ما الذي يميز منصة EduLab؟',
          content: 'تم تصميم المنصة لتوفير تجربة تعليمية فائقة السلاسة والقوة:',
          icon: 'star',
          bulletPoints: [
            'محتوى تدريبي يركز على التطبيق العملي والمشاريع الحقيقية.',
            'شهادات إتمام رقمية معتمدة ومؤمنة برمز QR للتحقق الفوري.',
            'نظام تفاعلي متكامل للأسئلة والنقاشات المباشرة تحت كل محاضرة.',
            'تتبع دقيق للتقدم الدراسي مع تذكيرات ذكية لمواصلة التعلم.',
          ],
        ),
      ],
    );
  }

  static LegalContentModel _defaultAboutEnglish() {
    return LegalContentModel(
      type: 'about',
      title: 'About EduLab',
      subtitle: 'The premier learning platform for practical skill development and interactive education',
      lastUpdated: 'September 2026',
      appVersion: '1.0.0',
      contactEmail: 'support@edulab.com',
      websiteUrl: 'https://edulabapi.runasp.net',
      sections: [
        LegalSectionModel(
          title: 'Who We Are',
          content:
              'EduLab is a modern learning ecosystem designed to empower students, creators, and professionals worldwide with cutting-edge skills through engaging and practical courses.',
          icon: 'info',
          bulletPoints: [
            'Comprehensive learning tracks in Software Engineering, Design, Business, and AI.',
            'Bridging the gap between academic theories and industry job market requirements.',
            'Seamless cross-platform learning on Mobile and Web anywhere, anytime.',
          ],
        ),
        LegalSectionModel(
          title: 'Our Vision & Mission',
          content:
              'We believe quality education transforms lives. We are committed to making top-tier education accessible, engaging, and directly impactful.',
          icon: 'rocket',
          bulletPoints: [
            'Pioneering smart, personalized learning journeys tailored to every learner.',
            'Empowering industry leaders and instructors to teach at global scale.',
            'Upholding the highest standards of course quality and certified credentialing.',
          ],
        ),
      ],
    );
  }

  static LegalContentModel _defaultPrivacyArabic() {
    return LegalContentModel(
      type: 'privacy',
      title: 'سياسة الخصوصية',
      subtitle: 'نلتزم بحماية خصوصيتك وبياناتك الشخصية بأعلى معايير الأمان الدولية',
      lastUpdated: 'سبتمبر 2026',
      appVersion: '1.0.0',
      contactEmail: 'support@edulab.com',
      websiteUrl: 'https://edulabapi.runasp.net',
      sections: [
        LegalSectionModel(
          title: 'مقدمة والتزامنا',
          content:
              'في منصة EduLab، نعتبر خصوصية وأمان بياناتك الشخصية من أهم أولوياتنا. توضح هذه الوثيقة ماهية البيانات التي نجمعها وكيفية معالجتها لحمايتك.',
          icon: 'shield',
        ),
        LegalSectionModel(
          title: 'البيانات التي نجمعها',
          content: 'نقوم بجمع البيانات الضرورية فقط لتقديم تجربة تعليمية مخصصة وآمنة:',
          icon: 'database',
          bulletPoints: [
            'بيانات الحساب الأساسية: الاسم، البريد الإلكتروني، الصورة الشخصية.',
            'البيانات التعليمية: الكورسات المسجل بها، سجل التقدم، والاختبارات المكتملة.',
            'البيانات التقنية: نوع الجهاز، نظام التشغيل، ورمز الإشعارات (FCM Token).',
          ],
        ),
        LegalSectionModel(
          title: 'أمان وتشفير البيانات',
          content:
              'نطبق بروتوكولات حماية متقدمة بما في ذلك التشفير الكامل (TLS/SSL) لجميع الاتصالات وتشفير كلمات المرور والبيانات الحساسة على خوادمنا.',
          icon: 'lock',
        ),
      ],
    );
  }

  static LegalContentModel _defaultPrivacyEnglish() {
    return LegalContentModel(
      type: 'privacy',
      title: 'Privacy Policy',
      subtitle: 'Committed to safeguarding your personal data with top-tier security standards',
      lastUpdated: 'September 2026',
      appVersion: '1.0.0',
      contactEmail: 'support@edulab.com',
      websiteUrl: 'https://edulabapi.runasp.net',
      sections: [
        LegalSectionModel(
          title: 'Introduction & Commitment',
          content:
              'At EduLab, protecting your privacy and securing your personal information is paramount. This policy outlines how we collect, handle, and safeguard your data.',
          icon: 'shield',
        ),
        LegalSectionModel(
          title: 'Information We Collect',
          content: 'We only collect essential data required to provide a personalized and secure learning experience:',
          icon: 'database',
          bulletPoints: [
            'Account Information: Name, email address, and optional avatar.',
            'Learning Progress: Enrolled courses, lecture completion, quizzes, and certificates.',
            'Technical Diagnostics: Device type, OS version, and FCM notification push tokens.',
          ],
        ),
      ],
    );
  }

  static LegalContentModel _defaultTermsArabic() {
    return LegalContentModel(
      type: 'terms',
      title: 'شروط وأحكام الاستخدام',
      subtitle: 'القواعد والبنود المنظمة لاستخدام منصة وخدمات EduLab التعليمية',
      lastUpdated: 'سبتمبر 2026',
      appVersion: '1.0.0',
      contactEmail: 'support@edulab.com',
      websiteUrl: 'https://edulabapi.runasp.net',
      sections: [
        LegalSectionModel(
          title: 'الموافقة على الشروط',
          content:
              'باستخدامك لتطبيق أو موقع EduLab، فإنك تقر وتوافق على الالتزام الكامل بهذه الشروط والأحكام وسياسة الخصوصية الخاصة بنا.',
          icon: 'document',
        ),
        LegalSectionModel(
          title: 'حساب المستخدم والأمان',
          content: 'المستخدم مسؤول مسؤولية كاملة عن الحفاظ على سرية حسابه وكلمة المرور الخاصة به.',
          icon: 'user',
          bulletPoints: [
            'يُمنع مشاركة بيانات الحساب مع أطراف خارجية.',
            'يجب إخطار الدعم الفني فوراً في حال الاشتباه بأي وصول غير مصرح به.',
          ],
        ),
        LegalSectionModel(
          title: 'حقوق الملكية الفكرية',
          content:
              'جميع المحاضرات والمواد التعليمية والتصميمات والعلامات التجارية محمية بموجب قوانين الملكية الفكرية وحقوق النشر الدولية.',
          icon: 'copyright',
        ),
      ],
    );
  }

  static LegalContentModel _defaultTermsEnglish() {
    return LegalContentModel(
      type: 'terms',
      title: 'Terms of Service',
      subtitle: 'Terms and conditions governing the use of EduLab platform and educational services',
      lastUpdated: 'September 2026',
      appVersion: '1.0.0',
      contactEmail: 'support@edulab.com',
      websiteUrl: 'https://edulabapi.runasp.net',
      sections: [
        LegalSectionModel(
          title: 'Acceptance of Terms',
          content:
              'By accessing or using EduLab applications or website, you acknowledge and agree to be bound by these Terms of Service.',
          icon: 'document',
        ),
        LegalSectionModel(
          title: 'User Account & Security',
          content: 'You are responsible for maintaining the confidentiality of your credentials and account activities.',
          icon: 'user',
          bulletPoints: [
            'Account sharing or unauthorized distribution of course materials is strictly prohibited.',
            'Notify our support team immediately if you detect unauthorized access.',
          ],
        ),
      ],
    );
  }
}
