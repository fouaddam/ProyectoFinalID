import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spacegame/BulletEnemy.dart';
import 'package:spacegame/HealthBar.dart';
import 'package:spacegame/Heart.dart';
import 'package:spacegame/SplasheFlame.dart';

import 'Bullet.dart';
import 'HomeScreen/GameOverMenu.dart';
import 'Player2.dart';


class Player1 extends SpriteComponent with HasGameRef<MyGame>,CollisionCallbacks,KeyboardHandler {

     late ShapeHitbox hitbox;
     final Random _random = Random();
     double dRadius = 0.5;
     late int count;
     var _colors=Colors.purpleAccent;
     Vector2 keyboardDelta = Vector2.zero();
     static int chivato=0;
      late int directionHor ;
      late int directionVer ;



     static final _keysWatched = {
       LogicalKeyboardKey.keyW,
       LogicalKeyboardKey.keyA,
       LogicalKeyboardKey.keyS,
       LogicalKeyboardKey.keyD,
       LogicalKeyboardKey.space,
       LogicalKeyboardKey.arrowLeft,
       LogicalKeyboardKey.arrowRight,
       LogicalKeyboardKey.arrowUp,
       LogicalKeyboardKey.arrowDown,
     };


  Player1({
    required Vector2 position,
    required Vector2 size,
  }) :super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();



    count=100;

    hitbox = RectangleHitbox();
    hitbox.renderShape = false;

    add(hitbox);
  }

  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2(0.5, -1)) * 300;
  }


  @override
  void onMount() {
    // TODO: implement onMount
    super.onMount();

  }

  @override
  void update(double dt) {
    super.update(dt);

   //gameRef.player1.position.add(Vector2(directionHor*10, directionVer*10));


    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: 80,
        lifespan: 0.1,
        generator: (i) =>
            AcceleratedParticle(
              acceleration: getRandomVector(),
              speed: getRandomVector(),
              position: (position + Vector2(51, size.y-15)),
              child: CircleParticle(
                radius: dRadius,
                paint: Paint()
                  ..color = _colors,
              ),
            ),
      ),
    );

    gameRef.add(particleComponent);

    if(count<=0){
        position.y=position.y+200*dt;//si el count es 0 cambiamos la direccion del la nave
        position.x=position.x+200*dt;

          if(position.y>gameRef.size.y){
            removeFromParent();
          }
    }
    /*if((position.x>0 && keyboardDelta.x.isNegative)||(position.x<gameRef.size.x-100 && !keyboardDelta.x.isNegative)){
      position.add(Vector2(directionHor*10, 0));
    }
    if((position.y>10 && keyboardDelta.y.isNegative) ||(!keyboardDelta.y.isNegative && position.y<gameRef.size.y-100)){
      position.add(Vector2(0,  directionVer*10));
    }*/
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);
    if (other is Player2 || other is BulletEnemy) {
      FlameAudio.play("explosion.mp3");
      count=count-10;
      gameRef.camera.shake(intensity: 10);
      //gameRef.health=gameRef.health-10;
        //print(gameRef.health);
      if(count<=10){

        dRadius=5;
        _colors=Colors.deepOrangeAccent;
        add(OpacityEffect.fadeOut(EffectController(
            alternate: true,duration: 0.5,repeatCount: 3
        )));

      }
      if(count<=0){
        dRadius=15;


      }


    }else if(other is Heart && count<100){
      FlameAudio.play('success.mp3');
      count=count+10;
      if(count>10){
        dRadius = 0.3;
        _colors=Colors.purpleAccent;
      }
    }


  }


  int getCount(){
    return this.count;
  }

     @override
     bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
       // Set this to zero first - if the user releases all keys pressed, then
       // the set will be empty and our vector non-zero.
       keyboardDelta.setZero();
       directionHor=0;
       directionVer=0;

       if (!_keysWatched.contains(event.logicalKey)) return true;

       if (event is RawKeyDownEvent &&
           !event.repeat &&
           event.logicalKey == LogicalKeyboardKey.space) {

         Bullet bullet=Bullet(sprite:gameRef.spriteSheet.getSpriteById(2),
             position:gameRef.player1.position-position + Vector2(-30, size.y-25),size:Vector2(20,30),level: 1);


         Bullet bullet2=Bullet(sprite:gameRef.spriteSheet.getSpriteById(2),
             position:gameRef.player1.position.clone()-position + Vector2(15, size.y-25),size:Vector2(20,30),level: 1);

         Bullet bullet3=Bullet(sprite:gameRef.spriteSheet.getSpriteById(2),
             position:gameRef.player1.position.clone()-position + Vector2(60, size.y-25),size:Vector2(20,30),level: 1);


         Bullet bullet4=Bullet(sprite:gameRef.spriteSheet.getSpriteById(2),
             position:gameRef.player1.position.clone()-position + Vector2(60, size.y-25),size:Vector2(20,30),level: 1);

         add(bullet);
         bullet.direction.x-=1;
         bullet.direction.y-=1;
         add(bullet2);
         bullet2.direction.x-=0.4;
         bullet2.direction.y-=0.5;
         add(bullet3);
         bullet3.direction.x+=0.6;
         bullet3.direction.y-=0.7;

         add(bullet4);
         bullet4.direction.x+=1.3;
         bullet4.direction.y-=1.3;
         FlameAudio.play("blaster.mp3");

       }

       if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
         //keyboardDelta.y = -1;
         switch(chivato){
           case 0:gameRef.player1.sprite =
               Sprite(gameRef.images.fromCache("SpaceShips2.png"));chivato++;break;
           case 1:gameRef.player1.sprite =
               Sprite(gameRef.images.fromCache("SpaceShips3.png"));chivato--;break;
         }
       }
       if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
         //keyboardDelta.x = -1;
         gameRef.player1.sprite =
             Sprite(gameRef.images.fromCache("SpaceShips3.png"));

       }
       if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
         //keyboardDelta.y = 1;
         print("SSSSS");
       }
       if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
         //keyboardDelta.x = 1;
         print("DDD");

       }
       if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
         directionVer=1;
         keyboardDelta.y=1;

       }
       if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
         directionVer=-1;
         keyboardDelta.y=-1;
       }

       if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
         directionHor=1;
         keyboardDelta.x=1;
       }

       if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
         directionHor=-1;
         keyboardDelta.x=-1;
       }

       // Handled keyboard input
       return false;
     }

     void spaceSize(){
     /*  position.clamp(
         Vector2.zero() + size / 2,
         gameRef.size - size / 2,
       );*/
     }

     void reset() {
        HealthBar(100);
         position = gameRef.size / 2;
         count=100;
        _colors=Colors.purpleAccent;
        dRadius = 0.5;
     }

}



