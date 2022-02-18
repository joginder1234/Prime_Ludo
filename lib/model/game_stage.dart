import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ludo/commons/colors.dart';

class GameStage {
  String? image;
  String? title;
  GameStage(this.image, this.title);
}

class GameLevelProvider with ChangeNotifier {
  List<GameStage> gameStage = [
    GameStage('assets/common/stage1.png', 'PLAY WITH FRIENDS'),
    GameStage('assets/common/stage2.png', 'PLAY ONLINE (PAID)'),
    GameStage('assets/common/stage3.jpeg', 'RAPID PLAY'),
  ];

  List<Column> setGameLevels(Function ontap) {
    final gameLevels = gameStage.map((e) => playCard(e, ontap)).toList();
    return gameLevels;
  }

  Column playCard(GameStage e, Function ontap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 220,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Stack(children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(e.image.toString())),
          ]),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          e.title.toString(),
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: whitecolor),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            ontap();
          },
          child: Image.asset(
            'assets/common/start.png',
            width: 120,
          ),
        )
      ],
    );
  }
}
