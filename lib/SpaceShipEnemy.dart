

import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:spacegame/Player1.dart';
import 'package:spacegame/SplasheFlame.dart';

import 'Bullet.dart';

class SpaceShipEnemy extends SpriteAnimationComponent with CollisionCallbacks,HasGameRef<MyGame>{

  late ShapeHitbox hitbox;
  late int count=10;
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



  SpaceShipEnemy({
    required Vector2 position,
    required Vector2 size,

  }) :super(position: position, size: size);


  @override
  Future<void>? onLoad() async {
    // TODO: implement onLoad
     await super.onLoad();
    hitbox = RectangleHitbox();
    hitbox.renderShape = false;
    add(hitbox);
  }

  @override
  void onMount() {
    super.onMount();
    animation=SpriteAnimation.fromFrameData(gameRef.images.fromCache("SpaceShip_Enemy.png"),
    SpriteAnimationData.sequenced(amount: 12, stepTime: 0.5, textureSize: Vector2(64,64),amountPerRow: 3));

    add(MoveEffect.by(Vector2(-2*size.x,0), EffectController(
        duration: 6,alternate: true,infinite: true
    )));
    flipVertically();

    _hpText.angle = pi;
    _hpText.position = Vector2(45, 50);
    _hpText.flipHorizontally();
    add(_hpText);


  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
    _hpText.text='$count';
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);

    if(other is Bullet){
      count--;
      if(count==0){
        removeFromParent();
      }
    }
  }

  int getCount(){
    return count;
  }
}