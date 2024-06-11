import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class TrackManangement {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late int _currentTrack;
  bool _isPlaying = true;
  bool _isLoop = false;
  final ValueNotifier<Duration> _positionNotifier = ValueNotifier(Duration.zero);


  List _tracks = [
    'https://p.scdn.co/mp3-preview/f5d7490c9bc1200f19d924d83d4e25c6c285f236?cid=f6a40776580943a7bc5173125a1e8832',
    'https://p.scdn.co/mp3-preview/b93f984296862260b802f0c4d01e962042bb5a37?cid=f6a40776580943a7bc5173125a1e8832',
    'https://p.scdn.co/mp3-preview/aa214f2af8138024db3a720f8f0f636abea9f36d?cid=f6a40776580943a7bc5173125a1e8832'
  ];



  set currentTrack(int value) {
    _currentTrack = value;
  }

  set isPlaying(bool value) {
    _isPlaying = value;
  }

  set isLoop(bool value) {
    _isLoop = value;
  }

  bool get isPlaying => _isPlaying;

  int get currentTrack => _currentTrack;

  bool get isLoop => _isLoop;

  ValueNotifier<Duration> get positionNotifier => _positionNotifier;

  void setPosition() {
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _positionNotifier.value = newPosition;
    });
  }

  void setPlayMode() {
    if (_isLoop) {
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
    } else {
      _audioPlayer.setReleaseMode(ReleaseMode.release);
    }
  }

  void playOrpause() {
    if (_currentTrack >= 0 && _currentTrack < _tracks.length) {
      Source source = UrlSource(_tracks[_currentTrack]);
      if (_isPlaying) {
        _audioPlayer.play(source);
      } else {
        _audioPlayer.pause();
      }
    } else {
      print("Đã phát hết danh sách");
    }
  }

  void listenPlayComplete() {
    _audioPlayer.onPlayerComplete.listen((event) {
      _currentTrack++;
      playOrpause();
    });
  }

  void seek(Duration position){
    _audioPlayer.seek(position);
  }

}
