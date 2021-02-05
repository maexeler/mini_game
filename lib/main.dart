import 'package:flutter/material.dart';
import 'package:mini_game/mini_game_page.dart';
import 'package:mini_game/mini_game_model.dart';
import 'package:provider/provider.dart';

void main() {
  var game = MiniGame();
  runApp(MyApp(game));
}

class MyApp extends StatelessWidget {
  final MiniGame game;
  MyApp(this.game);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MiniGame>(
      create: (_) => game,
      child: MaterialApp(
        title: 'Mini Game Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MiniGamePagePage(),
      )
    );
  }
}
