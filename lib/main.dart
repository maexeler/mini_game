import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mini_game/game/game.dart';
import 'package:mini_game/move_test.dart';
import 'package:mini_game/simple_game.dart';
import 'package:mini_game/scissor_stone_paper.dart';

void main() {
  // var gameEngine = SimpleGameEngine();
  // var gameView = SimpleGameView('Simple Game Demo', gameEngine);
  // var game = Game(gameEngine, gameView);

  // var gameEngine = ScissorStonePaperEngine();
  // var gameView = ScissorStonePaperView('Scissor Stone Paper', gameEngine);
  // var game = Game(gameEngine, gameView);

  var gameEngine = MoveGameEngine();
  var gameView = MoveGameView('Simple Game Demo', gameEngine);
  var game = Game(gameEngine, gameView);

  runApp(MyApp(game));
}

class MyApp extends StatelessWidget {
  final Game game;

  MyApp(this.game);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameEngine>.value(
        value: game.gameEngine,
        child: MaterialApp(
          title: game.gameView.title,
          theme: ThemeData(
            primarySwatch: Colors.yellow,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: game.gameView,
        ));
  }
}
