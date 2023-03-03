

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spacegame/SplasheFlame.dart';

import 'MainMenu.dart';
import 'PauseButton.dart';

class GameOverMenu extends StatelessWidget {
  static const String id = 'GameOverMenu';
  final MyGame gameRef;


const GameOverMenu({Key? key, required this.gameRef}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Pause menu title.
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 50.0),
          child: Text(
            'Game Over',
            style: TextStyle(
              fontSize: 50.0,
              color: Colors.black,
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

        // Restart button.
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: ElevatedButton(
            onPressed: () {
              gameRef.overlays.remove("GameOverMenu");
              gameRef.reset();
              gameRef.resumeEngine();
              gameRef.overlays.add(PauseButton.id);
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                textStyle: MaterialStateProperty.all(TextStyle(fontSize: 20))),
            child: const Text('Restart',style: TextStyle(color:Colors.black),),
          ),
        ),
        const SizedBox(height: 30,),
        // Exit button.
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: ElevatedButton(
            onPressed: () {
              gameRef.overlays.remove(GameOverMenu.id);
              gameRef.reset();

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const MainMenu(),
                ),
              );
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                textStyle: MaterialStateProperty.all(TextStyle(fontSize: 20))),
            child:  const Text('Exit',style: TextStyle(color:Colors.black),),
          ),
        ),
      ],
    ),
  );
}
}