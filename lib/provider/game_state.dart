import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:ludo/commons/token_path.dart';
import 'package:ludo/model/play_token.dart';
import 'package:audioplayers/audioplayers.dart';

class GameState with ChangeNotifier {
  List<Token> gameTokens = [];
  List<TokenPosition>? starPositions;
  List<TokenPosition>? greenInitPosition;
  List<TokenPosition>? redInitPosition;
  List<TokenPosition>? blueInitPosition;
  List<TokenPosition>? yelloInitPosition;

  bool movetoken = false;

  int tokentype = 0;

  updateRandom() {
    tokentype = Random().nextInt(4);
    notifyListeners();
  }

  GameState() {
    gameTokens = [
      // Green Tokens
      Token(
          0, TokenType.green, TokenPosition(1, 10), TokenCurrentState.initial),
      Token(
          1, TokenType.green, TokenPosition(1, 13), TokenCurrentState.initial),
      Token(
          2, TokenType.green, TokenPosition(4, 10), TokenCurrentState.initial),
      Token(
          3, TokenType.green, TokenPosition(4, 13), TokenCurrentState.initial),

      // Red tokens

      Token(4, TokenType.red, TokenPosition(1, 1), TokenCurrentState.initial),
      Token(5, TokenType.red, TokenPosition(1, 4), TokenCurrentState.initial),
      Token(6, TokenType.red, TokenPosition(4, 1), TokenCurrentState.initial),
      Token(7, TokenType.red, TokenPosition(4, 4), TokenCurrentState.initial),

      // Blue Tokens

      Token(8, TokenType.blue, TokenPosition(10, 1), TokenCurrentState.initial),
      Token(9, TokenType.blue, TokenPosition(10, 4), TokenCurrentState.initial),
      Token(
          10, TokenType.blue, TokenPosition(13, 1), TokenCurrentState.initial),
      Token(
          11, TokenType.blue, TokenPosition(13, 4), TokenCurrentState.initial),

      // Yellow Tokens

      Token(12, TokenType.yellow, TokenPosition(10, 10),
          TokenCurrentState.initial),
      Token(13, TokenType.yellow, TokenPosition(10, 13),
          TokenCurrentState.initial),
      Token(14, TokenType.yellow, TokenPosition(13, 10),
          TokenCurrentState.initial),
      Token(15, TokenType.yellow, TokenPosition(13, 13),
          TokenCurrentState.initial),
    ];

    starPositions = [
      TokenPosition(1, 8),
      TokenPosition(2, 6),
      TokenPosition(6, 1),
      TokenPosition(6, 12),
      TokenPosition(8, 2),
      TokenPosition(8, 13),
      TokenPosition(12, 8),
      TokenPosition(13, 6),
    ];
    greenInitPosition = [];
    redInitPosition = [];
    blueInitPosition = [];
    yelloInitPosition = [];
  }

  updateMyTurn() {
    if (tokentype >= 3) {
      tokentype = 0;
    } else {
      tokentype++;
    }
    notifyListeners();
  }

  moveToken(Token token, int steps) {
    TokenPosition destination;
    int pathPosition;
    if (token.tokenState == TokenCurrentState.home) return;
    if (token.tokenState == TokenCurrentState.initial && steps != 6) return;
    if (token.tokenState == TokenCurrentState.initial && steps == 6) {
      destination = _getPosition(token.type, 0);
      pathPosition = 0;
      _updateInitalPositions(token);
      _updateBoardState(token, destination, pathPosition);
      gameTokens[token.id].position = destination;
      gameTokens[token.id].pathPosition = pathPosition;
      AudioCache().play('sounds/open_token.wav');
      notifyListeners();
    } else if (token.tokenState != TokenCurrentState.initial) {
      print('Working below 6');
      int step = token.pathPosition + steps;
      if (step > 56) return;
      destination = _getPosition(token.type, step);
      pathPosition = step;

      _updateInitalPositions(token);
      print('updated below 6');
      _updateBoardState(token, destination, pathPosition);
      print('Board Update below 6');
      var cutToken = _updateBoardState(token, destination, pathPosition);
      int duration = 0;
      for (int i = 1; i <= steps; i++) {
        duration = duration + 200;
        var future = Future.delayed(Duration(milliseconds: duration), () {
          int stepLoc = token.pathPosition + 1;
          AudioCache().play('sounds/token_sound.wav');
          gameTokens[token.id].position = _getPosition(token.type, stepLoc);
          gameTokens[token.id].pathPosition = stepLoc;
          token.pathPosition = stepLoc;
          notifyListeners();
        });
        print('moving below 6');
      }
      print('Moved below 6');
      Future.delayed(Duration(milliseconds: duration + 300), () {
        if (steps == 6) {
          return;
        } else {
          updateMyTurn();
        }
      });
      if (cutToken != null) {
        int cutSteps = cutToken.pathPosition;
        AudioCache().play('sounds/cut_token.wav');
        for (int i = 1; i <= cutSteps; i++) {
          duration = duration + 50;
          var future2 = Future.delayed(Duration(milliseconds: duration), () {
            int stepLoc = cutToken.pathPosition - 1;
            gameTokens[cutToken.id].position =
                _getPosition(cutToken.type, stepLoc);
            gameTokens[cutToken.id].pathPosition = stepLoc;
            cutToken.pathPosition = stepLoc;
            notifyListeners();
          });
        }
        var future2 = Future.delayed(Duration(milliseconds: duration), () {
          _cutToken(cutToken);
          notifyListeners();
        });
      }
    }
  }

