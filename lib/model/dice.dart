import 'dart:math';

import 'package:flutter/cupertino.dart';

class DiceModel extends ChangeNotifier {
  int ludoDice = 1;

  int get diceCount => ludoDice;

  createLudoDice() {
    ludoDice = Random().nextInt(6) + 1;
    notifyListeners();
  }
}
