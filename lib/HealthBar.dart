

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:spacegame/SplasheFlame.dart';

class HealthBar extends PositionComponent with HasGameRef<MyGame>{

  HealthBar(this.width);
  double width=100;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Draws a rectangular health bar at top right corner.
    canvas.drawRect(
      Rect.fromLTWH(size.x-450,size.y-580, width, 20),//mas adelante hay que usar esta clase
      Paint()..color = Colors.blue,
    );
    //print(gameRef.health);//funciona
  }


}