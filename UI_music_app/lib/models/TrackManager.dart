import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ui_music_app/screens/gallery.dart';
import 'Track.dart';

class TrackManager {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final Future<List<Track>> _dataRecommendTrack;
  late Future<List<Track>> _dataLocal;
  late final Future<List<Track>> _dataPlaylists;
  late int _currentTrack;
  bool _isPlaying = true;
  bool _isLoop = false;
  double _volume = 1.0;
  final ValueNotifier<Duration> _positionNotifier =
      ValueNotifier(Duration.zero);
  Duration _duration = Duration.zero;
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  List<Track> _tracks = [];
  List<Track> _download = [];
  List<Track> _playlists = [];
  late String _localAudio;
  bool _isSlected = false;

  Future<List<Track>> getPlaylistTracks() async {
    String id = '37i9dQZF1DX4Wsb4d7NKfP';
    String offset = '0';
    String limit = '100';
    List<Track> listTrack = [];
    final response = await http.get(
        Uri.parse(
            "https://spotify23.p.rapidapi.com/playlist_tracks/?id=$id&offset=$offset&limit=$limit"),
        headers: {
          'X-RapidAPI-Key':
              'efa54cf780msh342b557c7a552e0p1ff86bjsnae99b46c9498',
          'X-RapidAPI-Host': 'spotify23.p.rapidapi.com'
        });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final items = data['items'] as List;
      for (var item in items) {
        final track = item['track'];
        final album = track['album'];
        final image = album['images'];
        if (track['name'] != null &&
            track['preview_url'] != null &&
            image[2]['url'] != null) {
          String name = track['name'];
          String preview_url = track['preview_url'];
          String image_url = image[2]['url'];
          Track newTrack = Track(name, preview_url, image_url);
          listTrack.add(newTrack);
        }
      }
      return listTrack;
    } else {
      print(response.statusCode);
      return [];
    }
  }

  Future<List<Track>> getRecommendTrack() async {
    List<Track> list = [];
    String url = 'https://spotify23.p.rapidapi.com/recommendations/';
    String limit = '20';
    String seed_tracks = '0c6xIDDpzE81m2q797ordA';
    String seed_artists = '4NHQUGzhtTLFvgF5SZesLK';
    String seed_genres = 'classical,country';
    final respone = await http.get(
        Uri.parse(
            "$url?limit=$limit&seed_tracks=$seed_tracks&seed_artists=$seed_artists&seed_genres=$seed_genres"),
        headers: {
          'X-RapidAPI-Key':
              '1a4b64013dmsh7a5b750d379beebp1da407jsnf0b488686b62',
          'X-RapidAPI-Host': 'spotify23.p.rapidapi.com'
        });
    if (respone.statusCode == 200) {
      final data = jsonDecode(respone.body);
      final tracks = data['tracks'] as List;
      for (int i = 0; i < tracks.length; i++) {
        if (tracks[i]['name'] != null &&
            tracks[i]['preview_url'] != null &&
            tracks[i]['album']['images'][2]['url'] != null) {
          String name = tracks[i]['name'];
          String preview_url = tracks[i]['preview_url'];
          String image = tracks[i]['album']['images'][2]['url'];
          Track newTrack = Track(name, preview_url, image);
          list.add(newTrack);
        }
      }
      return list;
    } else {
      return [];
    }
  }

  Future<List<Track>> getPlaylistFromFolder() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();
      List<FileSystemEntity> files = await baseStorage!.list().toList();
      List<File> mp3Files = files
          .whereType<File>()
          .where((file) => file.path.endsWith('.mp3'))
          .toList();
      List<File> imgFiles = files
          .whereType<File>()
          .where((file) => file.path.endsWith('.png'))
          .toList();
      List<Map<String, String>> listImg = [];
      for (int i = 0; i < imgFiles.length; i++) {
        String imgName =
            imgFiles[i].path.substring(imgFiles[i].path.lastIndexOf('/') + 1);
        String imgPath = imgFiles[i].path;
        listImg.add({
          'name': imgName,
          'path': imgPath,
        });
      }

      List<Track> list = [];
      for (int i = 0; i < mp3Files.length; i++) {
        String name =
            mp3Files[i].path.substring(mp3Files[i].path.lastIndexOf('/') + 1);
        String preview_url = mp3Files[i].path;
        for (var img in listImg) {
          var imgName = img['name'];
          if (imgName != null &&
              imgName.substring(0, imgName.length - 4) ==
                  name.substring(0, name.length - 4)) {
            var imgPath = img['path'];
            if (imgPath != null) {
              String image = imgPath;
              Track newTrack = Track(name, preview_url, image);
              list.add(newTrack);
              break;
            }
          }
        }
      }
      return list;
    } else {
      return [];
    }
  }

  TrackManager() {
    _dataRecommendTrack = getRecommendTrack();
    _dataLocal = getPlaylistFromFolder();
    _dataPlaylists = getPlaylistTracks();
    getTracks();
  }

  Future<List<Track>> get dataFuture => _dataRecommendTrack;

  List<Track> get tracks => _tracks;

  AudioPlayer get audioPlayer => _audioPlayer;

  bool get isPlaying => _isPlaying;

  int get currentTrack => _currentTrack;

  bool get isLoop => _isLoop;

  double get volume => _volume;

  ValueNotifier<Duration> get positionNotifier => _positionNotifier;

  ValueNotifier<bool> get isLoading => _isLoading;

  Duration get duration => _duration;

  Future<List<Track>> get dataLocal => _dataLocal;

  String get localAudio => _localAudio;

  bool get isSlected => _isSlected;

  Future<List<Track>> get dataPlaylists => _dataPlaylists;

  set isSlected(bool value) {
    _isSlected = value;
  }

  set localAudio(String value) {
    _localAudio = value;
  }

  set isPlaying(bool value) {
    _isPlaying = value;
  }

  set isLoop(bool value) {
    _isLoop = value;
  }

  set currentTrack(int value) {
    _currentTrack = value;
  }

  set volume(double value) {
    _volume = value;
  }

  set dataLocal(Future<List<Track>> value) {
    _dataLocal = value;
  }

  void listen() {
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _positionNotifier.value = newPosition;
    });
    _audioPlayer.onDurationChanged.listen((event) {
      _duration = event;
    });
    // _audioPlayer.onPlayerStateChanged.listen((state) async {
    //   if (state == PlayerState.completed) {
    //     _isCompleted.value = true;
    //     positionNotifier.value = Duration.zero;
    //       await playOrpause(_currentTrack + 1);
    //     }
    // });
  }

  void getTracks() async {
    _tracks = await _dataRecommendTrack;
    _download = await _dataLocal;
    _playlists = await _dataPlaylists;
  }

  void setPlay() {
    _audioPlayer.setVolume(_volume);
    if (_isLoop) {
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
    } else {
      _audioPlayer.setReleaseMode(ReleaseMode.release);
    }
  }

  void seek(Duration position) {
    if (position != _duration) {
      _audioPlayer.seek(position);
    }
  }

  Future<void> playOrpause(int id) async {
    print("So luong bai hattttttttttt ${tracks.length}");
    print("Bai hat hien taiiiiiiiiiiii $_currentTrack");

    if (manager.localAudio == "recommendation") {
      if (id >= 0 && id < tracks.length) {
        String standardName =
            tracks[id].name.replaceAll(RegExp(r'[^\w\-_\.]'), '_');
        standardName = standardName.replaceAll(RegExp(r'\.{2,}'), '.');
        if (standardName.startsWith('.')) {
          standardName = standardName.substring(1);
        }
        if (standardName.endsWith('.')) {
          standardName = standardName.substring(0, standardName.length - 1);
        }
        bool isDownloaded = await findTrackInDevice(standardName);
        print("ooooooooooooooooooooooooooooo$isDownloaded");
        if (_isPlaying) {
          if (isDownloaded) {
            _isLoading.value = false;
            await _audioPlayer.play(DeviceFileSource(
                "storage/emulated/0/Android/data/com.example.ui_music_app/files/${standardName}.mp3"));
            _currentTrack = id;
          } else {
            _isLoading.value = true;
            Source source = UrlSource(tracks[id].preview_url);
            positionNotifier.value = Duration.zero;
            await _audioPlayer.setSource(source);
            await _audioPlayer.play(source);
            if (_audioPlayer.state == PlayerState.playing) {
              _currentTrack = id;
              _isLoading.value = false;
            }
          }
        } else {
          _audioPlayer.pause();
          _currentTrack = id;
        }
      } else {
        print("Đã phát hết danh sách");
      }
    } else if (manager.localAudio == "download") {
      if (id >= 0 && id < _download.length) {
        print(_download[id].preview_url);
        if (_isPlaying) {
          _isLoading.value = false;
          await _audioPlayer.play(DeviceFileSource(_download[id].preview_url));
          _currentTrack = id;
        } else {
          _audioPlayer.pause();
          _currentTrack = id;
        }
      } else {
        print("Đã phát hết danh sách");
      }
    } else if (manager.localAudio == "popular") {
      if (id >= 0 && id < _playlists.length) {
        String standardName =
            _playlists[id].name.replaceAll(RegExp(r'[^\w\-_\.]'), '_');
        standardName = standardName.replaceAll(RegExp(r'\.{2,}'), '.');
        if (standardName.startsWith('.')) {
          standardName = standardName.substring(1);
        }
        if (standardName.endsWith('.')) {
          standardName = standardName.substring(0, standardName.length - 1);
        }
        bool isDownloaded = await findTrackInDevice(standardName);
        print("ooooooooooooooooooooooooooooo$isDownloaded");
        if (_isPlaying) {
          if (isDownloaded) {
            _isLoading.value = false;
            await _audioPlayer.play(DeviceFileSource(
                "storage/emulated/0/Android/data/com.example.ui_music_app/files/${standardName}.mp3"));
            _currentTrack = id;
          } else {
            _isLoading.value = true;
            Source source = UrlSource(_playlists[id].preview_url);
            positionNotifier.value = Duration.zero;
            await _audioPlayer.setSource(source);
            await _audioPlayer.play(source);
            if (_audioPlayer.state == PlayerState.playing) {
              _currentTrack = id;
              _isLoading.value = false;
            }
          }
        } else {
          _audioPlayer.pause();
          _currentTrack = id;
        }
      } else {
        print("Đã phát hết danh sách");
      }
    }
  }

  Future<bool> findTrackInDevice(String trackName) async {
    Directory directory = Directory(
        '/storage/emulated/0/Android/data/com.example.ui_music_app/files');
    if (!await directory.exists()) {
      return false;
    } else {
      List<FileSystemEntity> files = await directory.list().toList();
      List<File> mp3Files = files
          .whereType<File>()
          .where((file) => file.path.endsWith('.mp3'))
          .toList();
      List<File> matchingFiles =
          mp3Files.where((file) => file.path.contains(trackName)).toList();
      return matchingFiles.isNotEmpty;
    }
  }

  Future downLoadFile(String mp3Url, String name, String imgUrl) async {
    String standardName = name.replaceAll(RegExp(r'[^\w\-_\.]'), '_');
    standardName = standardName.replaceAll(RegExp(r'\.{2,}'), '.');
    if (standardName.startsWith('.')) {
      standardName = standardName.substring(1);
    }
    if (standardName.endsWith('.')) {
      standardName = standardName.substring(0, standardName.length - 1);
    }
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();
      final taskId = await FlutterDownloader.enqueue(
        url: mp3Url,
        savedDir: baseStorage!.path,
        fileName: '$standardName.mp3',
        showNotification: true,
        openFileFromNotification: true,
      );
      final imageTaskId = await FlutterDownloader.enqueue(
        url: imgUrl,
        savedDir: baseStorage.path,
        fileName: '$standardName.png',
        showNotification: true,
        openFileFromNotification: true,
      );
    }
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  Future<List<Track>> findTrack(String name) async {
    List<Track> result = [];
    tracks.forEach((element) {
      if (element.name.toLowerCase().contains(name)) {
        result.add(element);
      }
    });
    // _download.forEach((element) {
    //   if(element.name.contains(name)){
    //     result.add(element);
    //   }
    // });
    _playlists.forEach((element) {
      if (element.name.toLowerCase().contains(name)) {
        result.add(element);
      }
    });
    return result;
  }

  String findTrackLocation(String name) {
    String rs = "";
    tracks.forEach((element) {
      if (element.name.toLowerCase() == name.toLowerCase()) {
        rs = "recommendation";
        currentTrack = tracks.indexWhere((element) => element.name.toLowerCase() == name.toLowerCase());
      }
    });
    _playlists.forEach((element) {
      if (element.name.toLowerCase() == name.toLowerCase()) {
        rs = "popular";
        currentTrack = tracks.indexWhere((element) => element.name.toLowerCase() == name.toLowerCase());
      }
    });
    return rs;
  }
}
