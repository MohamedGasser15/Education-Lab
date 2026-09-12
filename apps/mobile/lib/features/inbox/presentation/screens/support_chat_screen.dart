import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/app_responsive.dart';
import 'package:mobile/core/widgets/app_button.dart';
import 'package:mobile/features/inbox/data/models/support_model.dart';
import 'package:mobile/features/inbox/presentation/providers/support_provider.dart';

class SupportChatScreen extends StatefulWidget {
  final SupportConversationModel conversation;

  const SupportChatScreen({super.key, required this.conversation});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  int _lastMessageCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SupportProvider>().openConversation(widget.conversation);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animate = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final target = _scrollController.position.maxScrollExtent;
        if (animate) {
          _scrollController.animateTo(
            target,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        } else {
          _scrollController.jumpTo(target);
        }
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    final success = await context.read<SupportProvider>().sendMessage(text);
    if (success) {
      _scrollToBottom();
    }
  }

  String _formatTime(DateTime dt, bool isArabic) {
    try {
      final local = dt.toLocal();
      final locale = isArabic ? 'ar' : 'en';
      return DateFormat('hh:mm a', locale).format(local);
    } catch (_) {
      return '';
    }
  }

  void _confirmToggleStatus(
    BuildContext context,
    SupportProvider provider,
    bool isOpen,
    bool isRtl,
  ) {
    if (!isOpen) {
      provider.toggleConversationStatus();
      return;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSubColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final cancelBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: cardBg,
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Icon Badge
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFE11D48).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFE11D48).withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  color: Color(0xFFE11D48),
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                context.loc.supportCloseDialogTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                context.loc.supportCloseDialogDesc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: textSubColor,
                  height: 1.45,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 22),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        style: TextButton.styleFrom(
                          backgroundColor: cancelBg,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: borderColor),
                          ),
                        ),
                        child: Text(
                          context.loc.supportCancel,
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton(
                      height: 44,
                      borderRadius: 12,
                      backgroundColor: const Color(0xFFE11D48),
                      label: context.loc.supportYesClose,
                      fontSize: 13,
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        provider.toggleConversationStatus();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final bgColor = AppColors.getBackground(context);
    final cardBg = AppColors.getSurface(context);
    final textColor = AppColors.getTextPrimary(context);
    final textSubColor = AppColors.getTextSecondary(context);
    final borderColor = AppColors.getBorder(context);

    return Consumer<SupportProvider>(
      builder: (context, provider, child) {
        final conv = provider.activeConversation ?? widget.conversation;
        final messages = provider.activeMessages;
        final isOpen = conv.isOpen;

        // Auto-scroll when new messages arrive
        if (messages.length != _lastMessageCount) {
          _lastMessageCount = messages.length;
          _scrollToBottom();
        }

        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) {
              provider.closeActiveConversation();
            }
          },
          child: Scaffold(
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
                  provider.closeActiveConversation();
                  Navigator.of(context).pop();
                },
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conv.subject,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: 'Tajawal',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isOpen ? const Color(0xFF10B981) : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isOpen
                            ? context.loc.supportOpenTicket
                            : context.loc.supportClosedTicket,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isOpen ? const Color(0xFF10B981) : textSubColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                Center(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 12),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: provider.isTogglingStatus
                            ? null
                            : () => _confirmToggleStatus(context, provider, isOpen, isRtl),
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isOpen
                                ? (isDark
                                    ? const Color(0xFF4C0519).withValues(alpha: 0.35)
                                    : const Color(0xFFFFF1F2))
                                : (isDark
                                    ? const Color(0xFF064E3B).withValues(alpha: 0.35)
                                    : const Color(0xFFECFDF5)),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isOpen
                                  ? (isDark
                                      ? const Color(0xFFBE123C).withValues(alpha: 0.4)
                                      : const Color(0xFFFECDD3))
                                  : (isDark
                                      ? const Color(0xFF059669).withValues(alpha: 0.4)
                                      : const Color(0xFFA7F3D0)),
                              width: 1,
                            ),
                          ),
                          child: provider.isTogglingStatus
                              ? SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: isOpen
                                        ? const Color(0xFFE11D48)
                                        : const Color(0xFF059669),
                                  ),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isOpen
                                          ? Icons.lock_outline_rounded
                                          : Icons.lock_open_rounded,
                                      size: 13,
                                      color: isOpen
                                          ? const Color(0xFFE11D48)
                                          : const Color(0xFF059669),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      isOpen
                                          ? context.loc.supportCloseAction
                                          : context.loc.supportReopenAction,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: isOpen
                                            ? const Color(0xFFE11D48)
                                            : const Color(0xFF059669),
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                // Chat messages area
                Expanded(
                  child: provider.isMessagesLoading
                      ? const Center(
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : messages.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    size: 48,
                                    color: textSubColor.withValues(alpha: 0.5),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    context.loc.supportNoMessagesInChat,
                                    style: TextStyle(
                                      color: textSubColor,
                                      fontSize: 13,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.symmetric(
                                horizontal: AppResponsive.screenPadding(context),
                                vertical: 16,
                              ),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final msg = messages[index];
                                final isUser = msg.isUser;
                                return _buildMessageBubble(
                                  message: msg,
                                  isUser: isUser,
                                  isRtl: isRtl,
                                  isDark: isDark,
                                  textColor: textColor,
                                  textSubColor: textSubColor,
                                );
                              },
                            ),
                ),

                // Bottom bar: Input field or Closed banner
                if (isOpen)
                  _buildInputBar(
                    isDark: isDark,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textColor: textColor,
                    textSubColor: textSubColor,
                    isRtl: isRtl,
                    isSending: provider.isSending,
                  )
                else
                  _buildClosedNotice(
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textColor: textColor,
                    textSubColor: textSubColor,
                    isRtl: isRtl,
                    onReopen: () => provider.toggleConversationStatus(),
                    isToggling: provider.isTogglingStatus,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble({
    required SupportMessageModel message,
    required bool isUser,
    required bool isRtl,
    required bool isDark,
    required Color textColor,
    required Color textSubColor,
  }) {
    final bubbleBg = isUser
        ? AppColors.primary
        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9));
    final bubbleTextColor = isUser
        ? Colors.white
        : (isDark ? Colors.white : const Color(0xFF0F172A));
    final senderLabel = isUser
        ? context.loc.supportYou
        : context.loc.supportTeam;
    final timeStr = _formatTime(message.createdAt, isRtl);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Message Bubble
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.78,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bubbleBg,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: bubbleTextColor,
                  fontSize: 13.5,
                  height: 1.45,
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Sender Label & Timestamp UNDER the bubble
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isUser) ...[
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.support_agent_rounded, size: 10, color: AppColors.primary),
                  ),
                  const SizedBox(width: 5),
                ],
                Text(
                  '$senderLabel • $timeStr',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: textSubColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar({
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
    required bool isRtl,
    required bool isSending,
  }) {
    return Container(
      padding: EdgeInsets.only(
        left: 14,
        right: 14,
        top: 10,
        bottom: 10 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
              ),
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                maxLines: 4,
                minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                style: TextStyle(color: textColor, fontSize: 13.5, fontFamily: 'Tajawal'),
                decoration: InputDecoration(
                  hintText: context.loc.supportTypeMessageHint,
                  hintStyle: TextStyle(color: textSubColor, fontSize: 13, fontFamily: 'Tajawal'),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: AppColors.primary,
            shape: const CircleBorder(),
            elevation: 2,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: isSending ? null : _sendMessage,
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                child: isSending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Transform.rotate(
                        angle: isRtl ? 3.14159 : 0,
                        child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClosedNotice({
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textSubColor,
    required bool isRtl,
    required VoidCallback onReopen,
    required bool isToggling,
  }) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 14,
        bottom: 14 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: textSubColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.loc.supportConversationClosedNotice,
              style: TextStyle(
                fontSize: 12,
                color: textSubColor,
                fontWeight: FontWeight.w600,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
          AppButton(
            width: 110,
            height: 38,
            borderRadius: 10,
            isLoading: isToggling,
            icon: const Icon(Icons.lock_open_rounded, size: 14, color: Colors.white),
            label: context.loc.supportReopenAction,
            fontSize: 12,
            onPressed: onReopen,
          ),
        ],
      ),
    );
  }
}
