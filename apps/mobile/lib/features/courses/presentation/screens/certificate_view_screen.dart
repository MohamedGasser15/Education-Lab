import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';

class CertificateViewScreen extends StatefulWidget {
  final String studentName;
  final String courseTitle;
  final String instructorName;
  final String certificateCode;
  final String issueDate;

  const CertificateViewScreen({
    super.key,
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
  bool _isDownloading = false;

  void _downloadCertificate(String format) async {
    setState(() => _isDownloading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isDownloading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تنزيل الشهادة بصيغة $format بنجاح في مجلد التنزيلات!'),
        backgroundColor: const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _copyVerifyLink() {
    final link = 'https://verify.edulab.academy/cert/${widget.certificateCode}';
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ رابط التحقق المباشر إلى الحافظة!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareCertificate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تجهيز رابط شهادة "${widget.courseTitle}" للمشاركة!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
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

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        centerTitle: false,
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
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          // 1. Verified Credential Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0D3320) : const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? const Color(0xFF059669) : const Color(0xFFA7F3D0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_rounded, color: Color(0xFF059669), size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.loc.certVerifiedBadge,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF059669),
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      Text(
                        'رقم التحقق: ${widget.certificateCode} • تم إكمال كافة المتطلبات 100%',
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

          // 2. Interactive SVG-Identical Certificate Canvas (1414 x 1000 Aspect Ratio)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0A1628).withValues(alpha: 0.12),
                  blurRadius: 20,
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
                    studentName: widget.studentName,
                    courseTitle: widget.courseTitle,
                    instructorName: widget.instructorName,
                    certificateCode: widget.certificateCode,
                    issueDate: widget.issueDate,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 3. Action Download & Share Buttons
          Row(
            children: [
              // PDF Download Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isDownloading ? null : () => _downloadCertificate('PDF'),
                  icon: _isDownloading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.picture_as_pdf_outlined, size: 18),
                  label: Text(
                    context.loc.certDownloadPDF,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // PNG Download Button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isDownloading ? null : () => _downloadCertificate('PNG'),
                  icon: const Icon(Icons.image_outlined, size: 18),
                  label: Text(
                    context.loc.certDownloadPNG,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 4. Verification Metadata Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.loc.certVerifiedBadge,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    InkWell(
                      onTap: _copyVerifyLink,
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        child: Row(
                          children: [
                            const Icon(Icons.copy_rounded, size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              context.loc.certCopyVerifyLink,
                              style: const TextStyle(
                                fontSize: 11.5,
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
                const SizedBox(height: 12),

                _buildMetaRow(context.loc.certStudentNameLabel, widget.studentName, textColor, textSubColor),
                _buildMetaRow(context.loc.certCourseLabel, widget.courseTitle, textColor, textSubColor),
                _buildMetaRow(context.loc.certInstructorLabel, widget.instructorName, textColor, textSubColor),
                _buildMetaRow(context.loc.certIssueDateLabel, widget.issueDate, textColor, textSubColor),
                _buildMetaRow(context.loc.certCodeLabel, widget.certificateCode, textColor, textSubColor, isCode: true),
                _buildMetaRow('EduLab Academy', 'Accredited Educational Platform', textColor, textSubColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow(String label, String value, Color textColor, Color textSubColor, {bool isCode = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
}

// ================= EXACT SVG CERTIFICATE CUSTOM PAINTER =================
class _CertificateSvgPainter extends CustomPainter {
  final String studentName;
  final String courseTitle;
  final String instructorName;
  final String certificateCode;
  final String issueDate;

  _CertificateSvgPainter({
    required this.studentName,
    required this.courseTitle,
    required this.instructorName,
    required this.certificateCode,
    required this.issueDate,
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
    // Small top label (blue, letterspaced)
    _drawText(
      canvas,
      text: 'شهادة إتمام',
      x: 707,
      y: 228,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF2563EB),
      letterSpacing: 2,
    );

    // Main Title
    _drawText(
      canvas,
      text: 'شهادة إتمام دورة تدريبية',
      x: 707,
      y: 275,
      fontSize: 34,
      fontWeight: FontWeight.w900,
      color: const Color(0xFF0A1628),
    );

    // Subtitle
    _drawText(
      canvas,
      text: 'تعلن منصة EducationLab التعليمية بأن الطالب/طالبة:',
      x: 707,
      y: 335,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF64748B),
    );

    // Student Name
    _drawText(
      canvas,
      text: studentName,
      x: 707,
      y: 405,
      fontSize: studentName.length > 24 ? 36 : 46,
      fontWeight: FontWeight.w900,
      color: const Color(0xFF0A1628),
    );

    // Student Name Underline
    final nameLinePaint = Paint()
      ..color = const Color(0xFF2563EB).withValues(alpha: 0.3)
      ..strokeWidth = 2.0;
    canvas.drawLine(const Offset(457, 445), const Offset(957, 445), nameLinePaint);

    // Course Subtitle
    _drawText(
      canvas,
      text: 'قد أتم بنجاح وكفاءة جميع متطلبات الدورة التدريبية:',
      x: 707,
      y: 495,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF64748B),
    );

    // Course Title
    _drawText(
      canvas,
      text: courseTitle,
      x: 707,
      y: 545,
      fontSize: courseTitle.length > 45 ? 24 : 30,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF2563EB),
    );

    // Issue Date
    _drawText(
      canvas,
      text: 'تاريخ الإصدار: $issueDate',
      x: 707,
      y: 635,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF0A1628),
    );

    // Certificate Code
    _drawText(
      canvas,
      text: 'رقم الشهادة: $certificateCode',
      x: 707,
      y: 665,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF0A1628),
    );

    // 9. Left Signature Block (إدارة المنصة)
    _drawSignatureBlock(
      canvas,
      centerX: 270,
      handText: 'EduLab',
      title: 'إدارة المنصة',
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

    // Render Geometric QR Placeholder pattern
    _drawQrGraphic(canvas, const Rect.fromLTWH(657, 730, 100, 100));

    // 11. Right Signature Block (المحاضر / المدرب)
    _drawSignatureBlock(
      canvas,
      centerX: 1144,
      handText: instructorName,
      title: 'المحاضر / المدرب',
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
    // Signature Hand Text (Dark Navy Blue #1E3A8A)
    _drawText(
      canvas,
      text: handText,
      x: centerX,
      y: 740,
      fontSize: 26,
      fontWeight: FontWeight.w900,
      color: const Color(0xFF1E3A8A),
    );

    // Signature Underline Line
    final linePaint = Paint()
      ..color = const Color(0xFF0A1628).withValues(alpha: 0.4)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(centerX - 110, 765), Offset(centerX + 110, 765), linePaint);
    canvas.drawCircle(Offset(centerX, 765), 2.5, Paint()..color = const Color(0xFF2563EB));

    // Title
    _drawText(
      canvas,
      text: title,
      x: centerX,
      y: 790,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF0A1628),
    );

    // Subtitle
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

    // Draw stylized 3 corner position markers
    // Top-Left Corner
    canvas.drawRect(Rect.fromLTWH(rect.left + 6, rect.top + 6, 26, 26), qrPaint);
    canvas.drawRect(Rect.fromLTWH(rect.left + 10, rect.top + 10, 18, 18), Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(rect.left + 13, rect.top + 13, 12, 12), qrPaint);

    // Top-Right Corner
    canvas.drawRect(Rect.fromLTWH(rect.right - 32, rect.top + 6, 26, 26), qrPaint);
    canvas.drawRect(Rect.fromLTWH(rect.right - 28, rect.top + 10, 18, 18), Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(rect.right - 25, rect.top + 13, 12, 12), qrPaint);

    // Bottom-Left Corner
    canvas.drawRect(Rect.fromLTWH(rect.left + 6, rect.bottom - 32, 26, 26), qrPaint);
    canvas.drawRect(Rect.fromLTWH(rect.left + 10, rect.bottom - 28, 18, 18), Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(rect.left + 13, rect.bottom - 25, 12, 12), qrPaint);

    // Center micro QR pixel blocks
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
