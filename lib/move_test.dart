import 'package:flutter/material.dart';
import 'package:mini_game/game/game.dart';
import 'package:mini_game/game/size_provider.dart';

class MoveGameEngine extends GameEngine {
  Size? _gameViewSize;
  double _targetPositionX = 10.0;
  double _targetPositionY = 0.0;

  double get targetPosX => _targetPositionX;
  double get targetPosY => _targetPositionY;

  @override
  void updatePhysicsEngine(int tickCounter) {
    _targetPositionY += 2;
    if (_targetPositionY > _gameViewSize!.height) {
      _targetPositionY = -20.0;
    }
    forceRedraw();
  }

  @override
  void stateChanged(GameState oldState, GameState newState) {
    if (newState == GameState.running) {
      _targetPositionX = 10.0;
      _targetPositionY = 0.0;
    }
  }

  void setGameViewSize(Size? size) {
    if (size != null) _gameViewSize = size;
  }
}

class MoveGameView extends GameView {
  final MoveGameEngine gameEngine;

  MoveGameView(String title, this.gameEngine) : super(title);

  @override
  Widget getStartPageContent(BuildContext context) {
    return Center(
        child: ElevatedButton(
            child: Text('Start Game'),
            onPressed: () {
              gameEngine.state = GameState.running;
            }));
  }

  @override
  Widget getRunningPageContent(BuildContext context) {
    return SizeProviderWidget(
        onChildSize: (size) {
          gameEngine.setGameViewSize(size);
        },
        child: Stack(
          children: [
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Time: ${gameEngine.tickCounter}'),
                ElevatedButton(
                    child: Text('End Game'),
                    onPressed: () {
                      gameEngine.state = GameState.endOfGame;
                    })
              ],
            )),
            Positioned(
                top: gameEngine.targetPosY,
                left: gameEngine.targetPosX,
                child: Container(
                  color: Colors.red,
                  child: SizedBox(
                    height: 20,
                    width: 20,
                  ),
                )),
          ],
        ));
  }

  @override
  Widget getEndOfGamePageContent(BuildContext context) {
    return Center(
        child: ElevatedButton(
            child: Text('Do it again Sam'),
            onPressed: () {
              gameEngine.state = GameState.waitForStart;
            }));
  }
}
