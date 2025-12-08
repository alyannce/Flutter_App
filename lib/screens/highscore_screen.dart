import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HighscoreScreen extends StatefulWidget {
  const HighscoreScreen({super.key});

  @override
  State<HighscoreScreen> createState() => _HighscoreScreenState();
}

class _HighscoreScreenState extends State<HighscoreScreen> {
  int highscore = 0;

  @override
  void initState() {
    super.initState();
    loadHighscore();
  }

  Future<void> loadHighscore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highscore = prefs.getInt('highscore') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Highscore")),
      body: Center(
        child: Text(
          "Highest Score: $highscore",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
