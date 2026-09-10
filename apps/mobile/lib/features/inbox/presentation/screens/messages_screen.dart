import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/inbox/data/models/support_model.dart';
import 'package:mobile/features/inbox/presentation/providers/support_provider.dart';
import 'package:mobile/features/inbox/presentation/screens/support_chat_screen.dart';
import 'package:mobile/features/inbox/presentation/widgets/new_conversation_sheet.dart';
import 'package:mobile/features/profile/presentation/providers/profile_provider.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && context.read<ProfileProvider>().isLoggedIn) {
        context.read<SupportProvider>().fetchConversations();
      }
    });
  }

  String _formatRelativeTime(DateTime? dt, bool isArabic) {
    if (dt == null) return '';
    final local = dt.toLocal();
    final now = DateTime.now();
    final diff = now.difference(local);

    if (diff.inMinutes < 1) {
      return isArabic ? 'الآن' : 'Just now';
    } else if (diff.inHours < 1) {
      return isArabic ? 'منذ ${diff.inMinutes} د' : '${diff.inMinutes}m ago';
    } else if (diff.inDays == 0 && now.day == local.day) {
      return DateFormat('hh:mm a', isArabic ? 'ar' : 'en').format(local);
    } else if (diff.inDays == 1 || (diff.inDays < 2 && now.day - local.day == 1)) {
      return isArabic ? 'أمس' : 'Yesterday';
    } else {
      return DateFormat('d MMM', isArabic ? 'ar' : 'en').format(local);
    }
  }

  void _openNewConversation() async {
    final created = await NewConversationSheet.show(context);
    if (created != null && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SupportChatScreen(conversation: created),
        ),
      );
    }
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

    final profileProvider = context.watch<ProfileProvider>();
    final isLoggedIn = profileProvider.isLoggedIn;

    return Consumer<SupportProvider>(
      builder: (context, provider, child) {
        final hasConversations = provider.conversations.isNotEmpty;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: cardBg,
            elevation: 0.5,
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
              context.loc.messagesTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Tajawal',
                fontSize: 17,
              ),
            ),
          ),
          body: !isLoggedIn
              ? _buildGuestMessagesView(
                  textColor: textColor,
                  textSubColor: textSubColor,
                  borderColor: borderColor,
                  isDark: isDark,
                  isRtl: isRtl,
                )
              : Builder(
                  builder: (context) {
          if (provider.isLoading && provider.conversations.isEmpty) {
            return const Center(child: CircularProgressIndicator(strokeWidth: 2.5));
          }

          if (provider.errorMessage != null && provider.conversations.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded, color: Colors.amber, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: textColor, fontSize: 14, fontFamily: 'Tajawal'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => provider.fetchConversations(forceRefresh: true),
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: Text(context.loc.supportRetry),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.conversations.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => provider.fetchConversations(forceRefresh: true),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.18),
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.headset_mic_rounded,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.loc.supportNoChatsTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      context.loc.supportNoChatsDesc,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: textSubColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _openNewConversation,
                      icon: const Icon(Icons.add_comment_rounded, size: 18),
                      label: Text(
                        context.loc.supportStartNewConversation,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchConversations(forceRefresh: true),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: provider.conversations.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final conv = provider.conversations[index];
                return _buildConversationCard(
                  conv: conv,
                  isDark: isDark,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textColor: textColor,
                  textSubColor: textSubColor,
                  isRtl: isRtl,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SupportChatScreen(conversation: conv),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: (isLoggedIn && hasConversations)
          ? FloatingActionButton.extended(
              onPressed: _openNewConversation,
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add_comment_rounded, color: Colors.white, size: 20),
              label: Text(
                context.loc.supportNewChat,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  fontSize: 13,
                ),
              ),
            )
          : null,
    );
  },
);
  }

  Widget _buildGuestMessagesView({
    required Color textColor,
    required Color textSubColor,
    required Color borderColor,
    required bool isDark,
    required bool isRtl,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // Decorative Headset / Chat with Lock Badge
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? AppColors.primary.withValues(alpha: 0.12)
                                : const Color(0xFFEFF6FF),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.08),
                                blurRadius: 30,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? AppColors.darkSurface : Colors.white,
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.headset_mic_rounded,
                              size: 40,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: isRtl ? null : 2,
                          left: isRtl ? 2 : null,
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark ? AppColors.darkSurface : Colors.white,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.lock_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      context.loc.messagesGuestTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Subtitle
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: Text(
                        context.loc.messagesGuestSubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.55,
                          color: textSubColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),

                    const Spacer(flex: 3),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, Color(0xFF2563EB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.32),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            Navigator.pushNamed(context, '/login');
                          },
                          icon: const Icon(Icons.login_rounded, size: 20, color: Colors.white),
                          label: Text(
                            context.loc.loginTabLogin,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConversationCard({
    required SupportConversationModel conv,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
    required bool isRtl,
    required VoidCallback onTap,
  }) {
    final isOpen = conv.isOpen;
    final timeStr = _formatRelativeTime(conv.lastMessageAt ?? conv.updatedAt, isRtl);
    final lastMsg = conv.lastMessage?.trim();
    final hasUnread = conv.unreadCount > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasUnread ? AppColors.primary.withValues(alpha: 0.4) : borderColor,
              width: hasUnread ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar / Icon with badge
              Stack(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: isOpen
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : (isDark ? Colors.white10 : Colors.grey[200]),
                    child: Icon(
                      Icons.support_agent_rounded,
                      color: isOpen ? AppColors.primary : Colors.grey[600],
                      size: 24,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: isRtl ? null : 0,
                    left: isRtl ? 0 : null,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: isOpen ? const Color(0xFF10B981) : Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(color: cardBg, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Title, Last Message preview & Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conv.subject,
                            style: TextStyle(
                              fontWeight: hasUnread ? FontWeight.w800 : FontWeight.bold,
                              fontSize: 14,
                              color: textColor,
                              fontFamily: 'Tajawal',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          timeStr,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                            color: hasUnread ? AppColors.primary : textSubColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // Last message text
                    Text(
                      lastMsg != null && lastMsg.isNotEmpty
                          ? lastMsg
                          : context.loc.supportNoMessagesYet,
                      style: TextStyle(
                        color: hasUnread ? textColor : textSubColor,
                        fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 12.5,
                        fontFamily: 'Tajawal',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Unread Badge
              if (hasUnread) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    conv.unreadCount > 9 ? '9+' : '${conv.unreadCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
