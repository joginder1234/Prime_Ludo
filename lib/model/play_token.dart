import 'package:equatable/equatable.dart';

enum TokenType { green, yellow, blue, red }
enum TokenCurrentState { initial, home, normal, safe, pairSafe }

class Token {
  final int id;
  final TokenType type;
  TokenCurrentState tokenState;
  TokenPosition position;
  late int pathPosition;
  Token(this.id, this.type, this.position, this.tokenState);
}

class TokenPosition extends Equatable {
  final int row;
  final int col;
  TokenPosition(this.row, this.col);

  @override
  // TODO: implement props
  List<Object?> get props => [row, col];
}
