import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mini_game/game/game.dart';

enum Selection { scissor, stone, paper, noSelection }

enum WinnState { userWins, userLosses, draw }

class ScissorStonePaperEngine extends GameEngine {
  Selection _userSelection;
  Selection _gameSelection;

  final List<Selection> _possibleSelections = [
    Selection.stone,
    Selection.paper,
    Selection.scissor
  ];
  final int _animationSteps = 7;
  int _maxAnimationStep, _actualAnimationStep;
  final Random rnd = Random();

  WinnState _winnState;

  get winnState => _winnState;

  get userSelection => _userSelection;

  set userSelection(selection) {
    _userSelection = selection;
    state = GameState.running;
  }

  get gameSelection => _gameSelection;

  @override
  void updatePhysicsEngine(int tickCounter) {
    if (tickCounter % 10 == 0) {
      _progressAnimation();
    }
  }

  @override
  void stateChanged(GameState oldState, GameState newState) {
    switch (newState) {
      case GameState.waitForStart:
        _userSelection = Selection.noSelection;
        break;
      case GameState.running:
        _initializeAnimation();
        break;
      case GameState.endOfGame:
        _calculateWinner();
    }
  }

  void _initializeAnimation() {
    _actualAnimationStep = 0;
    _maxAnimationStep = _animationSteps + rnd.nextInt(3);
    _gameSelection = _possibleSelections[_actualAnimationStep % 3];
  }

  void _progressAnimation() {
    if (_actualAnimationStep < _maxAnimationStep) {
      ++_actualAnimationStep;
      _gameSelection = _possibleSelections[_actualAnimationStep % 3];
      forceRedraw();
    } else {
      state = GameState.endOfGame;
    }
  }

  void _calculateWinner() {
    if (_userSelection == _gameSelection) {
      _winnState = WinnState.draw;
    } else if (_userSelection == Selection.scissor &&
            _gameSelection == Selection.paper ||
        _userSelection == Selection.stone &&
            _gameSelection == Selection.scissor ||
        _userSelection == Selection.paper &&
            _gameSelection == Selection.stone) {
      _winnState = WinnState.userWins;
    } else {
      _winnState = WinnState.userLosses;
    }
  }
}

class ScissorStonePaperView extends GameView {
  final ScissorStonePaperEngine gameEngine;

  ScissorStonePaperView(String title, this.gameEngine) : super(title);

  @override
  Widget getStartPageContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('The battle is raging:', textScaleFactor: 1.5),
        Text('Brother choose your side', textScaleFactor: 1.5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SspWidget(
                show: Selection.scissor,
                onPressed: () {
                  gameEngine.userSelection = Selection.scissor;
                }),
            SspWidget(
                show: Selection.stone,
                onPressed: () {
                  gameEngine.userSelection = Selection.stone;
                }),
            SspWidget(
                show: Selection.paper,
                onPressed: () {
                  gameEngine.userSelection = Selection.paper;
                })
          ],
        ),
      ],
    );
  }

  @override
  Widget getRunningPageContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Your selection:', textScaleFactor: 1.5),
        SspWidget(show: gameEngine.userSelection, onPressed: null),
        Text('', textScaleFactor: 1.5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SspWidget(
                show: Selection.scissor,
                onPressed: gameEngine._gameSelection == Selection.scissor
                    ? null
                    : () {}),
            SspWidget(
                show: Selection.stone,
                onPressed: gameEngine._gameSelection == Selection.stone
                    ? null
                    : () {}),
            SspWidget(
                show: Selection.paper,
                onPressed: gameEngine._gameSelection == Selection.paper
                    ? null
                    : () {}),
          ],
        ),
      ],
    );
  }

  @override
  Widget getEndOfGamePageContent(BuildContext context) {
    String message = gameEngine.winnState == WinnState.userWins
        ? "You'r a Winner"
        : gameEngine.winnState == WinnState.userLosses
            ? "Bad, you loose"
            : "It's a draw";
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SspWidget(
              show: gameEngine.userSelection,
              onPressed:
                  gameEngine.winnState == WinnState.userWins ? null : () {}),
          SspWidget(
              show: gameEngine.gameSelection,
              onPressed:
                  gameEngine.winnState == WinnState.userLosses ? null : () {}),
          Text('', textScaleFactor: 1.5),
          Text(message, textScaleFactor: 1.5),
          Text('', textScaleFactor: 1.5),
          Text('', textScaleFactor: 1.5),
          RaisedButton(
              child: Text('Play again', textScaleFactor: 1.5),
              onPressed: () {
                gameEngine.state = GameState.waitForStart;
              }),
        ]);
  }
}

class SspWidget extends StatelessWidget {
  final Selection show;
  final Function onPressed;

  SspWidget({this.show, this.onPressed});

  @override
  Widget build(BuildContext context) {
    String message = show == Selection.stone
        ? 'Stone'
        : show == Selection.paper
            ? 'Paper'
            : show == Selection.scissor
                ? 'Scissor'
                : 'Uups?';
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: RaisedButton(
            child: Text('$message', textScaleFactor: 1.5),
            onPressed: onPressed));
  }
}
