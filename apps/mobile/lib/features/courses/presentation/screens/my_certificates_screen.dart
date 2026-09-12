import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_responsive.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/core/widgets/app_button.dart';
import 'package:mobile/core/widgets/skeleton/skeleton.dart';
import 'package:mobile/features/courses/data/models/certificate_model.dart';
import 'package:mobile/features/courses/presentation/providers/certificates_provider.dart';
import 'package:mobile/features/courses/presentation/screens/certificate_view_screen.dart';

class MyCertificatesScreen extends StatefulWidget {
  const MyCertificatesScreen({super.key});

  @override
  State<MyCertificatesScreen> createState() => _MyCertificatesScreenState();
}

class _MyCertificatesScreenState extends State<MyCertificatesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CertificatesProvider>().fetchMyCertificates();
    });
  }

  Future<void> _loadCertificates() async {
    await context.read<CertificatesProvider>().fetchMyCertificates(forceRefresh: true);
  }

  void _openCertificate(CertificateModel cert) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CertificateViewScreen(
          initialCertificate: cert,
          studentName: cert.studentName,
          courseTitle: cert.courseTitle,
          certificateCode: cert.certificateCode,
          issueDate: cert.formattedDate,
        ),
      ),
    );
  }

  void _copyVerifyLink(CertificateModel cert) {
    Clipboard.setData(ClipboardData(text: cert.fullVerifyUrl));
    HapticFeedback.selectionClick();
    AppSnackbar.showSuccess(context, context.loc.certCopyLinkSuccess);
  }

  void _shareCertificate(CertificateModel cert) {
    Clipboard.setData(
      ClipboardData(
        text: '🎓 ${cert.courseTitle}\n${cert.fullVerifyUrl}',
      ),
    );
    HapticFeedback.mediumImpact();
    AppSnackbar.showSuccess(context, context.loc.certShareSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = AppColors.getBackground(context);
    final cardBg = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textColor = AppColors.getTextPrimary(context);
    final textSubColor = AppColors.getTextSecondary(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final provider = context.watch<CertificatesProvider>();
    final certificates = provider.certificates;
    final isLoading = provider.isLoading;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            isRtl ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
            color: textColor,
          ),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacementNamed('/main');
            }
          },
        ),
        title: Text(
          context.loc.certTitle,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: textColor,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadCertificates,
        color: AppColors.primary,
        child: isLoading && certificates.isEmpty
            ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  AppResponsive.screenPadding(context),
                  16,
                  AppResponsive.screenPadding(context),
                  120,
                ),
                itemCount: 4,
                itemBuilder: (context, index) => const SkeletonCertificateCard(),
              )
            : certificates.isEmpty
                ? _buildEmptyState(textColor, textSubColor, isDark)
                : ListView(
                    physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                    padding: EdgeInsets.fromLTRB(
                      AppResponsive.screenPadding(context),
                      16,
                      AppResponsive.screenPadding(context),
                      120,
                    ),
                    children: [
                      // 1. Header Banner
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBBF24).withValues(alpha: 0.18),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFFBBF24), width: 1.5),
                              ),
                              child: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFFBBF24), size: 30),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${context.loc.myCertificatesBannerTitle} (${certificates.length})',
                                    style: const TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    context.loc.myCertificatesBannerSubtitle,
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      color: Color(0xFF94A3B8),
                                      fontFamily: 'Tajawal',
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // 2. Certificates List
                      for (final cert in certificates) ...[
                        _buildCertificateCard(cert, cardBg, borderColor, textColor, textSubColor, isDark),
                        const SizedBox(height: 14),
                      ],
                    ],
                  ),
      ),
    );
  }

  Widget _buildCertificateCard(
    CertificateModel cert,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openCertificate(cert),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: verified badge & code
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0D3320) : const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDark ? const Color(0xFF059669) : const Color(0xFFA7F3D0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified_rounded, size: 14, color: Color(0xFF059669)),
                          const SizedBox(width: 4),
                          Text(
                            context.loc.certBadgeVerified100,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF059669),
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: cert.certificateCode));
                            HapticFeedback.selectionClick();
                            AppSnackbar.showSuccess(context, context.loc.certCodeCopied);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    cert.certificateCode,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Inter',
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.copy_rounded, size: 12, color: AppColors.primary),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Course Title
                Text(
                  cert.courseTitle,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: 'Tajawal',
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 8),

                // Student & Date
                Row(
                  children: [
                    Icon(Icons.person_outline_rounded, size: 15, color: textSubColor),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${context.loc.certGrantedTo}: ${cert.studentName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11.5, color: textSubColor, fontFamily: 'Tajawal'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.calendar_today_outlined, size: 13, color: textSubColor),
                    const SizedBox(width: 4),
                    Text(
                      cert.formattedDate,
                      style: TextStyle(fontSize: 11, color: textSubColor, fontFamily: 'Tajawal'),
                    ),
                  ],
                ),

                Divider(height: 24, color: isDark ? AppColors.darkDivider : const Color(0xFFF1F5F9)),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        height: 42,
                        borderRadius: 10,
                        icon: const Icon(Icons.remove_red_eye_rounded, size: 16, color: Colors.white),
                        label: context.loc.certViewAndDownload,
                        fontSize: 12,
                        onPressed: () => _openCertificate(cert),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFEFF4FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        tooltip: context.loc.certCopyVerifyLink,
                        onPressed: () => _copyVerifyLink(cert),
                        icon: const Icon(Icons.link_rounded, size: 20, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFEFF4FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        tooltip: context.loc.certShare,
                        onPressed: () => _shareCertificate(cert),
                        icon: const Icon(Icons.share_outlined, size: 19, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color textColor, Color textSubColor, bool isDark) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFFFFBEB),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFDE68A)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(Icons.workspace_premium_rounded, size: 44, color: Color(0xFFD97706)),
              ),
              const SizedBox(height: 24),
              Text(
                context.loc.certEmptyTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                context.loc.certEmptyDesc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.6,
                  color: textSubColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: 220,
                child: AppButton(
                  label: context.loc.certEmptyAction,
                  icon: const Icon(Icons.play_lesson_outlined, size: 18, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/main');
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
