import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:snake_game/game.dart';

class Start extends StatelessWidget {
  const Start({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/snake.json"),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.blue, width: 4)),
              height: 50.0,
              minWidth: 180.0,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GamePage()));
              },
              color: Colors.red,
              child: Text(
                "Start Game".toUpperCase(),
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
