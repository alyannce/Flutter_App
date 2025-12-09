import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestion = 0;
  int score = 0;

  List<Map<String, dynamic>> questions = [
    {
      "question": "What is Flutter?",
      "choices": ["SDK", "Game Engine", "Database", "OS"],
      "answer": "SDK"
    },
    {
      "question": "Who created Flutter?",
      "choices": ["Google", "Apple", "Microsoft", "Meta"],
      "answer": "Google"
    },
    {
      "question": "What language does Flutter use?",
      "choices": ["Java", "Dart", "Kotlin", "Swift"],
      "answer": "Dart"
    },
  ];

  void checkAnswer(String choice) async {
    bool isCorrect = choice == questions[currentQuestion]["answer"];

    if (isCorrect) score++;

    // Go next question or finish
    if (currentQuestion < questions.length - 1) {
      setState(() => currentQuestion++);
    } else {
      saveHighscore();
      showResultDialog();
    }
  }

  Future<void> saveHighscore() async {
    final prefs = await SharedPreferences.getInstance();
    int highscore = prefs.getInt("highscore") ?? 0;

    if (score > highscore) {
      prefs.setInt("highscore", score);
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

  @override
  Widget build(BuildContext context) {
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

              // Question Card
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    questions[currentQuestion]["question"],
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
                children: questions[currentQuestion]["choices"]
                    .map<Widget>((choice) => AnswerButton(
                          text: choice,
                          onPressed: () => checkAnswer(choice),
                        ))
                    .toList(),
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
