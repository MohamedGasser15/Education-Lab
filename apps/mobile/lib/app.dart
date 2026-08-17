import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'core/services/locale_service.dart';
import 'l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/main/presentation/screens/main_navigation_screen.dart';
import 'features/cart/presentation/screens/cart_screen.dart';
import 'features/cart/presentation/screens/checkout_screen.dart';
import 'features/inbox/presentation/screens/notifications_screen.dart';
import 'features/inbox/presentation/screens/messages_screen.dart';
import 'features/wishlist/presentation/screens/wishlist_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/profile/presentation/screens/settings_screen.dart';
import 'features/learning/presentation/screens/learning_screen.dart';
import 'features/courses/presentation/screens/course_details_screen.dart';
import 'features/courses/presentation/screens/lesson_player_screen.dart';
import 'features/courses/presentation/screens/quiz_screen.dart';
import 'features/courses/presentation/screens/assignments_screen.dart';
import 'features/courses/presentation/screens/schedule_screen.dart';
import 'features/courses/presentation/screens/certificate_view_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const List<Locale> _supportedLocales = [Locale('ar', 'SA'), Locale('en', 'US')];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocaleService()..loadLocale(),
      child: Consumer<LocaleService>(
        builder: (context, localeService, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'EduLab',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,

            locale: DevicePreview.locale(context) ?? localeService.locale,
            supportedLocales:
                AppLocalizations.supportedLocales.isEmpty
                    ? _supportedLocales
                    : AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            initialRoute: '/',
            routes: {
              '/': (context) => const OnboardingScreen(),
              '/login': (context) => const LoginScreen(),
              '/main': (context) => const MainNavigationScreen(),
              '/cart': (context) => const CartScreen(),
              '/checkout': (context) => const CheckoutScreen(),
              '/notifications': (context) => const NotificationsScreen(),
              '/messages': (context) => const MessagesScreen(),
              '/wishlist': (context) => const WishlistScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/learning': (context) => const LearningScreen(),
              '/course-details': (context) => const CourseDetailsScreen(),
              '/lesson-player': (context) => const LessonPlayerScreen(),
              '/quiz': (context) => const QuizScreen(),
              '/assignments': (context) => const AssignmentsScreen(),
              '/schedule': (context) => const ScheduleScreen(),
              '/certificate_view': (context) => const CertificateViewScreen(),
            },
          );
        },
      ),
    );
  }
}