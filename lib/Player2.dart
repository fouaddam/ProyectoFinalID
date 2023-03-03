import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:spacegame/Bullet.dart';
import 'package:spacegame/SplasheFlame.dart';

import 'Player1.dart';



class Player2 extends SpriteComponent  with CollisionCallbacks,HasGameRef<MyGame> {

     late ShapeHitbox hitbox;
     late Set<Vector2> pointsCollision;
      int iScore=0;
     final Random _random=Random();
     final _hpText = TextComponent(
      text: '10 HP',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.red,
          fontSize: 15,
          fontFamily: 'BungeeInline',
        ),
      ),
    );

  Player2({
    required Vector2 position,
    required Vector2 size,
    required Sprite sprite
  }) :super(sprite:sprite,position: position, size: size);

  @override
  Future<void> onLoad() async {
    sprite =  sprite;

    hitbox = RectangleHitbox();
    hitbox.renderShape = false;

    add(hitbox);
  }


  @override
  void onMount() {
    super.onMount();
    final shape = CircleHitbox.relative(
      0.4,
      parentSize: size,
      position: size / 4,
      anchor: Anchor.center,
    );

    int num=getInt(1,3)*100;

    _hpText.angle = pi;
    _hpText.position = Vector2(27, 80);
    _hpText.text='$num';
    _hpText.flipHorizontally();
    add(_hpText);
  }

  @override
  Future<void> update(double dt) async {
    if(gameRef.remaninTime==0){
     // angle+=2000 *dt;
      position.y++;
    }else if(gameRef.remaninTime>=0){
      position.y++;
    }


    if (position.y > gameRef.size.y - 60) {
      removeFromParent();
      print("muy mal");
    }

    position.clamp(
      Vector2.zero() + size / 2,
      gameRef.size - size / 2,
    );
  }


  Vector2 getRandomVector() {
    return(Vector2.random(_random) - Vector2.random(_random)) * 500;
  }

  int getInt(int low,int high){
    return _random.nextInt(high - low) + low;
  }


  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);
    if (other is Player1) {
      removeFromParent();
      print("mal");
      gameRef.camera.shake(intensity: 10);
    }
    if (other is Bullet) {
      iScore+=int.parse(_hpText.text.toString());
      gameRef.hitpoint+=int.parse(_hpText.text.toString());
      removeFromParent();


     // print(iScore.toString());

      final particleComponent = ParticleSystemComponent(
        particle: Particle.generate(
          count: 60,
          lifespan: 0.1,
          generator: (i) => AcceleratedParticle(
            acceleration: getRandomVector(),
            speed: getRandomVector(),
            position: position.clone(),
            child: CircleParticle(
              radius: 1,
              paint: Paint()..color = Colors.white,
            ),
          ),
        ),
      );

      gameRef.add(particleComponent);

    }
  }

  int intGetScore(){
    return this.iScore;  }


}
