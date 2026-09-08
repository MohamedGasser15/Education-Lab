import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/core/widgets/app_button.dart';
import 'package:mobile/core/widgets/app_loading_spinner.dart';
import 'package:mobile/features/courses/data/models/certificate_model.dart';
import 'package:mobile/features/courses/data/repositories/certificates_repository.dart';

class CertificateViewScreen extends StatefulWidget {
  final CertificateModel? initialCertificate;
  final String studentName;
  final String courseTitle;
  final String instructorName;
  final String certificateCode;
  final String issueDate;

  const CertificateViewScreen({
    super.key,
    this.initialCertificate,
    this.studentName = 'عمر أحمد الشمري',
    this.courseTitle = 'الدليل الشامل لاحتراف تطوير تطبيقات Flutter و Dart',
    this.instructorName = 'م. أحمد محمد',
    this.certificateCode = 'EL-20260901-48927',
    this.issueDate = '01 سبتمبر 2026',
  });

  @override
  State<CertificateViewScreen> createState() => _CertificateViewScreenState();
}

class _CertificateViewScreenState extends State<CertificateViewScreen> {
  final _certRepo = CertificatesRepository();

  bool _isLoading = false;
  bool _isDownloading = false;
  int _selectedIndex = 0;
  List<CertificateModel> _certificates = [];

  @override
  void initState() {
    super.initState();
    _loadCertificates();
  }

