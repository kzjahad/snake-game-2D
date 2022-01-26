// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Piece extends StatefulWidget {
  final int posX, posY, size;
  final bool isAnimated;
  final Color color;
  const Piece(
      {Key? key,
      required this.posX,
      required this.posY,
      required this.size,
      required this.color,
      this.isAnimated = false})
      : super(key: key);

  @override
  _PieceState createState() => _PieceState();
}

class _PieceState extends State<Piece> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      lowerBound: 0.25,
      upperBound: 1.0,
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reset();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.posY.toDouble(),
      left: widget.posX.toDouble(),
      child: Opacity(
        opacity: widget.isAnimated ? animationController.value : 1,
        child: Container(
          width: widget.size.toDouble(),
          height: widget.size.toDouble(),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            border: Border.all(width: 2.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
