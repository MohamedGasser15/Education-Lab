import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/profile/presentation/providers/teach_application_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TeachApplicationProvider Wizard Steps & Skills', () {
    late TeachApplicationProvider provider;

    setUp(() {
      provider = TeachApplicationProvider();
    });

    test('wizard step navigation moves forward and backward within [1..3]', () {
      expect(provider.currentStep, 1);

      provider.nextStep();
      expect(provider.currentStep, 2);

      provider.nextStep();
      expect(provider.currentStep, 3);

      provider.nextStep(); // Should not exceed 3
      expect(provider.currentStep, 3);

      provider.prevStep();
      expect(provider.currentStep, 2);

      provider.prevStep();
      expect(provider.currentStep, 1);

      provider.prevStep(); // Should not go below 1
      expect(provider.currentStep, 1);
    });

    test('addSkill and removeSkill manage skills list correctly', () {
      expect(provider.skills, isEmpty);

      provider.addSkill('Flutter');
      provider.addSkill('Dart');
      provider.addSkill('Flutter'); // Duplicate ignored

      expect(provider.skills.length, 2);
      expect(provider.skills, contains('Flutter'));
      expect(provider.skills, contains('Dart'));

      provider.removeSkill('Dart');
      expect(provider.skills.length, 1);
      expect(provider.skills, isNot(contains('Dart')));
    });

    test('setSpecialization and setExperience update properties', () {
      provider.setSpecialization('Mobile Development');
      expect(provider.specialization, 'Mobile Development');

      provider.setExperience('5+');
      expect(provider.experience, '5+');

      provider.setAgreeTerms(true);
      expect(provider.agreeTerms, isTrue);
    });

    test('resetFormForNewApplication resets wizard state', () {
      provider.nextStep();
      provider.addSkill('Swift');
      provider.setAgreeTerms(true);

      provider.resetFormForNewApplication();

      expect(provider.currentStep, 1);
      expect(provider.skills, isEmpty);
      expect(provider.agreeTerms, isFalse);
      expect(provider.isReapplying, isTrue);
    });
  });
}
