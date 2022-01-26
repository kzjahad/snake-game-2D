import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake_game/control_panel.dart';
import 'package:snake_game/piece.dart';
import 'package:snake_game/start.dart';
import 'dart:math';

import 'direction.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late int upperBoundX, upperBoundY, lowerBoundX, lowerBoundY;
  late double screenWidth, screenHeight;
  int step = 30;
  int length = 5;
  Offset? foodPosition;
  late Piece food;
  int score = 0;
  double speed = 1.0;
  List<Offset> positions = [];
  Direction direction = Direction.right;
  Timer? timer;
  void changeSpeed() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    timer = Timer.periodic(Duration(milliseconds: 200 ~/ speed), (timer) {
      setState(() {});
    });
  }

  Widget getControls() {
    return ControlPanel(onTapped: (Direction newDirection) {
      direction = newDirection;
    });
  }

  Direction getRandomDirection() {
    int val = Random().nextInt(4);
    direction = Direction.values[val];
    return direction;
  }

  void restart() {
    length = 5;
    score = 0;
    speed = 1;
    positions = [];
    direction = getRandomDirection();
    changeSpeed();
  }

  @override
  initState() {
    super.initState();
    restart();
  }

  int getNearestTens(int num) {
    int output;
    output = (num ~/ step) * step;
    if (output == 0) {
      output += step;
    }
    return output;
  }

  Offset getRandomPosition() {
    Offset position;
    int posX = Random().nextInt(upperBoundX) + lowerBoundX;
    int posY = Random().nextInt(upperBoundY) + lowerBoundY;
    position = Offset(
      getNearestTens(posX).toDouble(),
      getNearestTens(posY).toDouble(),
    );
    return position;
  }

  void draw() async {
    if (positions.length == 0) {
      positions.add(getRandomPosition());
    }
    while (length > positions.length) {
      positions.add(positions[positions.length - 1]);
    }
    for (var i = positions.length - 1; i > 0; i--) {
      positions[i] = positions[i - 1];
    }
    positions[0] = await getNextPosition(positions[0]);
  }

  void showGameOverDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.blue,
                width: 3.0,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            title: Text(
              "Game Over".toUpperCase(),
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold)),
            ),
            content: Text(
              "Your game is over but you played well. Your score is " +
                  score.toString(),
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      restart();
                    },
                    child: Text("Restart",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () async {
                      await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Start()));
                    },
                    child: Text("Exit",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ],
              ),
            ],
          );
        });
  }

  bool detectCollision(Offset position) {
    if (position.dx >= upperBoundX && direction == Direction.right) {
      return true;
    } else if (position.dx <= lowerBoundX && direction == Direction.left) {
      return true;
    } else if (position.dy >= upperBoundY && direction == Direction.down) {
      return true;
    } else if (position.dy <= lowerBoundY && direction == Direction.up) {
      return true;
    }
    return false;
  }

  Future<Offset> getNextPosition(Offset position) async {
    Offset nextPosition = position;
    if (direction == Direction.right) {
      nextPosition = Offset(position.dx + step, position.dy);
    } else if (direction == Direction.left) {
      nextPosition = Offset(position.dx - step, position.dy);
    } else if (direction == Direction.up) {
      nextPosition = Offset(position.dx, position.dy - step);
    } else if (direction == Direction.down) {
      nextPosition = Offset(position.dx, position.dy + step);
    }
    if (detectCollision(position) == true) {
      if (timer != null && timer!.isActive) {
        timer!.cancel();
      }
      await Future.delayed(
          Duration(milliseconds: 200), () => showGameOverDialog());
      return position;
    }
    return nextPosition;
  }

  void drawFood() {
    if (foodPosition == null) {
      foodPosition = getRandomPosition();
    }
    if (foodPosition == positions[0]) {
      length++;
      score = score + 5;
      speed = speed + 0.25;
      foodPosition = getRandomPosition();
    }
    food = Piece(
      posX: foodPosition!.dx.toInt(),
      posY: foodPosition!.dy.toInt(),
      color: Colors.red,
      size: step,
      isAnimated: true,
    );
  }

  List<Piece> getPices() {
    final pieces = <Piece>[];
    draw();
    drawFood();
    for (var i = 0; i < length; ++i) {
      if (i >= positions.length) {
        continue;
      }
      pieces.add(
        Piece(
          posX: positions[i].dx.toInt(),
          posY: positions[i].dy.toInt(),
          size: step,
          color: i.isEven ? Colors.red : Colors.green,
          isAnimated: false,
        ),
      );
    }
    return pieces;
  }

  Widget getScore() {
    return Positioned(
        top: 70.0,
        right: 50.0,
        child: Text("Score : " + score.toString(),
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    lowerBoundY = step;
    lowerBoundX = step;
    upperBoundY = getNearestTens(screenHeight.toInt() - step);
    upperBoundX = getNearestTens(screenWidth.toInt() - step);
    return Scaffold(
      body: Container(
        color: Colors.amber,
        child: Stack(
          children: [
            Stack(
              children: getPices(),
            ),
            getControls(),
            food,
            getScore(),
          ],
        ),
      ),
    );
  }
}
