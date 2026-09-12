import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/home/data/models/instructor_profile_model.dart';

/// Data holder for an individual instructor social link item.
class InstructorSocialItem {
  final Widget icon;
  final String label;
  final String url;
  final Color brandColor;

  const InstructorSocialItem({
    required this.icon,
    required this.label,
    required this.url,
    required this.brandColor,
  });
}

/// Modular widget that displays formatted social media quick links for an instructor.
class InstructorProfileSocialLinks extends StatelessWidget {
  final InstructorProfileModel profile;
  final bool isDark;
  final Color borderColor;
  final Color textColor;
  final ValueChanged<String> onOpenUrl;

  const InstructorProfileSocialLinks({
    super.key,
    required this.profile,
    required this.isDark,
    required this.borderColor,
    required this.textColor,
    required this.onOpenUrl,
  });

  @override
  Widget build(BuildContext context) {
    final items = <InstructorSocialItem>[
      if (profile.linkedInUrl != null && profile.linkedInUrl!.trim().isNotEmpty)
        InstructorSocialItem(
          icon: const FaIcon(
            FontAwesomeIcons.linkedin,
            size: 18,
            color: Color(0xFF0A66C2),
          ),
          label: 'LinkedIn',
          url: profile.linkedInUrl!,
          brandColor: const Color(0xFF0A66C2),
        ),
      if (profile.gitHubUrl != null && profile.gitHubUrl!.trim().isNotEmpty)
        InstructorSocialItem(
          icon: FaIcon(
            FontAwesomeIcons.github,
            size: 18,
            color: isDark ? Colors.white : const Color(0xFF24292F),
          ),
          label: 'GitHub',
          url: profile.gitHubUrl!,
          brandColor: isDark ? Colors.white70 : const Color(0xFF24292F),
        ),
      if (profile.twitterUrl != null && profile.twitterUrl!.trim().isNotEmpty)
        InstructorSocialItem(
          icon: FaIcon(
            FontAwesomeIcons.xTwitter,
            size: 17,
            color: isDark ? Colors.white : const Color(0xFF0F1419),
          ),
          label: 'X (Twitter)',
          url: profile.twitterUrl!,
          brandColor: isDark ? Colors.white70 : const Color(0xFF0F1419),
        ),
      if (profile.websiteUrl != null && profile.websiteUrl!.trim().isNotEmpty)
        InstructorSocialItem(
          icon: const Icon(
            Icons.language_rounded,
            size: 19,
            color: AppColors.primary,
          ),
          label: context.loc.instructorProfileWebsite,
          url: profile.websiteUrl!,
          brandColor: AppColors.primary,
        ),
      if (profile.facebookUrl != null && profile.facebookUrl!.trim().isNotEmpty)
        InstructorSocialItem(
          icon: const FaIcon(
            FontAwesomeIcons.facebook,
            size: 18,
            color: Color(0xFF1877F2),
          ),
          label: 'Facebook',
          url: profile.facebookUrl!,
          brandColor: const Color(0xFF1877F2),
        ),
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    final bool distributeEqually = items.length >= 3;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Row(
        mainAxisAlignment: distributeEqually
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            if (distributeEqually)
              Expanded(child: _buildSocialButtonItem(items[i]))
            else
              SizedBox(width: 96, child: _buildSocialButtonItem(items[i])),
          ],
        ],
      ),
    );
  }

  Widget _buildSocialButtonItem(InstructorSocialItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onOpenUrl(item.url);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.1) : borderColor,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: item.brandColor.withValues(
                    alpha: isDark ? 0.16 : 0.08,
                  ),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: item.icon,
              ),
              const SizedBox(height: 6),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
