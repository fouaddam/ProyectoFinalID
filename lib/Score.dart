


import 'dart:ui';

import 'package:flame/components.dart';
import 'package:spacegame/SplasheFlame.dart';

class Score extends TextComponent with HasGameRef<MyGame>{

    late String score;

    @override
  Future<void>? onLoad() async{
    // TODO: implement onLoad
     super.onLoad();
     score=gameRef.hitpoint.toString();
     position=Vector2(330, 30);
     text='Score : $score';
     scale=Vector2(1,1);


  }


    @override
    Future<void> update(double dt) async {
      super.update(dt);
      score=gameRef.hitpoint.toString();
      text='Score $score';
      positionType = PositionType.viewport;


    }




}