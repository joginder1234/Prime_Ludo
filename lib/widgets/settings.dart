import 'package:flutter/material.dart';
import 'package:ludo/commons/game_setting.dart';
import 'package:ludo/main.dart';
import 'package:provider/provider.dart';

class SettingBadge extends StatefulWidget {
  Function closeSetting;
  Function onPressOk;
  SettingBadge({Key? key, required this.closeSetting, required this.onPressOk})
      : super(key: key);

  @override
  State<SettingBadge> createState() => _SettingBadgeState();
}

class _SettingBadgeState extends State<SettingBadge> {
  bool soundOn = false;
  bool musicOn = false;
  bool updateMusic = false;
  bool updateSound = false;
  @override
  void initState() {
    super.initState();
    getSetting();
  }

  getSetting() {
    setState(() {
      soundOn = Provider.of<GameSetting>(context, listen: false).GameSound;
      musicOn = Provider.of<GameSetting>(context, listen: false).GameBgMusic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.width * 1.2,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(30.0),
            child: Stack(alignment: AlignmentDirectional.center, children: [
              Image.asset('assets/settings/setting.png'),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.closeSetting();
                        },
                        child: Image.asset(
                          'assets/settings/close.png',
                          width: 60,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 110,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            soundOn = !soundOn;
                            updateSound = true;
                          });
                        },
                        child: soundOn
                            ? Image.asset(
                                'assets/settings/check.png',
                                width: 40,
                              )
                            : Image.asset(
                                'assets/settings/uncheck.png',
                                width: 40,
                              ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Game Sound',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade700),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            musicOn = !musicOn;
                            updateMusic = true;
                          });
                        },
                        child: musicOn
                            ? Image.asset(
                                'assets/settings/check.png',
                                width: 40,
                              )
                            : Image.asset(
                                'assets/settings/uncheck.png',
                                width: 40,
                              ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Game Music',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade700),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      final gamesetting =
                          Provider.of<GameSetting>(context, listen: false);
                      if (updateMusic && updateSound) {
                        Provider.of<GameSetting>(context, listen: false)
                            .UpdateSetting();
                        Provider.of<GameSetting>(context, listen: false)
                            .playPauseMusic(!gamesetting.GameBgMusic);
                        widget.onPressOk();
                      } else if (updateMusic) {
                        Provider.of<GameSetting>(context, listen: false)
                            .playPauseMusic(!gamesetting.GameBgMusic);
                        widget.onPressOk();
                      } else if (updateSound) {
                        Provider.of<GameSetting>(context, listen: false)
                            .UpdateSetting();
                        widget.onPressOk();
                      }
                    },
                    child: Image.asset(
                      'assets/settings/ok.png',
                      width: 90,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              )
            ])),
      ),
    );
  }
}
