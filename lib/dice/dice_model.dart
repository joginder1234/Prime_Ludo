import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:ludo/commons/game_setting.dart';
import 'package:ludo/model/dice.dart';
import 'package:ludo/model/play_token.dart';
import 'package:ludo/provider/game_state.dart';
import 'package:provider/provider.dart';

class Dice extends StatelessWidget {
  const Dice({Key? key}) : super(key: key);

  int updateDices(DiceModel dice, BuildContext context) {
    final setting = Provider.of<GameSetting>(context, listen: false);

    setting.GameSound ? AudioCache().play('sounds/roll.wav') : null;
    for (int i = 0; i < 6; i++) {
      var duration = 100 + i * 100;
      var future = Future.delayed(Duration(milliseconds: duration), () {
        dice.createLudoDice();
      });
    }
    return dice.diceCount;
  }

  @override
  Widget build(BuildContext context) {
    List<String> _diceImage = [
      "assets/dice/1.png",
      "assets/dice/2.png",
      "assets/dice/3.png",
      "assets/dice/4.png",
      "assets/dice/5.png",
      "assets/dice/6.png",
    ];
    final ludoDice = Provider.of<DiceModel>(context);
    final gameState = Provider.of<GameState>(context);
    final diceCount = ludoDice.diceCount;
    var diceImage = Image.asset(
      _diceImage[diceCount - 1],
      gaplessPlayback: true,
      fit: BoxFit.cover,
    );
    return Card(
      elevation: 10,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        height: 50,
        width: 50,
        child: GestureDetector(
          onTap: () {
            int currentDice = updateDices(ludoDice, context);
            print('CurrentDice :: $currentDice');
            TokenType currentType = gameState.tokentype == 0
                ? TokenType.red
                : gameState.tokentype == 1
                    ? TokenType.green
                    : gameState.tokentype == 2
                        ? TokenType.blue
                        : TokenType.yellow;
            bool moveNext = gameState.gameTokens
                .where((element) => element.type == currentType)
                .toList()
                .any((element) =>
                    element.tokenState != TokenCurrentState.initial);
            Future.delayed(Duration(milliseconds: 1500), () {
              int diceNumber =
                  Provider.of<DiceModel>(context, listen: false).diceCount;
              if (!moveNext && diceNumber != 6) {
                gameState.updateMyTurn();
              } else {
                return;
              }
            });
          },
          child: ClipRRect(
              borderRadius: BorderRadius.circular(5), child: diceImage),
        ),
      ),
    );
  }
}
