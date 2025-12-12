import 'package:flutter/material.dart';
import 'category_screen.dart';
import 'highscore_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF8F86FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Title
              const Text(
                "KwizZ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 80,          // Bigger title
                  fontWeight: FontWeight.w900, // Thickest built-in bold
                  letterSpacing: 1.5,    // Cleaner spacing
                  fontFamily: 'Roboto',  // Built-in font
                ),
              ),


              const SizedBox(height: 20),

              // PLAY BUTTON → now opens CategoryScreen
              MenuButton(
                text: "Play",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CategoryScreen()),
                  );
                },
              ),

              const SizedBox(height: 20),

              // HIGHSCORE BUTTON
              MenuButton(
                text: "See Highscore",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HighscoreScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const MenuButton({required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260, 
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF6C63FF),
          elevation: 8,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
