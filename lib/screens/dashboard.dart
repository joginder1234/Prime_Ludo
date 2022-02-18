import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ludo/commons/colors.dart';
import 'package:ludo/model/game_stage.dart';
import 'package:ludo/provider/game_state.dart';
import 'package:ludo/screens/board.dart';
import 'package:provider/provider.dart';

class GameDashBoard extends StatefulWidget {
  GameDashBoard({Key? key}) : super(key: key);

  @override
  State<GameDashBoard> createState() => _GameDashBoardState();
}

class _GameDashBoardState extends State<GameDashBoard> {
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final stage = Provider.of<GameLevelProvider>(context);
    double fheight = MediaQuery.of(context).size.height;
    double fwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        height: fheight,
        width: fwidth,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/bg.png',
              fit: BoxFit.cover,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/common/jungle.png',
                      width: fwidth * 0.6,
                    )
                  ],
                ),
                Image.asset(
                  'assets/common/jungle2.png',
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: fwidth,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        userBadge(),
                        Container(
                          decoration: const BoxDecoration(
                              color: whitecolor, shape: BoxShape.circle),
                          child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.settings,
                                color: bluecolor,
                              )),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white24, shape: BoxShape.circle),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.share,
                          color: whitecolor,
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white24, shape: BoxShape.circle),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications,
                          color: whitecolor,
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white24, shape: BoxShape.circle),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.store_mall_directory_sharp,
                          color: whitecolor,
                        )),
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 80,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: fwidth * 0.2),
                  child: Image.asset('assets/common/p_logo.png'),
                ),
                const SizedBox(
                  height: 40,
                ),
                CarouselSlider(
                  items: stage.setGameLevels(() {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => LudoBoard(gameState)));
                  }),
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.6,
                    aspectRatio: 1,
                    initialPage: 2,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: fwidth * 0.75,
                  child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        snackButton(fwidth),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image.asset(
                                  'assets/common/snack.png',
                                  width: 110,
                                ),
                                const SizedBox(
                                  width: 20,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        )
                      ]),
                ),
                SizedBox(
                  height: fheight * 0.07,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Container snackButton(double fwidth) {
    return Container(
      height: 80,
      width: fwidth * 0.75,
      decoration: BoxDecoration(
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 15)],
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 4, 97, 184),
              Color.fromARGB(255, 47, 161, 214),
            ],
            begin: FractionalOffset(0.0, 1.0),
            end: FractionalOffset(0.7, 0.2),
            stops: [0.0, 0.7],
            tileMode: TileMode.clamp),
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: fwidth * 0.73,
              height: 7,
              decoration: const BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
            ),
          )
        ],
      ),
    );
  }

  Row userBadge() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: whitecolor, width: 1.2)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              'assets/account/avatar.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Username',
              style: TextStyle(
                  fontSize: 16, color: whitecolor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Image.asset(
                    'assets/coin1.png',
                    width: 15,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    '1000',
                    style: TextStyle(fontSize: 13, color: whitecolor),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Icon(
                    Icons.add,
                    color: goldcolor,
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
