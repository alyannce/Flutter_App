import 'dart:async'; // Timer
import 'dart:math'; // Random

import 'package:flutter/material.dart';
import '../data/questions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizScreen extends StatefulWidget {
  final String category;
  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Question> questions;
  int currentQuestion = 0;
  int score = 0; // score earned and used for powerups

  // Timer / scoring
  static const int maxSeconds = 10;
  int secondsLeft = maxSeconds;
  Timer? _timer;

  // Powerups
  static const int hintCost = 10;
  static const int skipCost = 15;
  List<bool> optionVisible = [];

  final Random _rand = Random();

  @override
  void initState() {
    super.initState();
    questions = widget.category == "mit"
        ? QuizData.mitQuestions
        : QuizData.flutterQuestions;
    _startQuestion();
  }

  void _startQuestion() {
    // reset timer and option visibility for current question
    secondsLeft = maxSeconds;
    optionVisible = List<bool>.filled(questions[currentQuestion].options.length, true);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (secondsLeft > 0) {
          secondsLeft--;
        } else {
          // time's up -> move to next question
          t.cancel();
          _onTimeUp();
        }
      });
    });
  }

  void _onTimeUp() {
    if (currentQuestion < questions.length - 1) {
      setState(() => currentQuestion++);
      _startQuestion();
    } else {
      _timer?.cancel();
      _finishQuiz();
    }
  }

  void checkAnswer(int chosenIndex) async {
    _timer?.cancel();
    final correct = questions[currentQuestion].correctIndex;
    if (chosenIndex == correct) {
      // award base points + time bonus (quicker => more bonus)
      int gained = 2 + secondsLeft; // base 10 + remaining seconds
      setState(() => score += gained);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Correct! +$gained')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wrong!')),
      );
    }

    if (currentQuestion < questions.length - 1) {
      setState(() => currentQuestion++);
      _startQuestion();
    } else {
      await saveHighscore();
      _finishQuiz();
    }
  }

  Future<void> saveHighscore() async {
    final prefs = await SharedPreferences.getInstance();
    String key = widget.category == "mit" ? "mit_highscore" : "flutter_highscore";
    int highscore = prefs.getInt(key) ?? 0;
    if (score > highscore) {
      await prefs.setInt(key, score);
    }
  }

  void showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Quiz Complete!"),
        content: Text("Your Score: $score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back to menu
            },
            child: const Text("Back to Menu"),
          )
        ],
      ),
    );
  }

  // for saving highscore and showing result dialog
  Future<void> _finishQuiz() async {
    await saveHighscore();
    showResultDialog();
  }

  //for using hint powerup
  void _useHint() async {
    if (score < hintCost) return;
    setState(() {
      score -= hintCost;
    });

    int correct = questions[currentQuestion].correctIndex;
    // collect removable indices
    List<int> candidates = [];
    for (int i = 0; i < optionVisible.length; i++) {
      if (i != correct && optionVisible[i]) candidates.add(i);
    }
    if (candidates.isNotEmpty) {
      int pick = candidates[_rand.nextInt(candidates.length)];
      setState(() => optionVisible[pick] = false);
    }
  }

  //for using skip powerup
  void _useSkip() async {
    if (score < skipCost) return;
    setState(() {
      score -= skipCost;
    });

    if (currentQuestion < questions.length - 1) {
      setState(() => currentQuestion++);
      _startQuestion();
    } else {
      _timer?.cancel();
      _finishQuiz();
    }
  }
  //for disposing timer
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];
    double progress = (currentQuestion + 1) / questions.length;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF8F86FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress Bar
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Top row: score, timer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        '$score',
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.timer, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        '$secondsLeft s',
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Powerups Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: score >= hintCost ? _useHint : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF6C63FF),
                    ),
                    child: Text('Hint (-$hintCost)'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: score >= skipCost ? _useSkip : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF6C63FF),
                    ),
                    child: Text('Skip (-$skipCost)'),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Question Card
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    question.question,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Choices
              Column(
                children: List.generate(question.options.length, (i) {
                  if (optionVisible.isNotEmpty && !optionVisible[i]) {
                    return const SizedBox.shrink();
                  }
                  return AnswerButton(
                      text: question.options[i],
                      onPressed: () => checkAnswer(i));
                }),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 180, // smaller than choice buttons
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // go back to menu
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF6C63FF),
                    elevation: 6,
                  ),
                  child: const Text(
                    "Back to Menu",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnswerButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AnswerButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF6C63FF),
          elevation: 6,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
