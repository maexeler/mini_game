import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Game {
  final GameView gameView;
  final GameEngine gameEngine;

  Game(this.gameEngine, this.gameView);
}

enum GameState { waitForStart, running, endOfGame }

abstract class GameEngine extends ChangeNotifier {
  /// This function is called every 20 ms
  ///
  /// Do whatever you have to do here.
  /// If something changed, you should call forceRedraw()
  void updatePhysicsEngine(int tickCounter);

  /// Called whenever the game status changes
  void stateChanged(GameState oldState, GameState newState);

  GameState get state => _state;

  get tickCounter => _tickCounter;

  set state(GameState state) {
    if (_state == state) {
      return;
    }

    stateChanged(_state, state);
    _state = state;
    if (_state == GameState.running) {
      _startGameLoop();
    } else {
      _stopGameLoop();
    }
    forceRedraw();
  }

  void forceRedraw() {
    notifyListeners();
  }

  Timer? _timer;
  int _tickCounter = 0;
  GameState _state;

  GameEngine() : this._state = GameState.waitForStart;

  void _startGameLoop() {
    _tickCounter = 0;
    _startTimer(20);
    state = GameState.running;
  }

  void _stopGameLoop() {
    _timer?.cancel();
  }

  void _startTimer(int milliseconds) {
    _stopGameLoop();
    _timer = Timer.periodic(Duration(milliseconds: milliseconds), (_) {
      _processTimeTick();
    });
  }

  void _processTimeTick() {
    ++_tickCounter;
    updatePhysicsEngine(_tickCounter);
  }
}

abstract class GameView extends StatelessWidget {
  final String title;

  GameView(this.title);

  Widget getStartPageContent(BuildContext context);

  Widget getRunningPageContent(BuildContext context);

  Widget getEndOfGamePageContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    var game = Provider.of<GameEngine>(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: selectGamePageContent(context, game.state),
    );
  }

  Widget selectGamePageContent(BuildContext context, GameState state) {
    switch (state) {
      case GameState.running:
        return getRunningPageContent(context);
      case GameState.endOfGame:
        return getEndOfGamePageContent(context);
      case GameState.waitForStart:
        return getStartPageContent(context);
    }
  }
}
