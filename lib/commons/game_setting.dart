import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

class GameSetting with ChangeNotifier {
  bool sound = false;
  bool bgMusic = false;

  bool get GameSound => sound;
  bool get GameBgMusic => bgMusic;

  UpdateSetting() {
    sound = !sound;
    notifyListeners();
  }

  playPauseMusic(bool play) {
    bgMusic = play;

    play == true
        ? AudioCache().play('sounds/bg_music.mp3')
        : AudioPlayer().stop();

    notifyListeners();
  }
}
