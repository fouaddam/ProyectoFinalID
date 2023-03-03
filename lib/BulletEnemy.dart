

import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:spacegame/Bullet.dart';
import 'package:spacegame/SpaceShipEnemy.dart';
import 'Player1.dart';
import 'SplasheFlame.dart';

class BulletEnemy extends SpriteComponent with CollisionCallbacks ,HasGameRef<MyGame>{
  // Speed of the bullet.
  final double _speed = 400;
  final Random _random=Random();



  // Controls the direction in which bullet travels.
  Vector2 direction = Vector2(0, -1);

  BulletEnemy({
    required Sprite? sprite,
    required Vector2? position,
    required Vector2? size,
  }) : super(sprite: sprite, position: position, size: size);

  @override
  void onMount() {
    super.onMount();

    // Adding a circular hitbox with radius as 0.4 times
    //  the smallest dimension of this components size.
    final shape = CircleHitbox.relative(
      0.4,
      parentSize: size,
      position: size / 4,

    );
    shape.renderShape = false;
    add(shape);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    // If the other Collidable is Enemy, remove this bullet.
    if (other is Player1 || other is Bullet) {
        removeFromParent();

        final particleComponent = ParticleSystemComponent(
          particle: Particle.generate(
            count: 100,
            lifespan: 0.1,
            generator: (i) => AcceleratedParticle(
              acceleration: getRandomVector(),
              speed: getRandomVector(),
              position: other.position.clone()+Vector2(30,0),
              child: CircleParticle(
                radius: 1,
                paint: Paint()..color = Colors.orange,
              ),
            ),
          ),
        );

        gameRef.add(particleComponent);

    }

  }

  Vector2 getRandomVector() {
    return(Vector2.random(_random) - Vector2.random(_random)) * 500;
  }


  @override
  void update(double dt) {
    super.update(dt);

    // Moves the bullet to a new position with _speed and direction.
    position -= direction * _speed * dt*2;

    // If bullet crosses the upper boundary of screen
    // mark it to be removed it from the game world.
    if (position.y > 550) {
     removeFromParent();
    }


  }

}