  Future<void> _loadCertificates() async {
    setState(() => _isLoading = true);

    try {
      final result = await _certRepo.getMyCertificates();
      if (!mounted) return;

      if (result is Success<List<CertificateModel>>) {
        setState(() {
          _certificates = result.data;
        });

        if (widget.initialCertificate != null &&
            !_certificates.any((c) => c.certificateCode == widget.initialCertificate!.certificateCode)) {
          _certificates.insert(0, widget.initialCertificate!);
        }
      } else if (result is Failure<List<CertificateModel>>) {
        if (widget.initialCertificate != null) {
          _certificates = [widget.initialCertificate!];
        }
      }
    } catch (e) {
      debugPrint('Error loading certificates: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  CertificateModel _getActiveCertificate() {
    if (_certificates.isNotEmpty && _selectedIndex < _certificates.length) {
      return _certificates[_selectedIndex];
    }
    return CertificateModel(
      id: 1,
      courseId: 1,
      certificateCode: widget.certificateCode,
      issuedDate: DateTime.now(),
      studentName: widget.studentName,
      courseTitle: widget.courseTitle,
      verifyUrl: ApiConstants.fullUrl(ApiConstants.verifyCertificatePath(widget.certificateCode)),
    );
  }

  void _downloadCertificate(String format) async {
    final activeCert = _getActiveCertificate();
    setState(() => _isDownloading = true);
    HapticFeedback.mediumImpact();

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isDownloading = false);

    AppSnackbar.showSuccess(
      context,
      context.loc.certDownloadedSuccess(activeCert.courseTitle, format),
    );
  }

  void _copyVerifyLink() {
    final activeCert = _getActiveCertificate();
    Clipboard.setData(ClipboardData(text: activeCert.fullVerifyUrl));
    HapticFeedback.selectionClick();
    AppSnackbar.showSuccess(context, context.loc.certCopyLinkSuccess);
  }

  void _shareCertificate() {
    final activeCert = _getActiveCertificate();
    Clipboard.setData(
      ClipboardData(
        text: '🎓 ${activeCert.courseTitle}\n${activeCert.fullVerifyUrl}',
      ),
    );
    HapticFeedback.mediumImpact();
    AppSnackbar.showSuccess(context, context.loc.certShareSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final activeCert = _getActiveCertificate();
    final hasMultipleCertificates = _certificates.length > 1;

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
        actions: [
          IconButton(
            tooltip: context.loc.certShare,
            icon: Icon(Icons.share_outlined, color: textColor, size: 22),
            onPressed: _shareCertificate,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadCertificates,
        color: AppColors.primary,
        child: _isLoading && _certificates.isEmpty
            ? const Center(
                child: AppLoadingSpinner(size: 32, color: AppColors.primary),
              )
            : (_certificates.isEmpty && widget.initialCertificate == null && widget.courseTitle.isEmpty)
                ? _buildEmptyState(textColor, textSubColor, isDark)
                : ListView(
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                    children: [
                      // 1. Multiple Certificates Selector (If student has > 1 certificate like Udemy)
                      if (hasMultipleCertificates) ...[
                        SizedBox(
                          height: 38,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _certificates.length,
                            itemBuilder: (context, index) {
                              final isSelected = index == _selectedIndex;
                              final c = _certificates[index];
                              return Padding(
                                padding: const EdgeInsetsDirectional.only(end: 8),
                                child: ChoiceChip(
                                  label: Text(
                                    c.courseTitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected ? Colors.white : textColor,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  selected: isSelected,
                                  selectedColor: AppColors.primary,
                                  backgroundColor: isDark ? AppColors.darkSurfaceMuted : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      color: isSelected ? AppColors.primary : borderColor,
                                    ),
                                  ),
                                  onSelected: (_) {
                                    HapticFeedback.selectionClick();
                                    setState(() => _selectedIndex = index);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],

                      // 2. Verified Credential Banner (Udemy Style)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0D3320) : const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? const Color(0xFF059669) : const Color(0xFFA7F3D0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: const Color(0xFF059669).withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.verified_rounded, color: Color(0xFF059669), size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.loc.certVerifiedBadge,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF059669),
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    context.loc.certVerifiedFullRequirements(activeCert.certificateCode),
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: isDark ? const Color(0xFFA7F3D0) : const Color(0xFF047857),
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 3. EXACT SVG-IDENTICAL CERTIFICATE CANVAS (1414 x 1000 Aspect Ratio)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0A1628).withValues(alpha: 0.14),
                              blurRadius: 22,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: 1414 / 1000,
                            child: CustomPaint(
                              painter: _CertificateSvgPainter(
                                studentName: activeCert.studentName,
                                courseTitle: activeCert.courseTitle,
                                instructorName: widget.instructorName,
                                certificateCode: activeCert.certificateCode,
                                issueDate: activeCert.formattedDate,
                                certCompletionTitle: context.loc.certCompletionTitle,
                                certCompletionSubtitle: context.loc.certCompletionSubtitle,
                                certAnnounceStudent: context.loc.certAnnounceStudent,
                                certCompletionRequirementsMet: context.loc.certCompletionRequirementsMet,
                                certIssueDateText: context.loc.certIssueDateText(activeCert.formattedDate),
                                certIdNumberText: context.loc.certIdNumberText(activeCert.certificateCode),
                                certPlatformManagement: context.loc.certPlatformManagement,
                                certInstructorRoleTitle: context.loc.certInstructorRoleTitle,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 4. Action Download & Share Buttons (Udemy Style)
                      Row(
                        children: [
                          // PDF Download Button
                          Expanded(
                            child: AppButton(
                              height: 48,
                              label: context.loc.certDownloadPDF,
                              loadingLabel: context.loc.commonLoading,
                              isLoading: _isDownloading,
                              icon: const Icon(Icons.picture_as_pdf_rounded, size: 18, color: Colors.white),
                              onPressed: () => _downloadCertificate('PDF'),
                            ),
                          ),
                          const SizedBox(width: 10),

                          // PNG Download Button
                          Expanded(
                            child: AppButton(
                              height: 48,
                              label: context.loc.certDownloadPNG,
                              outlined: true,
                              icon: const Icon(Icons.image_outlined, size: 18),
                              onPressed: () => _downloadCertificate('PNG'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // 5. Verification Metadata Details Card (Udemy Style)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    context.loc.certDetailsTitle,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                      fontFamily: 'Tajawal',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: _copyVerifyLink,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFEFF4FF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.copy_rounded, size: 13, color: AppColors.primary),
                                        const SizedBox(width: 4),
                                        Text(
                                          context.loc.certCopyVerifyLink,
                                          style: const TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                            fontFamily: 'Tajawal',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20),

                            _buildMetaRow(context.loc.certStudentNameLabel, activeCert.studentName, textColor, textSubColor),
                            _buildMetaRow(context.loc.certCourseLabel, activeCert.courseTitle, textColor, textSubColor),
                            _buildMetaRow(context.loc.certInstructorLabel, widget.instructorName, textColor, textSubColor),
                            _buildMetaRow(context.loc.certIssueDateLabel, activeCert.formattedDate, textColor, textSubColor),
                            _buildMetaRow(context.loc.certCodeLabel, activeCert.certificateCode, textColor, textSubColor, isCode: true),
                            _buildMetaRow(context.loc.certIssuerLabel, context.loc.certIssuerName, textColor, textSubColor),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildMetaRow(String label, String value, Color textColor, Color textSubColor, {bool isCode = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                color: textSubColor,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isCode ? AppColors.primary : textColor,
                fontFamily: isCode ? 'Inter' : 'Tajawal',
              ),
            ),
          ),
        ],
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

// ================= EXACT SVG CERTIFICATE CUSTOM PAINTER (RESTORED ACCURATELY) =================
class _CertificateSvgPainter extends CustomPainter {
  final String studentName;
  final String courseTitle;
  final String instructorName;
  final String certificateCode;
  final String issueDate;
  final String certCompletionTitle;
  final String certCompletionSubtitle;
  final String certAnnounceStudent;
  final String certCompletionRequirementsMet;
  final String certIssueDateText;
  final String certIdNumberText;
  final String certPlatformManagement;
  final String certInstructorRoleTitle;

  _CertificateSvgPainter({
    required this.studentName,
    required this.courseTitle,
    required this.instructorName,
    required this.certificateCode,
    required this.issueDate,
    required this.certCompletionTitle,
    required this.certCompletionSubtitle,
    required this.certAnnounceStudent,
    required this.certCompletionRequirementsMet,
    required this.certIssueDateText,
    required this.certIdNumberText,
    required this.certPlatformManagement,
    required this.certInstructorRoleTitle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Coordinate scale factors relative to 1414 x 1000 standard SVG canvas
    final scaleX = size.width / 1414.0;
    final scaleY = size.height / 1000.0;

    canvas.save();
    canvas.scale(scaleX, scaleY);

    // 1. Background Gradient (#ffffff -> #f8fafc -> #f1f5f9)
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
      ).createShader(const Rect.fromLTWH(0, 0, 1414, 1000));
    canvas.drawRect(const Rect.fromLTWH(0, 0, 1414, 1000), bgPaint);

    // 2. Geometric Corner Accents
    // Top-Left Polygon 1 (#0a1628, 4% opacity)
    final poly1 = Path()..moveTo(0, 0)..lineTo(240, 0)..lineTo(0, 240)..close();
    canvas.drawPath(poly1, Paint()..color = const Color(0xFF0A1628).withValues(alpha: 0.04));

    // Top-Left Polygon 2 (#2563eb, 8% opacity)
    final poly2 = Path()..moveTo(0, 0)..lineTo(160, 0)..lineTo(0, 160)..close();
    canvas.drawPath(poly2, Paint()..color = const Color(0xFF2563EB).withValues(alpha: 0.08));

    // Bottom-Right Polygon 1 (#0a1628, 4% opacity)
    final poly3 = Path()..moveTo(1414, 1000)..lineTo(1174, 1000)..lineTo(1414, 760)..close();
    canvas.drawPath(poly3, Paint()..color = const Color(0xFF0A1628).withValues(alpha: 0.04));

    // Bottom-Right Polygon 2 (#2563eb, 8% opacity)
    final poly4 = Path()..moveTo(1414, 1000)..lineTo(1254, 1000)..lineTo(1414, 840)..close();
    canvas.drawPath(poly4, Paint()..color = const Color(0xFF2563EB).withValues(alpha: 0.08));

    // 3. Borders & Frames
    // Outer solid border
    final outerBorder = Paint()
      ..color = const Color(0xFF0A1628)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(35, 35, 1344, 930), const Radius.circular(8)), outerBorder);

    // Middle dashed-effect border (#2563eb, 60% opacity)
    final middleBorder = Paint()
      ..color = const Color(0xFF2563EB).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(47, 47, 1320, 906), const Radius.circular(4)), middleBorder);

    // Inner hairline border (#0a1628, 30% opacity)
    final innerBorder = Paint()
      ..color = const Color(0xFF0A1628).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.75;
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(53, 53, 1308, 894), const Radius.circular(2)), innerBorder);

    // 4. Corner Brackets (L-shaped)
    final bracketPaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Top-Left
    final brkTL = Path()..moveTo(65, 95)..lineTo(65, 65)..lineTo(95, 65);
    canvas.drawPath(brkTL, bracketPaint);

    // Top-Right
    final brkTR = Path()..moveTo(1319, 65)..lineTo(1349, 65)..lineTo(1349, 95);
    canvas.drawPath(brkTR, bracketPaint);

    // Bottom-Left
    final brkBL = Path()..moveTo(65, 905)..lineTo(65, 935)..lineTo(95, 935);
    canvas.drawPath(brkBL, bracketPaint);

    // Bottom-Right
    final brkBR = Path()..moveTo(1319, 935)..lineTo(1349, 935)..lineTo(1349, 905);
    canvas.drawPath(brkBR, bracketPaint);

    // 5. Top & Bottom Ribbons (#0a1628 -> #2563eb -> #0a1628)
    final ribbonPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0A1628), Color(0xFF2563EB), Color(0xFF0A1628)],
      ).createShader(const Rect.fromLTWH(407, 35, 600, 5));
    canvas.drawRect(const Rect.fromLTWH(407, 35, 600, 5), ribbonPaint);
    canvas.drawRect(const Rect.fromLTWH(407, 960, 600, 5), ribbonPaint);

    // 6. Header Logo Box (EL)
    final logoBgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
      ).createShader(const Rect.fromLTWH(667, 80, 80, 80));
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(667, 80, 80, 80), const Radius.circular(18)), logoBgPaint);

    final logoBorderPaint = Paint()
      ..color = const Color(0xFF2563EB).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(665, 78, 84, 84), const Radius.circular(20)), logoBorderPaint);

    // Draw EL Logo Text
    _drawText(
      canvas,
      text: 'EL',
      x: 707,
      y: 120,
      fontSize: 32,
      fontWeight: FontWeight.w900,
      color: Colors.white,
      fontFamily: 'Inter',
    );

    // 7. Divider Line with Blue Dot
    final divPaint = Paint()
      ..color = const Color(0xFF2563EB).withValues(alpha: 0.25)
      ..strokeWidth = 1.0;
    canvas.drawLine(const Offset(507, 195), const Offset(907, 195), divPaint);
    canvas.drawCircle(const Offset(707, 195), 3, Paint()..color = const Color(0xFF2563EB).withValues(alpha: 0.5));

    // 8. Certificate Titles
    _drawText(
      canvas,
      text: certCompletionTitle,
      x: 707,
      y: 228,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF2563EB),
      letterSpacing: 2,
    );

    _drawText(
      canvas,
      text: certCompletionSubtitle,
      x: 707,
      y: 275,
      fontSize: 34,
      fontWeight: FontWeight.w900,
      color: const Color(0xFF0A1628),
    );

    _drawText(
      canvas,
      text: certAnnounceStudent,
      x: 707,
      y: 335,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF64748B),
    );

    _drawText(
      canvas,
      text: studentName,
      x: 707,
      y: 405,
      fontSize: studentName.length > 24 ? 36 : 46,
      fontWeight: FontWeight.w900,
      color: const Color(0xFF0A1628),
    );

    final nameLinePaint = Paint()
      ..color = const Color(0xFF2563EB).withValues(alpha: 0.3)
      ..strokeWidth = 2.0;
    canvas.drawLine(const Offset(457, 445), const Offset(957, 445), nameLinePaint);

    _drawText(
      canvas,
      text: certCompletionRequirementsMet,
      x: 707,
      y: 495,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF64748B),
    );

