import 'package:flutter_sound/flutter_sound.dart';
import 'package:ws_flutter_app/ws_utils/ws_log/ws_logger.dart';

class WSAudioPlayer {
  factory WSAudioPlayer() => _getInstance();

  static WSAudioPlayer get instance => _getInstance();
  static WSAudioPlayer? _instance;

  WSAudioPlayer._internal();

  static WSAudioPlayer _getInstance() {
    _instance ??= WSAudioPlayer._internal();
    return _instance!;
  }

  FlutterSoundPlayer? _player;

  Future init() async {
    _player = FlutterSoundPlayer();

    await _player?.openPlayer().then((value) {
      WSLogger.debug('WSAudioPlayer init ');
    });
    await _player?.setSubscriptionDuration(const Duration(milliseconds: 100));
    _player?.onProgress?.listen((event) {
      WSLogger.debug('WSAudioPlayer onProgress ${event.duration}');
    });
  }

  Future play(String url, [Function()? onFinished]) async {
    if (_player == null) {
      await init();
    }
    if (_player?.playerState == PlayerState.isPlaying) {
      await stop();
    }
    return _player?.startPlayer(fromURI: url, codec: Codec.mp3, whenFinished: onFinished);
  }

  Future stop() async {
    await _player?.stopPlayer();
  }
}
