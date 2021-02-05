import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum MiniGameStatus{
  waitForStart, running, endOfGame
}
class MiniGame extends ChangeNotifier  {
  MiniGameStatus _state;
  MiniGame(): this._state = MiniGameStatus.waitForStart;
  int actualPoints;
  int tickCounter;

  MiniGameStatus get state => _state;
  set state(MiniGameStatus state) {
    this._state = state;
    notifyListeners();
  }
  void startGame() {
    tickCounter = 10;
    actualPoints = 0;
    _startTimer(1);
    state = MiniGameStatus.running;
  }
  void _startTimer(int seconds) {
    Timer(Duration(seconds: seconds), () {_tick();});
  }
  void _tick() {
    if (tickCounter == 0) {
      state = MiniGameStatus.endOfGame;
    } else {
      _startTimer(1);
    }
  }
}
