
import 'dart:math';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flame/parallax.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:spacegame/BulletEnemy.dart';
import 'package:flame_texturepacker/flame_texturepacker.dart';
import 'package:spacegame/Heart.dart';
import 'package:spacegame/HomeScreen/PauseButton.dart';
import 'package:spacegame/SpaceShipEnemy.dart';
import 'dart:async';
import 'Bullet.dart';
import 'HomeScreen/GameOverMenu.dart';
import 'HomeScreen/MainMenu.dart';
import 'Player1.dart';
import 'Player2.dart';
import 'Score.dart';

class SplashScreenGame extends StatefulWidget {
  @override
  _SplashScreenGameState createState() => _SplashScreenGameState();
}

class _SplashScreenGameState extends State<SplashScreenGame> {
  late FlameSplashController controller;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlameSplashScreen(
        showBefore: (BuildContext context) {
          return const Text('DAM2 GAME', style: TextStyle(
            color: Colors.red,
            fontSize: 40,
            decorationColor: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 20.0,
                color: Colors.white,
                offset: Offset(0, 0),
              )
            ],
            decorationStyle: TextDecorationStyle.wavy,
          ),);
        },

        theme: FlameSplashTheme.dark,
        onFinish: (context) => Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute(builder: (context) => const MainMenu()),
        ),
      ),
    );
  }
}

