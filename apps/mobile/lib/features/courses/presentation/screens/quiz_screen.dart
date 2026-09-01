import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/core/extensions/localization_ext.dart';
import 'package:mobile/core/theme/app_colors.dart';

class QuizScreen extends StatefulWidget {
  final String courseTitle;
  const QuizScreen({super.key, this.courseTitle = 'اختبار تقييم المفاهيم'});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIdx = 0;
  final Map<int, int> selectedAnswers = {};
  bool isSubmitted = false;
  int secondsRemaining = 300;
  Timer? timer;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'ما هو الفرق الأساسي بين StatelessWidget و StatefulWidget في Flutter؟',
      'options': [
        'StatelessWidget لا يمكن إعادة رسمه في الذاكرة',
        'StatelessWidget ثابت ولا يملك حالة متغيرة، بينما StatefulWidget يملك كائن State قابل للتعديل',
        'StatefulWidget يعمل فقط على أجهزة Android',
        'لا يوجد أي فرق سوى الاسم',
      ],
      'correctIndex': 1,
      'explanation': 'StatelessWidget يبنى مرة واحدة، بينما StatefulWidget يحتفظ بحالة ويعاد رسمه عند استدعاء setState().',
    },
    {
      'question': 'ما هو الـ Widget المناسب لترتيب العناصر بشكل أفقي مع إمكانية التمرير؟',
      'options': [
        'Column مع SingleChildScrollView',
        'ListView مع scrollDirection: Axis.horizontal',
        'Stack مع Positioned',
        'Wrap عادي',
      ],
      'correctIndex': 1,
      'explanation': 'ListView الأفقي يوفر أداءً عالي التمرير للعناصر الكثيرة.',
    },
  ];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining > 0 && !isSubmitted) {
        setState(() => secondsRemaining--);
      } else {
        t.cancel();
        setState(() => isSubmitted = true);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
        title: Text(widget.courseTitle, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal')),
        actions: [
          if (!isSubmitted)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              child: Chip(
                avatar: const Icon(Icons.timer, size: 16, color: AppColors.primary),
                label: Text(
                  '${(secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(secondsRemaining % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: textColor, fontSize: 12),
                ),
                backgroundColor: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFEFF4FF),
                side: BorderSide(color: isDark ? AppColors.darkBorder : const Color(0xFFDBEAFE)),
              ),
            ),
        ],
      ),
      body: isSubmitted
          ? _buildResultView(cardBg, textColor, textSubColor)
          : _buildQuizView(cardBg, borderColor, textColor, textSubColor, isDark),
    );
  }

  Widget _buildQuizView(Color cardBg, Color borderColor, Color textColor, Color textSubColor, bool isDark) {
    final q = questions[currentIdx];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (currentIdx + 1) / questions.length,
              color: AppColors.primary,
              backgroundColor: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
            ),
          ),
          const SizedBox(height: 20),
          Text('السؤال ${currentIdx + 1} من ${questions.length}', style: TextStyle(color: textSubColor, fontSize: 12, fontFamily: 'Tajawal')),
          const SizedBox(height: 8),
          Text(q['question'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal')),
          const SizedBox(height: 24),
          ...List.generate(q['options'].length, (optIdx) {
            final isSelected = selectedAnswers[currentIdx] == optIdx;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: isSelected
                      ? (isDark ? AppColors.primary.withValues(alpha: 0.2) : AppColors.primary.withValues(alpha: 0.08))
                      : cardBg,
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : borderColor,
                    width: isSelected ? 2 : 1,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => setState(() => selectedAnswers[currentIdx] = optIdx),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: isSelected
                          ? AppColors.primary
                          : (isDark ? AppColors.darkSurfaceMuted : const Color(0xFFE2E8F0)),
                      child: Text(
                        String.fromCharCode(65 + optIdx),
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected ? Colors.white : textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        q['options'][optIdx],
                        style: TextStyle(
                          color: isSelected ? AppColors.primary : textColor,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            onPressed: () {
              if (currentIdx < questions.length - 1) {
                setState(() => currentIdx++);
              } else {
                setState(() => isSubmitted = true);
              }
            },
            child: Text(
              currentIdx < questions.length - 1 ? context.loc.quizNext : context.loc.quizSubmit,
              style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal', fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView(Color cardBg, Color textColor, Color textSubColor) {
    int correct = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i]['correctIndex']) correct++;
    }
    final score = ((correct / questions.length) * 100).round();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.stars_rounded, size: 80, color: Colors.amber),
            const SizedBox(height: 16),
            Text('Score: $score%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Tajawal')),
            const SizedBox(height: 8),
            Text('$correct / ${questions.length}', style: TextStyle(color: textSubColor, fontFamily: 'Tajawal', fontSize: 13)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.school, color: Colors.white),
              label: Text(context.loc.learningViewCertificate, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              onPressed: () => Navigator.pushNamed(context, '/certificate_view'),
            ),
          ],
        ),
      ),
    );
  }
}