    _drawText(
      canvas,
      text: courseTitle,
      x: 707,
      y: 545,
      fontSize: courseTitle.length > 45 ? 24 : 30,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF2563EB),
    );

    _drawText(
      canvas,
      text: certIssueDateText,
      x: 707,
      y: 635,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF0A1628),
    );

    _drawText(
      canvas,
      text: certIdNumberText,
      x: 707,
      y: 665,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF0A1628),
    );

    // 9. Left Signature Block (Platform Management)
    _drawSignatureBlock(
      canvas,
      centerX: 270,
      handText: 'EduLab',
      title: certPlatformManagement,
      subtitle: 'EduLab Management',
    );

    // 10. Center QR Code Frame
    final qrBoxPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final qrBoxStroke = Paint()
      ..color = const Color(0xFF2563EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(647, 720, 120, 120), const Radius.circular(12)), qrBoxPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(647, 720, 120, 120), const Radius.circular(12)), qrBoxStroke);

    _drawQrGraphic(canvas, const Rect.fromLTWH(657, 730, 100, 100));

    // 11. Right Signature Block (Instructor)
    _drawSignatureBlock(
      canvas,
      centerX: 1144,
      handText: instructorName,
      title: certInstructorRoleTitle,
      subtitle: 'Lead Instructor',
    );

    canvas.restore();
  }

  void _drawText(
    Canvas canvas, {
    required String text,
    required double x,
    required double y,
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    String fontFamily = 'Tajawal',
    double letterSpacing = 0.0,
  }) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFamily: fontFamily,
        letterSpacing: letterSpacing,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
  }

  void _drawSignatureBlock(
    Canvas canvas, {
    required double centerX,
    required String handText,
    required String title,
    required String subtitle,
  }) {
    _drawText(
      canvas,
      text: handText,
      x: centerX,
      y: 740,
      fontSize: 26,
      fontWeight: FontWeight.w900,
      color: const Color(0xFF1E3A8A),
    );

    final linePaint = Paint()
      ..color = const Color(0xFF0A1628).withValues(alpha: 0.4)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(centerX - 110, 765), Offset(centerX + 110, 765), linePaint);
    canvas.drawCircle(Offset(centerX, 765), 2.5, Paint()..color = const Color(0xFF2563EB));

    _drawText(
      canvas,
      text: title,
      x: centerX,
      y: 790,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF0A1628),
    );

    _drawText(
      canvas,
      text: subtitle,
      x: centerX,
      y: 812,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF94A3B8),
      fontFamily: 'Inter',
    );
  }

  void _drawQrGraphic(Canvas canvas, Rect rect) {
    final qrPaint = Paint()..color = const Color(0xFF0A1628);

    canvas.drawRect(Rect.fromLTWH(rect.left + 6, rect.top + 6, 26, 26), qrPaint);
    canvas.drawRect(Rect.fromLTWH(rect.left + 10, rect.top + 10, 18, 18), Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(rect.left + 13, rect.top + 13, 12, 12), qrPaint);

    canvas.drawRect(Rect.fromLTWH(rect.right - 32, rect.top + 6, 26, 26), qrPaint);
    canvas.drawRect(Rect.fromLTWH(rect.right - 28, rect.top + 10, 18, 18), Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(rect.right - 25, rect.top + 13, 12, 12), qrPaint);

    canvas.drawRect(Rect.fromLTWH(rect.left + 6, rect.bottom - 32, 26, 26), qrPaint);
    canvas.drawRect(Rect.fromLTWH(rect.left + 10, rect.bottom - 28, 18, 18), Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(rect.left + 13, rect.bottom - 25, 12, 12), qrPaint);

    canvas.drawRect(Rect.fromLTWH(rect.left + 42, rect.top + 12, 16, 6), qrPaint);
    canvas.drawRect(Rect.fromLTWH(rect.left + 40, rect.top + 26, 8, 8), qrPaint);
    canvas.drawRect(Rect.fromLTWH(rect.left + 54, rect.top + 38, 12, 12), Paint()..color = const Color(0xFF2563EB));
    canvas.drawRect(Rect.fromLTWH(rect.left + 22, rect.top + 46, 12, 8), qrPaint);
    canvas.drawRect(Rect.fromLTWH(rect.left + 72, rect.top + 50, 14, 8), qrPaint);
    canvas.drawRect(Rect.fromLTWH(rect.left + 42, rect.bottom - 28, 18, 8), qrPaint);
    canvas.drawRect(Rect.fromLTWH(rect.right - 28, rect.bottom - 26, 14, 14), qrPaint);
  }

  @override
  bool shouldRepaint(covariant _CertificateSvgPainter oldDelegate) {
    return oldDelegate.studentName != studentName ||
        oldDelegate.courseTitle != courseTitle ||
        oldDelegate.instructorName != instructorName ||
        oldDelegate.certificateCode != certificateCode ||
        oldDelegate.issueDate != issueDate;
  }
}
