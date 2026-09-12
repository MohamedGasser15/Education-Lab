import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/utils/app_snackbar.dart';
import 'package:mobile/core/widgets/skeleton/skeleton.dart';
import 'package:mobile/features/legal/data/models/legal_content_model.dart';
import 'package:mobile/features/legal/data/services/legal_api_service.dart';

enum LegalTab { about, privacy, terms }

class LegalContentScreen extends StatefulWidget {
  final LegalTab initialTab;

  const LegalContentScreen({
    super.key,
    this.initialTab = LegalTab.about,
  });

  @override
  State<LegalContentScreen> createState() => _LegalContentScreenState();
}

class _LegalContentScreenState extends State<LegalContentScreen>
    with SingleTickerProviderStateMixin {
  final _legalService = LegalApiService();
  late TabController _tabController;

  bool _isLoading = true;
  LegalContentModel? _aboutDoc;
  LegalContentModel? _privacyDoc;
  LegalContentModel? _termsDoc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab.index,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final locale = Localizations.localeOf(context).languageCode;
    try {
      final result = await _legalService.getAllLegalInfo(language: locale);

      if (!mounted) return;
      if (result is Success<Map<String, LegalContentModel>>) {
        final map = result.data;
        setState(() {
          _aboutDoc = map['about'] ?? LegalApiService.getDefaultDoc('about', language: locale);
          _privacyDoc = map['privacy'] ?? LegalApiService.getDefaultDoc('privacy', language: locale);
          _termsDoc = map['terms'] ?? LegalApiService.getDefaultDoc('terms', language: locale);
          _isLoading = false;
        });
      } else {
        setState(() {
          _aboutDoc = LegalApiService.getDefaultDoc('about', language: locale);
          _privacyDoc = LegalApiService.getDefaultDoc('privacy', language: locale);
          _termsDoc = LegalApiService.getDefaultDoc('terms', language: locale);
          _isLoading = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _aboutDoc = LegalApiService.getDefaultDoc('about', language: locale);
        _privacyDoc = LegalApiService.getDefaultDoc('privacy', language: locale);
        _termsDoc = LegalApiService.getDefaultDoc('terms', language: locale);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBgColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(
            isRtl ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: textColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          isRtl ? 'عن المنصة والشروط' : 'About & Legal',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: borderColor, width: 1),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: primaryColor,
              unselectedLabelColor: textSubColor,
              indicatorColor: primaryColor,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              tabs: [
                Tab(text: isRtl ? 'عن EduLab' : 'About EduLab'),
                Tab(text: isRtl ? 'الخصوصية' : 'Privacy'),
                Tab(text: isRtl ? 'الشروط' : 'Terms'),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? _buildSkeletonLoading()
          : RefreshIndicator(
              onRefresh: _loadData,
              color: primaryColor,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildContentList(_aboutDoc, isDark, cardBgColor, borderColor, textColor, textSubColor, isRtl),
                  _buildContentList(_privacyDoc, isDark, cardBgColor, borderColor, textColor, textSubColor, isRtl),
                  _buildContentList(_termsDoc, isDark, cardBgColor, borderColor, textColor, textSubColor, isRtl),
                ],
              ),
            ),
    );
  }

  Widget _buildContentList(
    LegalContentModel? doc,
    bool isDark,
    Color cardBgColor,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isRtl,
  ) {
    if (doc == null) {
      return Center(
        child: Text(
          isRtl ? 'لا يتوفر محتوى حالياً' : 'No content available',
          style: TextStyle(color: textSubColor, fontSize: 15),
        ),
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      children: [
        // Header Banner Card
        _buildHeaderCard(doc, isDark, cardBgColor, borderColor, textColor, textSubColor, isRtl),
        const SizedBox(height: 16),

        // Document Sections
        ...doc.sections.map(
          (section) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildSectionCard(section, isDark, cardBgColor, borderColor, textColor, textSubColor, isRtl),
          ),
        ),

        // Footer Contact Card
        _buildContactFooter(doc, isDark, cardBgColor, borderColor, textColor, textSubColor, isRtl),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHeaderCard(
    LegalContentModel doc,
    bool isDark,
    Color cardBgColor,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isRtl,
  ) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getHeaderIcon(doc.type),
                  color: primaryColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'v${doc.appVersion}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: textSubColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${isRtl ? "آخر تحديث:" : "Updated:"} ${doc.lastUpdated}',
                          style: TextStyle(
                            fontSize: 12,
                            color: textSubColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (doc.subtitle.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              doc.subtitle,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: textSubColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    LegalSectionModel section,
    bool isDark,
    Color cardBgColor,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isRtl,
  ) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (section.icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getSectionIcon(section.icon!),
                    size: 18,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  section.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          if (section.content.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              section.content,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: textSubColor,
              ),
            ),
          ],
          if (section.bulletPoints.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...section.bulletPoints.map(
              (point) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        point,
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.5,
                          color: textColor.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactFooter(
    LegalContentModel doc,
    bool isDark,
    Color cardBgColor,
    Color borderColor,
    Color textColor,
    Color textSubColor,
    bool isRtl,
  ) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: isDark ? 0.12 : 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryColor.withValues(alpha: isDark ? 0.3 : 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.headset_mic_rounded, color: primaryColor, size: 22),
              const SizedBox(width: 10),
              Text(
                isRtl ? 'تحتاج إلى مساعدة أو لديك استفسار؟' : 'Need help or have questions?',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isRtl
                ? 'فريق دعم EduLab متواجد لمساعدتك دائماً. يمكنك التواصل معنا مباشرة عبر البريد الإلكتروني.'
                : 'EduLab support team is here to assist you 24/7. Reach out to us directly via email.',
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: textSubColor,
            ),
          ),
          const SizedBox(height: 14),
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: doc.contactEmail));
              AppSnackbar.show(
                context,
                isRtl ? 'تم نسخ البريد الإلكتروني للدعم' : 'Support email copied to clipboard',
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.mail_outline_rounded, size: 18, color: primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    doc.contactEmail,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(Icons.copy_rounded, size: 16, color: textSubColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return AppSkeleton(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SkeletonBox(
            height: 120,
            width: double.infinity,
            borderRadius: 16,
          ),
          SizedBox(height: 16),
          SkeletonBox(
            height: 160,
            width: double.infinity,
            borderRadius: 16,
          ),
          SizedBox(height: 16),
          SkeletonBox(
            height: 180,
            width: double.infinity,
            borderRadius: 16,
          ),
        ],
      ),
    );
  }

  IconData _getHeaderIcon(String type) {
    switch (type.toLowerCase()) {
      case 'about':
        return Icons.auto_awesome_rounded;
      case 'privacy':
      case 'privacy-policy':
        return Icons.verified_user_rounded;
      case 'terms':
      case 'terms-of-service':
      default:
        return Icons.gavel_rounded;
    }
  }

  IconData _getSectionIcon(String icon) {
    switch (icon.toLowerCase()) {
      case 'info':
        return Icons.info_outline_rounded;
      case 'rocket':
        return Icons.rocket_launch_rounded;
      case 'star':
        return Icons.star_outline_rounded;
      case 'mail':
        return Icons.email_outlined;
      case 'shield':
        return Icons.shield_outlined;
      case 'database':
        return Icons.dns_outlined;
      case 'lock':
        return Icons.lock_outline_rounded;
      case 'document':
        return Icons.article_outlined;
      case 'user':
        return Icons.person_outline_rounded;
      case 'copyright':
        return Icons.copyright_rounded;
      default:
        return Icons.check_circle_outline_rounded;
    }
  }
}
