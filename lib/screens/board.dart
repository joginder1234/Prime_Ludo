import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:ludo/commons/colors.dart';
import 'package:ludo/commons/game_setting.dart';
import 'package:ludo/commons/scor_banner.dart';
import 'package:ludo/commons/user_icon.dart';
import 'package:ludo/dice/dice_model.dart';
import 'package:ludo/dice/token_play_cards.dart';
import 'package:ludo/model/play_token.dart';
import 'package:ludo/playboard.dart/game_row_colums.dart';
import 'package:ludo/provider/game_state.dart';
import 'package:ludo/widgets/settings.dart';
import 'package:provider/provider.dart';

class LudoBoard extends StatefulWidget {
  final GameState gameState;
  LudoBoard(this.gameState);

  @override
  State<LudoBoard> createState() => _LudoBoardState();
}

class _LudoBoardState extends State<LudoBoard> {
  GlobalKey keyBar = GlobalKey();

  int minutes = 1;
  int seconds = 59;
  int countdown = 4;
  bool waiting = false;
  Timer? _timer;
  bool showVictory = false;
  bool boardBuild = false;
  List<double> dimentions = [0, 0, 0, 0];
  final List<List<GlobalKey>> keyRefrences = _getGlobalKeys();
  List<PlayToken> allTokens = [];
  RenderBox? renderBoxBar;
  bool showSetting = false;

  List<Container> _getRows() {
    List<Container> rows = [];
    for (var i = 0; i < 15; i++) {
      rows.add(
        Container(
          child: LudoRow(i, keyRefrences[i]),
        ),
      );
    }
    return rows;
  }

  List<PlayToken> _getTokenList() {
    List<PlayToken> widgets = [];
    for (Token token in widget.gameState.gameTokens) {
      if (boardBuild) {
        widgets.add(PlayToken(
            token, _getPosition(token.position.row, token.position.col)));
      }
    }
    return widgets;
  }

  static List<List<GlobalKey>> _getGlobalKeys() {
    List<List<GlobalKey>> keysMain = [];
    for (int i = 0; i < 15; i++) {
      List<GlobalKey> keys = [];
      for (int j = 0; j < 15; j++) {
        keys.add(GlobalKey());
      }
      keysMain.add(keys);
    }
    return keysMain;
  }

  List<double> _getPosition(int row, int column) {
    List<double> listFrame = [];
    double x;
    double y;
    double w;
    double h;
    if (keyBar.currentContext == null) return [0, 0, 0, 0];
    final RenderBox? renderBoxBar =
        keyBar.currentContext!.findRenderObject() as RenderBox;

    final sizeBar = renderBoxBar?.size;
    final cellBoxKey = keyRefrences[row][column];
    final RenderBox? renderBoxCell =
        cellBoxKey.currentContext!.findRenderObject() as RenderBox;
    final positionCell = renderBoxCell?.localToGlobal(Offset.zero);
    x = positionCell!.dx - 5;
    y = (positionCell.dy - sizeBar!.height - 15);
    w = renderBoxCell!.size.width + 10;
    h = renderBoxCell.size.height + 10;
    listFrame.add(x);
    listFrame.add(y);
    listFrame.add(w);
    listFrame.add(h);
    return listFrame;
  }

