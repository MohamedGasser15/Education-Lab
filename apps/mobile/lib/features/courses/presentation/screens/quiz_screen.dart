import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_theme.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseTitle, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        actions: [
          if (!isSubmitted)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              child: Chip(
                avatar: const Icon(Icons.timer, size: 16, color: Colors.blue),
                label: Text('${(secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(secondsRemaining % 60).toString().padLeft(2, '0')}'),
                backgroundColor: Colors.blue.withValues(alpha: 0.1),
              ),
            ),
        ],
      ),
      body: isSubmitted ? _buildResultView() : _buildQuizView(),
    );
  }

  Widget _buildQuizView() {
    final q = questions[currentIdx];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(value: (currentIdx + 1) / questions.length, color: AppColors.primary),
          const SizedBox(height: 20),
          Text('السؤال ${currentIdx + 1} من ${questions.length}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          Text(q['question'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          ...List.generate(q['options'].length, (optIdx) {
            final isSelected = selectedAnswers[currentIdx] == optIdx;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: isSelected ? AppColors.primary.withValues(alpha: 0.1) : null,
                  side: BorderSide(color: isSelected ? AppColors.primary : Colors.grey.shade300, width: isSelected ? 2 : 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => setState(() => selectedAnswers[currentIdx] = optIdx),
                child: Row(
                  children: [
                    CircleAvatar(radius: 12, backgroundColor: isSelected ? AppColors.primary : Colors.grey.shade200, child: Text(String.fromCharCode(65 + optIdx), style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : Colors.black87))),
                    const SizedBox(width: 12),
                    Expanded(child: Text(q['options'][optIdx], style: TextStyle(color: isSelected ? AppColors.primary : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal))),
                  ],
                ),
              ),
            );
          }),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            onPressed: () {
              if (currentIdx < questions.length - 1) {
                setState(() => currentIdx++);
              } else {
                setState(() => isSubmitted = true);
              }
            },
            child: Text(currentIdx < questions.length - 1 ? 'السؤال التالي' : 'تسليم الاختبار', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
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
            Text('درجة الاختبار: %$score', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('أجبت بشكل صحيح على $correct من أصل ${questions.length} أسئلة', style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.school, color: Colors.white),
              label: const Text('عرض شهادة التخرج', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              onPressed: () => Navigator.pushNamed(context, '/certificate_view'),
            ),
          ],
        ),
      ),
    );
  }
}
