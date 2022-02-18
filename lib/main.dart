import 'package:flutter/material.dart';
import 'package:ludo/model/game_stage.dart';
import 'package:ludo/commons/game_setting.dart';
import 'package:ludo/provider/game_state.dart';
import 'package:ludo/screens/dashboard.dart';
import 'package:provider/provider.dart';

import 'model/dice.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => GameState()),
          ChangeNotifierProvider(create: (context) => GameLevelProvider()),
          ChangeNotifierProvider(create: (context) => DiceModel()),
          ChangeNotifierProvider(create: (context) => GameSetting()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'PRIME LUDO',
            home: GameDashBoard()));
  }
}
