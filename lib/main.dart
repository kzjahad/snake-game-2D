import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake_game/start.dart';

import 'game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '2D Snake Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimatedSplashScreen(
        splash: Container(
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Text(
                      "2D Snake Game".toUpperCase(),
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "Developed by - Kamruzzaman Jahad",
                      style: GoogleFonts.poppins(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        duration: 3000,
        splashTransition: SplashTransition.fadeTransition,
        nextScreen: Start(),
        backgroundColor: Colors.amber,
      ),
    );
  }
}
