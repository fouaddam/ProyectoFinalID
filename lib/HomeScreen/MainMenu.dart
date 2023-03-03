import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spacegame/HomeScreen/GameOverMenu.dart';
import 'package:spacegame/HomeScreen/PauseButton.dart';

import '../SplasheFlame.dart';
import 'PauseMenu.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Game title.
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0),
              child: Text(
                'SPACE GAME',
                style: TextStyle(
                  fontSize: 60.0,
                  color: Colors.red,
                  shadows: [
                    Shadow(
                      blurRadius: 20.0,
                      color: Colors.white,
                      offset: Offset(0, 0),
                    )
                  ],
                ),
              ),
            ),

            // Play button.
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  // Push and replace current screen (i.e MainMenu) with
                  // SelectSpaceship(), so that player can select a spaceship.
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>  MyGameMenu(),
                    ),
                  );
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                    textStyle: MaterialStateProperty.all(TextStyle(fontSize: 20))),

                child: const Text('Play',style: TextStyle(color:Colors.black),),

              ),
            ),

            const SizedBox(height: 20,),
            // Settings button.
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const GameWidget.controlled(gameFactory: MyGame.new),
                    ),
                  );
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                    textStyle: MaterialStateProperty.all(TextStyle(fontSize: 20))),
                child:  const Text('Settings',style: TextStyle(color:Colors.black),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyGameMenu extends StatelessWidget{
  get onPressed => null;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: GameWidget(game: MyGame(),
            overlayBuilderMap:{'PauseMenu':(BuildContext context,MyGame game){
                return PauseMenu(gameRef: game,);
            },'PauseButton':(BuildContext context,MyGame game){
                return (PauseButton(gameRef: game,));
            },'GameOverMenu':(BuildContext context,MyGame game){
               return (GameOverMenu(gameRef: game,));}
      }
      ),
    );
  }
}