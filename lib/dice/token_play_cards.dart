import 'package:flutter/material.dart';
import 'package:ludo/model/dice.dart';
import 'package:ludo/model/play_token.dart';
import 'package:ludo/provider/game_state.dart';
import 'package:provider/provider.dart';

class PlayToken extends StatelessWidget {
  final Token token;
  final List<double> pathDimentions;
  late Function(Token) callBack;
  PlayToken(this.token, this.pathDimentions, {Key? key}) : super(key: key);

  String _getcolor() {
    switch (token.type) {
      case TokenType.green:
        return 'assets/greenToken.png';
      case TokenType.yellow:
        return 'assets/yellowToken.png';
      case TokenType.blue:
        return 'assets/blueToken.png';
      case TokenType.red:
        return 'assets/redToken.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final gameDice = Provider.of<DiceModel>(context);

    return AnimatedPositioned(
      child: GestureDetector(
        onTap: () {
          TokenType currentType = gameState.tokentype == 0
              ? TokenType.red
              : gameState.tokentype == 1
                  ? TokenType.green
                  : gameState.tokentype == 2
                      ? TokenType.yellow
                      : TokenType.blue;
          if (token.type == currentType) {
            gameState.moveToken(token, gameDice.diceCount);
          }
        },
        child: Image.asset(_getcolor()),
      ),
      duration: const Duration(milliseconds: 100),
      left: pathDimentions[0],
      top: pathDimentions[1],
      width: pathDimentions[2],
      height: pathDimentions[3],
    );
  }
}
