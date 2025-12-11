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

class QuizData {
  // MIT Quiz Questions
static List<Question> mitQuestions = [
    Question(
      question: "MIT App Inventor is mainly used to create?",
      options: ["Desktop applications", "Websites", "Android apps", "iOS apps"],
      correctIndex: 2,
    ),
    Question(
      question: "Which programming method is used in MIT App Inventor?",
      options: ["Text-based coding", "Block-based coding", "Assembly language", "Python scripting"],
      correctIndex: 1,
    ),
    Question(
      question: "MIT App Inventor was developed by which institution?",
      options: ["MIT", "Harvard", "Stanford", "Google"],
      correctIndex: 0,
    ),
    Question(
      question: "Which component is used to show text on the screen?",
      options: ["Button", "Label", "Textbox", "Canvas"],
      correctIndex: 1,
    ),
    Question(
      question: "Which component is used to get user input?",
      options: ["Button", "Label", "Textbox", "Slider"],
      correctIndex: 2,
    ),
    Question(
      question: "To play sounds in MIT App Inventor, which component is used?",
      options: ["Player", "Sound", "Notifier", "Speaker"],
      correctIndex: 1,
    ),
    Question(
      question: "Which component allows drawing shapes and detecting touches?",
      options: ["Canvas", "Label", "Slider", "Textbox"],
      correctIndex: 0,
    ),
    Question(
      question: "Which block event triggers when a button is clicked?",
      options: ["Button.Click", "Button.Press", "Button.Tap", "Button.Start"],
      correctIndex: 0,
    ),
    Question(
      question: "Which component helps in sending SMS from an app?",
      options: ["Notifier", "Texting", "Sharing", "Messaging"],
      correctIndex: 1,
    ),
    Question(
      question: "How do you test your MIT App Inventor app on an Android device?",
      options: ["Export as APK", "Use AI2 Companion", "Send code via email", "Install IDE"],
      correctIndex: 1,
    ),
  ];

  // Flutter Quiz Questions
  static final List<Question> flutterQuestions = [
    Question(
      question: "Flutter is developed by?",
      options: ["Google", "Apple", "Microsoft", "Meta"],
      correctIndex: 0,
    ),
    Question(
      question: "Which language is used for Flutter development?",
      options: ["Dart", "Java", "Kotlin", "Swift"],
      correctIndex: 0,
    ),
    Question(
      question: "Which type of apps can Flutter build?",
      options: ["Android", "iOS", "Web", "All of the above"],
      correctIndex: 3,
    ),
    Question(
      question: "Flutter uses which type of widgets?",
      options: ["Stateless & Stateful", "Only Stateless", "Only Stateful", "None"],
      correctIndex: 0,
    ),
    Question(
      question: "What is the command to create a new Flutter project?",
      options: ["flutter create", "flutter new", "flutter init", "flutter build"],
      correctIndex: 0,
    ),
    Question(
      question: "Which function runs the app in Flutter?",
      options: ["runApp()", "main()", "buildApp()", "startApp()"],
      correctIndex: 0,
    ),
    Question(
      question: "Hot reload in Flutter allows?",
      options: ["Update UI instantly", "Restart device", "Change OS", "Compile Java code"],
      correctIndex: 0,
    ),
    Question(
      question: "Which file is the entry point of a Flutter app?",
      options: ["main.dart", "home.dart", "app.dart", "index.dart"],
      correctIndex: 0,
    ),
    Question(
      question: "Flutter’s rendering engine is called?",
      options: ["Skia", "Metal", "DirectX", "CanvasKit"],
      correctIndex: 0,
    ),
    Question(
      question: "Which method is used to create custom widgets?",
      options: ["Extend StatelessWidget or StatefulWidget", "Extend MaterialApp", "Use runApp()", "Override main()"],
      correctIndex: 0,
    ),
  ];
}