  Token? _updateBoardState(
      Token token, TokenPosition destination, int pathPosition) {
    Token? cutToken;
    //when the destination is on any star
    if (starPositions!.contains(destination)) {
      gameTokens[token.id].tokenState = TokenCurrentState.safe;
      //this.gameTokens[token.id].tokenPosition = destination;
      //this.gameTokens[token.id].pathPosition = pathPosition;
      return null;
    }
    List<Token> tokenAtDestination = gameTokens.where((tkn) {
      if (tkn.position == destination) {
        return true;
      }
      return false;
    }).toList();
    //if no one at the destination
    if (tokenAtDestination.isEmpty) {
      gameTokens[token.id].tokenState = TokenCurrentState.normal;
      //this.gameTokens[token.id].tokenPosition = destination;
      //this.gameTokens[token.id].pathPosition = pathPosition;
      return null;
    }
    //check for same color at destination
    List<Token> tokenAtDestinationSameType = tokenAtDestination.where((tkn) {
      if (tkn.type == token.type) {
        return true;
      }
      return false;
    }).toList();
    if (tokenAtDestinationSameType.length == tokenAtDestination.length) {
      for (Token tkn in tokenAtDestinationSameType) {
        gameTokens[tkn.id].tokenState = TokenCurrentState.pairSafe;
      }
      gameTokens[token.id].tokenState = TokenCurrentState.pairSafe;
      //this.gameTokens[token.id].tokenPosition = destination;
      //this.gameTokens[token.id].pathPosition = pathPosition;
      return null;
    }
    if (tokenAtDestinationSameType.length < tokenAtDestination.length) {
      for (Token tkn in tokenAtDestination) {
        if (tkn.type != token.type &&
            tkn.tokenState != TokenCurrentState.pairSafe) {
          //cut an unsafe token
          //_cutToken(tkn);
          cutToken = tkn;
        } else if (tkn.type == token.type) {
          gameTokens[tkn.id].tokenState = TokenCurrentState.pairSafe;
        }
      }
      //place token
      gameTokens[token.id].tokenState = tokenAtDestinationSameType.isNotEmpty
          ? TokenCurrentState.pairSafe
          : TokenCurrentState.normal;
      // this.gameTokens[token.id].tokenPosition = destination;
      // this.gameTokens[token.id].pathPosition = pathPosition;
      return cutToken;
    }
  }

  _updateInitalPositions(Token token) {
    switch (token.type) {
      case TokenType.green:
        {
          greenInitPosition?.add(token.position);
        }
        break;
      case TokenType.yellow:
        {
          yelloInitPosition?.add(token.position);
        }
        break;
      case TokenType.blue:
        {
          blueInitPosition?.add(token.position);
        }
        break;
      case TokenType.red:
        {
          redInitPosition?.add(token.position);
        }
        break;
    }
  }

  _cutToken(Token token) {
    switch (token.type) {
      case TokenType.green:
        {
          gameTokens[token.id].tokenState = TokenCurrentState.initial;
          gameTokens[token.id].position = greenInitPosition!.first;
          greenInitPosition!.removeAt(0);
        }
        break;
      case TokenType.yellow:
        {
          gameTokens[token.id].tokenState = TokenCurrentState.initial;
          gameTokens[token.id].position = yelloInitPosition!.first;
          yelloInitPosition!.removeAt(0);
        }
        break;
      case TokenType.blue:
        {
          gameTokens[token.id].tokenState = TokenCurrentState.initial;
          gameTokens[token.id].position = blueInitPosition!.first;
          blueInitPosition!.removeAt(0);
        }
        break;
      case TokenType.red:
        {
          gameTokens[token.id].tokenState = TokenCurrentState.initial;
          gameTokens[token.id].position = redInitPosition!.first;
          redInitPosition!.removeAt(0);
        }
        break;
    }
  }

  TokenPosition _getPosition(TokenType type, step) {
    TokenPosition destination;
    switch (type) {
      case TokenType.green:
        {
          List<int> node = TokenPath.greenPath[step];
          destination = TokenPosition(node[0], node[1]);
        }
        break;
      case TokenType.yellow:
        {
          List<int> node = TokenPath.yellowPath[step];
          destination = TokenPosition(node[0], node[1]);
        }
        break;
      case TokenType.blue:
        {
          List<int> node = TokenPath.bluePath[step];
          destination = TokenPosition(node[0], node[1]);
        }
        break;
      case TokenType.red:
        {
          List<int> node = TokenPath.redPath[step];
          destination = TokenPosition(node[0], node[1]);
        }
        break;
    }
    return destination;
  }
}