  @override
  void initState() {
    super.initState();
    widget.gameState.updateRandom();
    WidgetsBinding.instance?.addPostFrameCallback((context) {
      setState(() {
        boardBuild = true;
      });
    });
    setState(() {
      waiting = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        countdown--;
      });
    });
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        waiting = false;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          seconds--;
        });
        if (seconds <= 0) {
          setState(() {
            seconds = 59;
            minutes--;
          });
          if (minutes < 0) {
            setState(() {
              _timer?.cancel();
              seconds = 0;
              minutes = 0;
              showVictory = true;
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xff123e4a),
        elevation: 0,
        key: keyBar,
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_back,
              color: whitecolor,
            )),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xff086E7D)),
              child: const Icon(
                Icons.wine_bar,
                color: whitecolor,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xff086E7D)),
              child: const Icon(
                Icons.topic_outlined,
                color: whitecolor,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color(0xff086E7D)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/coin1.png'),
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  '500',
                  style: TextStyle(
                      color: whitecolor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  child: const Icon(
                    Icons.add,
                    color: goldcolor,
                  ),
                )
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  showSetting = true;
                });
              },
              icon: const Icon(
                Icons.settings,
                color: goldcolor,
              )),
        ],
      ),
      body: Stack(children: [
        SizedBox(
          width: width,
          height: height,
          child: Stack(children: [
            SizedBox(
              height: height,
              width: width,
              child: Image.asset(
                'assets/bg.png',
                fit: BoxFit.cover,
              ),
            ),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.maxWidth < 400) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 20,
                      ),
                      Container(
                          padding: const EdgeInsets.all(2),
                          width: width,
                          decoration: BoxDecoration(
                              border: Border.all(color: goldcolor, width: 1.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    child: Ink(
                                      child: const Icon(
                                        Icons.arrow_back,
                                        color: whitecolor,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ScoreBanner(
                                    width: width,
                                    height: 35,
                                    alignment: AlignmentDirectional.centerEnd,
                                    showBannerBg: false,
                                    textsize: 15,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  timer(16)
                                ],
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  children: [
                                    UserIcon(height: 30, width: 30),
                                    const Text(
                                      'User 1',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: whitecolor),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                diceBox(redcolor, 30)
                              ],
                            ),
                            Row(
                              children: [
                                diceBox(greencolor, 30),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    UserIcon(height: 30, width: 30),
                                    const Text(
                                      'User 1',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: whitecolor),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ludoBoard(width),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  children: [
                                    UserIcon(height: 30, width: 30),
                                    const Text(
                                      'User 1',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: whitecolor),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                diceBox(bluecolor, 30)
                              ],
                            ),
                            Row(
                              children: [
                                diceBox(yellowcolor, 30),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    UserIcon(height: 30, width: 30),
                                    const Text(
                                      'User 1',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: whitecolor),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (constraints.maxWidth > 400 &&
                    constraints.maxWidth < 900) {
                  return Stack(children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 90,
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  Image.asset('assets/prize1.png'),
                                  Positioned(
                                    bottom: 30,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'Board : ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          '100.00',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            timer(16),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    children: [
                                      UserIcon(height: 50, width: 50),
                                      const Text(
                                        'User 1',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: whitecolor),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  widget.gameState.tokentype == 0
                                      ? const Dice()
                                      : initDice()
                                ],
                              ),
                              Row(
                                children: [
                                  widget.gameState.tokentype == 1
                                      ? const Dice()
                                      : initDice(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      UserIcon(height: 50, width: 50),
                                      const Text(
                                        'User 1',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: whitecolor),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ludoBoard(width),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    children: [
                                      UserIcon(height: 50, width: 50),
                                      const Text(
                                        'User 1',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: whitecolor),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  widget.gameState.tokentype == 3
                                      ? const Dice()
                                      : initDice()
                                ],
                              ),
                              Row(
                                children: [
                                  widget.gameState.tokentype == 2
                                      ? const Dice()
                                      : initDice(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      UserIcon(height: 50, width: 50),
                                      const Text(
                                        'User 1',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: whitecolor),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ..._getTokenList()
                  ]);
                } else if (constraints.maxWidth > 900 &&
                    constraints.maxWidth < 1200) {
                  return _myLayout(width, 50);
                } else {
                  return _myLayout(width, 50);
                }
              },
            ),
            widget.gameState.gameTokens.any(
                    (element) => element.tokenState == TokenCurrentState.home)
                ? Container(
                    color: Colors.black45,
                    height: height,
                    width: width,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: goldcolor, width: 1.2)),
                        width: width * 0.7,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/win2.jpg',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox()
          ]),
        ),
        waiting
            ? Container(
                height: height,
                width: width,
                color: Colors.black54,
                child: Center(
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(30)),
                    width: width * 0.8,
                    child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset('assets/wait.jpg')),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Waiting for all players\nto connect.',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey.shade700),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const CircularProgressIndicator(),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                countdown.toString(),
                                style: const TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                            ],
                          )
                        ]),
                  ),
                ),
              )
            : const SizedBox(),
        showSetting
            ? SettingBadge(closeSetting: () {
                setState(() {
                  showSetting = false;
                });
              }, onPressOk: () {
                setState(() {
                  showSetting = false;
                });
              })
            : const SizedBox()
      ]),
    );
  }

  Card initDice() {
    return Card(
      elevation: 10,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        height: 50,
        width: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.asset(
            'assets/dice/initDice.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Column _myLayout(double width, double barHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: barHeight,
        ),
        ScoreBanner(
          width: width,
          height: 50,
          alignment: AlignmentDirectional.center,
          showBannerBg: true,
          textsize: 13,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [timer(18)],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UserIcon(height: 30, width: 30),
                      const SizedBox(
                        width: 10,
                      ),
                      diceBox(redcolor, 40)
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  userTag('User 1', width, 1, 16)
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      diceBox(greencolor, 40),
                      const SizedBox(
                        width: 10,
                      ),
                      UserIcon(height: 30, width: 30),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  userTag('User 2', width, 2, 16)
                ],
              ),
            ],
          ),
        ),
        //Ludo Play Board
        ludoBoard(width),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userTag('user 3', width, 3, 16),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      UserIcon(height: 30, width: 30),
                      const SizedBox(
                        width: 10,
                      ),
                      diceBox(bluecolor, 40)
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  userTag('User 4', width, 4, 16),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      diceBox(yellowcolor, 40),
                      const SizedBox(
                        width: 10,
                      ),
                      UserIcon(height: 30, width: 30),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container timer(double timersize) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.blueGrey.shade900),
      child: Row(
        children: [
          const Icon(
            Icons.access_alarm,
            color: whitecolor,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            '$minutes : $seconds',
            style: TextStyle(
                color: goldcolor,
                fontWeight: FontWeight.w600,
                fontSize: timersize),
          )
        ],
      ),
    );
  }

  Container ludoBoard(double width) {
    return Container(
      color: Colors.blueGrey.shade100,
      width: width,
      height: width,
      child: Stack(fit: StackFit.expand, children: [
        Column(
          children: [
            Flexible(
              flex: 6,
              child: Container(
                height: width,
                color: Colors.transparent,
                child: Row(
                  children: [
                    //Red Main Box
                    Flexible(
                      flex: 6,
                      child: Container(
                        decoration: BoxDecoration(
                            color: redcolor,
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        width: width,
                        child: Stack(children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset('assets/trans1.png'),
                          ),
                          tokenGridHome()
                        ]),
                      ),
                    ),
                    // Green home Row
                    Flexible(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.all(1),
                        width: width,
                        child: Column(
                          //Green Home Entry
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(child: regularBox()),
                                  Expanded(
                                      child: exitBox(whitecolor,
                                          Icons.arrow_downward, greycolor)),
                                  Expanded(child: regularBox()),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(child: regularBox()),
                                  Expanded(child: inHouseBox(greencolor)),
                                  Expanded(
                                      child: safeBox(
                                          greencolor, Icons.star, whitecolor)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                      child: safeBox(
                                          whitecolor, Icons.star, greycolor)),
                                  Expanded(child: inHouseBox(greencolor)),
                                  Expanded(child: regularBox()),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(child: regularBox()),
                                  Expanded(child: inHouseBox(greencolor)),
                                  Expanded(child: regularBox()),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(child: regularBox()),
                                  Expanded(child: inHouseBox(greencolor)),
                                  Expanded(child: regularBox()),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(child: regularBox()),
                                  Expanded(child: inHouseBox(greencolor)),
                                  Expanded(child: regularBox()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //Green Main Box
                    Flexible(
                      flex: 6,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          width: width,
                          child: Stack(children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset('assets/trans1.png'),
                            ),
                            tokenGridHome()
                          ])),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: SizedBox(
                height: width,
                child: Row(
                  children: [
                    // Red Home Row
                    Flexible(
                      flex: 6,
                      child: Container(
                        margin: const EdgeInsets.all(1),
                        width: width,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(child: regularBox()),
                                  Expanded(
                                      child: safeBox(
                                          redcolor, Icons.star, whitecolor)),
                                  Expanded(child: regularBox()),
                                  Expanded(child: regularBox()),
                                  Expanded(child: regularBox()),
                                  Expanded(child: regularBox()),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: exitBox(whitecolor,
                                          Icons.arrow_forward, greycolor)),
                                  Expanded(child: inHouseBox(redcolor)),
                                  Expanded(child: inHouseBox(redcolor)),
                                  Expanded(child: inHouseBox(redcolor)),
                                  Expanded(child: inHouseBox(redcolor)),
                                  Expanded(child: inHouseBox(redcolor)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(child: regularBox()),
                                  Expanded(child: regularBox()),
                                  Expanded(
                                      child: safeBox(
                                          whitecolor, Icons.star, greycolor)),
                                  Expanded(child: regularBox()),
                                  Expanded(child: regularBox()),
                                  Expanded(child: regularBox()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Victory Box
                    Flexible(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        width: width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/victory.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // Yellow Home Row
                    Flexible(
                      flex: 6,
                      child: Container(
                        margin: const EdgeInsets.all(1),
                        width: width,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(child: regularBox()),
                                  Expanded(child: regularBox()),
                                  Expanded(child: regularBox()),
                                  Expanded(
                                      child: safeBox(
                                          whitecolor, Icons.star, greycolor)),
                                  Expanded(child: regularBox()),
                                  Expanded(child: regularBox()),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(child: inHouseBox(yellowcolor)),
                                  Expanded(child: inHouseBox(yellowcolor)),
                                  Expanded(child: inHouseBox(yellowcolor)),
                                  Expanded(child: inHouseBox(yellowcolor)),
                                  Expanded(child: inHouseBox(yellowcolor)),
                                  Expanded(
                                      child: exitBox(whitecolor,
                                          Icons.arrow_back, greycolor)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(child: regularBox()),
                                  Expanded(child: regularBox()),
                                  Expanded(child: regularBox()),
                                  Expanded(child: regularBox()),
                                  Expanded(
                                      child: safeBox(
                                          yellowcolor, Icons.star, whitecolor)),
                                  Expanded(child: regularBox()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 6,
              child: SizedBox(
                height: width,
                child: Row(
                  children: [
                    // Blue Main Box
                    Flexible(
                      flex: 6,
                      child: Container(
                          decoration: BoxDecoration(
                              color: bluecolor,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          width: width,
                          child: Stack(children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset('assets/trans1.png'),
                            ),
                            tokenGridHome()
                          ])),
                    ),
                    // Blue home row
                    Flexible(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.all(1),
                        width: width,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(child: regularBox()),
                                  Expanded(child: inHouseBox(bluecolor)),
                                  Expanded(child: regularBox()),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(child: regularBox()),
                                  Expanded(child: inHouseBox(bluecolor)),
                                  Expanded(child: regularBox()),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(child: regularBox()),
                                  Expanded(child: inHouseBox(bluecolor)),
                                  Expanded(child: regularBox()),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(child: regularBox()),
                                  Expanded(child: inHouseBox(bluecolor)),
                                  Expanded(
                                      child: safeBox(
                                          whitecolor, Icons.star, greycolor)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                      child: safeBox(
                                          bluecolor, Icons.star, whitecolor)),
                                  Expanded(child: inHouseBox(bluecolor)),
                                  Expanded(child: regularBox()),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(child: regularBox()),
                                  Expanded(
                                      child: exitBox(
                                          whitecolor,
                                          Icons.arrow_upward_outlined,
                                          greycolor)),
                                  Expanded(child: regularBox()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Yellow Main Box
                    Flexible(
                      flex: 6,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.yellow.shade700,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          width: width,
                          child: Stack(children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset('assets/trans1.png'),
                            ),
                            tokenGridHome()
                          ])),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Column(
          children: _getRows().map((e) => Expanded(child: e)).toList(),
        ),
      ]),
    );
  }

  GridView tokenGridHome() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6, childAspectRatio: 1),
      itemCount: 36,
      itemBuilder: (BuildContext context, int i) {
        return i == 7 || i == 10 || i == 25 || i == 28
            ? Container(
                decoration: const BoxDecoration(
                    color: whitecolor, shape: BoxShape.circle),
              )
            : Container();
      },
    );
  }

  Container diceBox(Color bg, double width) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: bg,
          border: Border.all(
            color: whitecolor,
            width: 1.2,
          )),
      child: Image.asset(
        'assets/pngegg.png',
        width: width,
      ),
    );
  }

  Container userTag(String username, double width, int id, double fontsize) {
    return Container(
      alignment:
          id == 1 || id == 3 ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.all(5),
      width: width * 0.4,
      decoration: BoxDecoration(
          borderRadius: id == 1
              ? const BorderRadius.only(topRight: Radius.circular(50))
              : id == 2
                  ? const BorderRadius.only(topLeft: Radius.circular(50))
                  : id == 3
                      ? const BorderRadius.only(
                          bottomRight: Radius.circular(50))
                      : const BorderRadius.only(
                          bottomLeft: Radius.circular(50)),
          color: const Color(0xff04293A)),
      child: Text(
        username,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: fontsize, fontWeight: FontWeight.bold, color: whitecolor),
      ),
    );
  }

  Container regularBox() {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey.shade100),
            color: Colors.white,
            borderRadius: BorderRadius.circular(5)));
  }

  Container inHouseBox(Color color) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey.shade100),
            color: color,
            borderRadius: BorderRadius.circular(5)));
  }

  Container safeBox(Color color, IconData icon, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey.shade100),
          color: color,
          borderRadius: BorderRadius.circular(5)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Icon(
            Icons.star,
            size: 15,
            color: iconColor,
          )
        ],
      ),
    );
  }

  Container exitBox(Color color, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.all(1),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Icon(
            icon,
            size: 15,
            color: iconColor,
          )
        ],
      ),
    );
  }
}
