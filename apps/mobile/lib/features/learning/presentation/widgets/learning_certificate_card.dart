import 'package:flutter/material.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/widgets/app_button.dart';
import 'package:mobile/features/courses/data/models/certificate_model.dart';
import 'package:mobile/features/courses/presentation/screens/certificate_view_screen.dart';

/// Card widget that displays an earned completion certificate with a view button.
class LearningCertificateCard extends StatelessWidget {
  final CertificateModel cert;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final Color textSubColor;
  final bool isDark;
  final bool isAr;

  const LearningCertificateCard({
    super.key,
    required this.cert,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.textSubColor,
    required this.isDark,
    required this.isAr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(
                0xFFF59E0B,
              ).withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: Color(0xFFD97706),
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cert.courseTitle,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: 'Tajawal',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  context.loc.learningCertIssuedDate(cert.formattedDate),
                  style: TextStyle(
                    fontSize: 10.5,
                    color: textSubColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: context.loc.learningCertView,
            width: null,
            height: 30,
            fontSize: 11,
            borderRadius: 6,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CertificateViewScreen(initialCertificate: cert),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
