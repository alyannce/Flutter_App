class Question {
  final String question;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

final List<Question> questions = [
  Question(
    question: "What is the capital of France?",
    options: ["Paris", "London", "Berlin", "Madrid"],
    correctIndex: 0,
  ),
  Question(
    question: "2 + 2 equals?",
    options: ["3", "4", "5", "6"],
    correctIndex: 1,
  ),
  Question(
    question: "Flutter is developed by?",
    options: ["Apple", "Google", "Microsoft", "Facebook"],
    correctIndex: 1,
  ),
];
