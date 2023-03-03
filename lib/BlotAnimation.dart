



import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/effects.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:spacegame/Player1.dart';
import 'package:spacegame/SplasheFlame.dart';

class BlotAnimation extends SpriteAnimationComponent with CollisionCallbacks,HasGameRef<MyGame>{

  late ShapeHitbox hitbox;
  late Vector2 positionBlot;


  BlotAnimation({
    required Vector2 positionBlot,
    required Vector2 size,
  }) :super(position: positionBlot, size: size);




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
    animation=SpriteAnimation.fromFrameData(game.images.fromCache("blot.png"),
        SpriteAnimationData.sequenced(amount: 4, stepTime: 0.5, textureSize: Vector2(16,16)));

    Matrix3.rotationY(0.5);

  }
  @override
  Future<void> update(double dt) async {
   position.y++;

  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);

    if(other is Player1){
      print("Playyeerrrrr1");

    }
  }
}