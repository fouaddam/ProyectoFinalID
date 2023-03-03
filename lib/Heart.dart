import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'Bullet.dart';
import 'Player1.dart';
import 'SplasheFlame.dart';

class Heart extends SpriteComponent  with CollisionCallbacks,HasGameRef<MyGame> {

  late ShapeHitbox hitbox;
  late Set<Vector2> pointsCollision;
  late int count;

  Heart({
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

    position.clamp(
      Vector2.zero() + size / 2,
      gameRef.size - size / 2,
    );

  }


  @override
  Future<void> update(double dt) async {
    position.y++;

    if(position.y>gameRef.size.y-60){
      removeFromParent();
      print("muy mal");
    }

  }



  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);
    if (other is Player1) {
      removeFromParent();
      print("Corazon");
    }

    if (other is Bullet) {
      removeFromParent();
      print("tienes que chocar contra el Corazon");
    }
  }


}
