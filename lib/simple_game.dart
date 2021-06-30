import 'package:flutter/material.dart';
import 'package:mini_game/game/game.dart';

class SimpleGameEngine extends GameEngine {
  @override
  void updatePhysicsEngine(int tickCounter) {
    forceRedraw();
  }

  @override
  void stateChanged(GameState oldState, GameState newState) {
    // Do nothing for now
  }
}

class SimpleGameView extends GameView {
  final SimpleGameEngine gameEngine;

  SimpleGameView(String title, this.gameEngine) : super(title);

  @override
  Widget getStartPageContent(BuildContext context) {
    return RaisedButton(
        child: Text('Start Game'),
        onPressed: () {
          gameEngine.state = GameState.running;
        });
  }

  @override
  Widget getRunningPageContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Time: ${gameEngine.tickCounter}'),
        RaisedButton(
            child: Text('End Game'),
            onPressed: () {
              gameEngine.state = GameState.endOfGame;
            })
      ],
    );
  }

  @override
  Widget getEndOfGamePageContent(BuildContext context) {
    return RaisedButton(
        child: Text('Do it again Sam'),
        onPressed: () {
          gameEngine.state = GameState.waitForStart;
        });
  }
}