class MyGame extends Forge2DGame with  HasDraggables
                                      ,HasCollisionDetection
                                      ,TapDetector
                                      ,HasKeyboardHandlerComponents {

  MyGame() :super(gravity: Vector2(0, 200), zoom: 1);


  late JoystickComponent joystickComponent;
  final knobPaint = BasicPalette.yellow.withAlpha(200).paint();
  final backgroundPaint = BasicPalette.black.withAlpha(100).paint();

  late ParallaxComponent parallaxComponent;
  late ParallaxComponent parallaxComponent2;
  late final spriteSheet;
  late Timer countDown;
  int remaninTime = 10;
  late Timer countDown2;
  int remaninTime2 = 20;
  bool start = false;
  int health = 0;
  int hitpoint = 0;
  late Player1 player1;
  late Heart heart;
  late SpaceShipEnemy shipEnemy;
  late SpaceShipEnemy shipEnemy2;
  late BulletEnemy bulletEnemy2;
  late BulletEnemy bulletEnemy3;


      int countEnymyShip=3;
      late TextComponent _playerHealth;

  TextPaint tDialogoTextPaint = TextPaint(
      style: const TextStyle(fontSize: 45, color: Colors.red));

  final _hpText = TextComponent(
    position: Vector2(100, 30),
    textRenderer: TextPaint(
      style: const TextStyle(
        color: Colors.red,
        fontSize: 20,
        fontFamily: 'BungeeInline',
      ),
    ),
  );


  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await images.loadAll(["spaceSheet1.png","SpaceShips2.png","SpaceShips3.png","SpaceShip_Enemy.png","blot.png"]);

    FlameAudio.bgm.initialize();

    await FlameAudio.audioCache
        .loadAll(['laser1.ogg', 'laser2.ogg','success.mp3',"blaster.mp3"]);

    parallaxComponent = await ParallaxComponent.load(
            [
               //ParallaxImageData("bg5.png"),
               //ParallaxImageData("bg6.png"),
               ParallaxImageData("bg2.png"),
              // ParallaxImageData("bg3.png"),
             // ParallaxImageData("bg4.png"),
            ],
        baseVelocity: Vector2(0,-200),
        repeat: ImageRepeat.repeat,
    );
    add(parallaxComponent);

    parallaxComponent2 = await ParallaxComponent.load(
      [
        ParallaxImageData("bg5.png"),
        //ParallaxImageData("bg6.png"),
        //ParallaxImageData("bg2.png"),
        // ParallaxImageData("bg3.png"),
        // ParallaxImageData("bg4.png"),
      ],
      baseVelocity: Vector2(0,-200),
      repeat: ImageRepeat.repeat,
    );



    spriteSheet = SpriteSheet
        .fromColumnsAndRows(image: images.fromCache("spaceSheet1.png"),
        columns: 8, rows: 6);

    joystickComponent = JoystickComponent(
        knob: CircleComponent(radius: 20, paint: knobPaint),
        background: CircleComponent(radius: 40, paint: backgroundPaint),
        margin: const EdgeInsets.only(left: 40, bottom: 40));
    add(joystickComponent);

   /* var spriteSheet2 = await fromJSONAtlas("blot.png","blot.json");
    SpriteAnimation run = SpriteAnimation.spriteList(
        spriteSheet2, stepTime: .1);*/


      player1 = Player1(position: Vector2(200, 250), size: Vector2(100, 100));//nave
      player1
          .sprite = await loadSprite("SpaceShips2.png");
    add(player1);
    add(Score());

    _playerHealth = TextComponent(
      position: Vector2(size.x-370,size.y-610),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.red,
          fontSize: 30,
          fontFamily: 'BungeeInline',
        ),
      ),
    );


       _playerHealth.anchor = Anchor.topRight;
       _playerHealth.positionType = PositionType.viewport;

    add(_playerHealth);

     shipEnemy= SpaceShipEnemy(position: Vector2(300,100), size: Vector2(100,100));
     shipEnemy2= SpaceShipEnemy(position: Vector2(300,250), size: Vector2(100,100));

    //camera.followComponent(player1);

    countDown = Timer(2, onTick: () async {
      if (remaninTime >= 1) {
        remaninTime -= 1;
        Random r = Random();
        int high = size.x as int;

        Player2 player2 = Player2(
            sprite: await spriteSheet.getSpriteById((r.nextInt(12)))
            ,
            position: Vector2((r.nextInt(high - 40) + 40) - 30, 0),
            size: Vector2(80, 80));
        player2.flipVertically();
        add(player2);

        BulletEnemy bulletEnemy = BulletEnemy(
            sprite: spriteSheet.getSprite(5, 6)
            ,
            position: Vector2((r.nextInt(high - 40) + 40) - 30, 0),
            size: Vector2(80, 80));
        add(bulletEnemy);

        BulletEnemy bulletEnemy2 = BulletEnemy(
            sprite: spriteSheet.getSprite(5, 7)
            ,
            position: Vector2((r.nextInt(high - 40) + 40) - 30, 0),
            size: Vector2(80, 80));
        add(bulletEnemy2);

        _hpText.text = player2.intGetScore().toString();

        if (r.nextInt(8) == 6 || r.nextInt(8) == 2) {
          Heart heart = Heart(
              position: Vector2((r.nextInt(high - 40) + 40) - 60, 0),
              size: Vector2(30, 30), sprite: await loadSprite("heart.png"));
          add(heart);

        }else if (remaninTime < 1) {
        //  add(SpaceShipEnemy(position: Vector2(80,250), size: Vector2(100,100)));
          await add(shipEnemy);
          await add(shipEnemy2);

        }
      }
    }, repeat: true);

    countDown2 = Timer(2, onTick: () async {
      if(remaninTime2>=0 && remaninTime <=0 ){
        remaninTime2 -= 1;
        /*BlotAnimation blotAnimation2=BlotAnimation(size: Vector2(40,40), positionBlot: shipEnemy.position.clone()+Vector2(40,0));
        add(blotAnimation2);*/

         bulletEnemy2 = BulletEnemy(
            sprite: spriteSheet.getSprite(4, 0)
            ,
            position: shipEnemy.position.clone()+Vector2(20,0),
            size: Vector2(60, 60));
       //  remove(parallaxComponent);
        // add(parallaxComponent2);

        add(bulletEnemy2);

         bulletEnemy3 = BulletEnemy(
            sprite: spriteSheet.getSprite(4, 0),
            position: shipEnemy2.position.clone()+Vector2(20,0),
            size: Vector2(60, 60));
        add(bulletEnemy3);

        //bulletEnemy2.direction.x-=player1.position.x/100;
        if(player1.position.x>=140 && player1.position.x<=250){
          bulletEnemy2.direction.x;
          bulletEnemy2.direction.y;
        }else if(player1.position.x>250){
          bulletEnemy2.direction.x-=.7;
          bulletEnemy2.direction.y-=.7;
          bulletEnemy3.direction.x-=.7;
          bulletEnemy3.direction.y-=.7;

        }else if(player1.position.x<140){
          bulletEnemy2.direction.x+=.3;
          bulletEnemy2.direction.y+=.3;
          bulletEnemy3.direction.x+=.3;
          bulletEnemy3.direction.y+=.3;
        }
        if(shipEnemy.isRemoved){
          remove(bulletEnemy2);
        }
        if(shipEnemy2.isRemoved){
           remove(bulletEnemy3);
        }
      }
    },repeat: true);

    overlays.add(PauseButton.id);
  }



  @override
  Future<void> update(double dt) async {
    super.update(dt);
    //FlameAudio.bgm.stop();
    //player.position+=joystickComponent.delta/15;
    bool moveLeft = joystickComponent.delta.x.isNegative;
    bool moveRigth = !joystickComponent.relativeDelta.x.isNegative;
    bool moveDown = !joystickComponent.delta.y.isNegative;
    bool moveUp = joystickComponent.delta.y.isNegative;

    double playerVectorx = (joystickComponent.delta * 10 * dt).x;
    double playerVectory = (joystickComponent.delta * 10 * dt).y;

    if ((moveLeft && player1.position.x > 0) ||
        (moveRigth && player1.x < size.x - 85)) {
      player1.position.add(Vector2(playerVectorx, 0));
    }
    if ((moveUp && player1.position.y > 10) ||
        (moveDown && player1.y < size.y - 100)) {
      player1.position.add(Vector2(0, playerVectory));
    }

    //add(enemy);
    if (remaninTime > 0) {
      countDown.update(dt);
    }

    if (remaninTime <= 0 && remaninTime2>0) {
      countDown2.update(dt);
    }

    health = player1.getCount();
    if (health <= 0) {
      // this.pauseEngine();
      //overlays.remove(PauseButton.id);
      children.whereType<Player2>().forEach((enemy) {
        enemy.removeFromParent();
      });

      children.whereType<Bullet>().forEach((bullet) {
        bullet.removeFromParent();
      });

      children.whereType<SpaceShipEnemy>().forEach((SpaceShipEnemy) {
        SpaceShipEnemy.removeFromParent();
      });
      this.overlays.add(GameOverMenu.id);

    }

    _playerHealth.text='${player1.getCount()}%';
    if(player1.getCount()<=0){
      _playerHealth.text='${0}%';
    }


  }

  @override
  Future<void> onTapDown(TapDownInfo info) async {
    // TODO: implement onTapDown
    super.onTapDown(info);
    FlameAudio.play("laser1.ogg");
    Bullet bullet=Bullet(sprite:await loadSprite("missil.png")
          ,position:player1.position.clone()+Vector2(40,-15),size:Vector2(20,30),level: 1);
      add(bullet);

  }

      @override
  void onTapUp(TapUpInfo info) {
    // TODO: implement onTapUp
    super.onTapUp(info);

  }

  @override
  Future<void> render(Canvas canvas) async {
    // TODO: implement render
    super.render(canvas);

    if(health>0){
      canvas.drawRect(
          Rect.fromLTWH(size.x-450,size.y-580, player1.getCount().toDouble(), 20),
          Paint()..color = Colors.red,
      );
           }else if(health<=0){
          canvas.drawRect(
          Rect.fromLTWH(size.x-450,size.y-580, 0, 20),
          Paint()..color = Colors.red,
     );
           }


  }

  void reset() {
    // First reset player, enemy manager and power-up manager .

    if(player1.isRemoved){
      add(player1);
    }

    player1.reset();
    remaninTime = 10;
    remaninTime2=20;

    hitpoint = 0;

    children.whereType<Player2>().forEach((enemy) {
      enemy.removeFromParent();
    });

    children.whereType<Bullet>().forEach((bullet) {
      bullet.removeFromParent();
    });

    children.whereType<SpaceShipEnemy>().forEach((SpaceShipEnemy) {
      SpaceShipEnemy.removeFromParent();
    });

/*
   children.whereType<Heart>().forEach((powerUp) {
      powerUp.removeFromParent();
    });*/


   // add(Score());
   // add(HealthBar(100));
  }



}
