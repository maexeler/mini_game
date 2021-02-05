import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mini_game/mini_game_model.dart';

class MiniGamePagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var game = Provider.of<MiniGame>(context);
    return _selectGamePage(game);
  }

  Widget _selectGamePage(MiniGame game) {
    switch (game.state) {
      case MiniGameStatus.waitForStart:
        return MiniGamePage(title: 'Start', nextState: MiniGameStatus.running);
      case MiniGameStatus.running:
        return MiniGamePage(title: 'Running', nextState: MiniGameStatus.endOfGame);
      case MiniGameStatus.endOfGame:
        return MiniGamePage(title: 'End', nextState: MiniGameStatus.waitForStart);
    }
  }
}

class MiniGamePage extends StatelessWidget {
  final title;
  final nextState;
  const MiniGamePage({Key key, this.title, this.nextState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var game = Provider.of<MiniGame>(context);
    return Scaffold(
      appBar: AppBar(title: Text('$title')),
      body: Center(
        child: Column(
          children: [
            Text('${game.state}'),
            RaisedButton(
              child: Text('$nextState'),
                onPressed: () { game.state = nextState; }
            )
          ],
        ),
      ),
    );
  }

}