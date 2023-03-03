
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:spacegame/BulletEnemy.dart';
import 'package:spacegame/Player2.dart';
import 'package:spacegame/SpaceShipEnemy.dart';

import 'SplasheFlame.dart';

class Bullet extends SpriteComponent with CollisionCallbacks,HasGameRef<MyGame> {
  // Speed of the bullet.
  final double _speed = 450;

  // Controls the direction in which bullet travels.
  Vector2 direction = Vector2(0, -1);

  // Level of this bullet. Essentially represents the
  // level of spaceship that fired this bullet.
  final int level;

  Bullet({
    required Sprite? sprite,
    required Vector2? position,
    required Vector2? size,
    required this.level,
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
    if (other is Player2 || other is BulletEnemy) {
      removeFromParent();
      FlameAudio.play("explosion.mp3");

    }

    if (other is SpaceShipEnemy) {
      removeFromParent();
      gameRef.camera.shake(intensity: 5);
      FlameAudio.play("explosion.mp3");

    }
  }



    @override
    void update(double dt) {
      super.update(dt);


      // Moves the bullet to a new position with _speed and direction.
      position += direction * _speed * dt;

      // If bullet crosses the upper boundary of screen
      // mark it to be removed it from the game world.
      if (position.y < 0) {
       // removeFromParent();
      }
    }
  }