import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<void> playSuccessBeep() async {
    await _audioPlayer.play(AssetSource('sounds/success_beep.wav'));
  }

  static Future<void> playErrorBeep() async {
    await _audioPlayer.play(AssetSource('sounds/error_beep.wav'));
  }
}