import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:ui_music_app/models/TrackManager.dart';
import 'package:ui_music_app/widgets/box.dart';
import '../models/Track.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'gallery.dart';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PlayerState();
  }
}

class _PlayerState extends State<Player> {
  bool isCalled = false;
  bool showSetVolume = false;
  final ReceivePort _port = ReceivePort();
  bool gotId = false;
  late int id;

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      int status = data[1];
      int progress = data[2];
      setState(() {});
    });
    FlutterDownloader.registerCallback(TrackManager.downloadCallback);

    // Thêm listener trạng thái trình phát vào đây
    manager.audioPlayer.onPlayerStateChanged.listen((state) async {
      if (state == PlayerState.completed) {
        manager.positionNotifier.value = Duration.zero;
        await manager.playOrpause(manager.currentTrack + 1);
        if (mounted) {
          setState(() {
            isCalled = false;
          });
        }
      }
    });

    manager.listen();
    manager.playOrpause(manager.currentTrack);
  }

  @override
  void dispose() {
    super.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  Future getData(String localSend) {
    switch (localSend) {
      case "recommendation":
        return manager.dataFuture;
      case "download":
        return manager.dataLocal;
      case "popular":
        return manager.dataPlaylists;
      default:
        return manager.dataFuture;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
            future: getData(manager.localAudio),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<Track> data = snapshot.data!;
                return Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 25),
                        child: NeuBox(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: (manager.localAudio != "download")
                                    ? Image.network(
                                        data[manager.currentTrack].image,
                                        height: 250,
                                        width: 250,
                                        fit: BoxFit.contain,
                                      )
                                    : Image.file(
                                        File(data[manager.currentTrack].image),
                                        height: 250,
                                        width: 250,
                                        fit: BoxFit.contain,
                                      )))),
                    SizedBox(
                      height: 40.0,
                      child: Marquee(
                        text: data[manager.currentTrack].name,
                        style:
                            const TextStyle(fontSize: 24, color: Colors.amber),
                        velocity: 10.0,
                        blankSpace: 20.0,
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        pauseAfterRound: const Duration(seconds: 1),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 40),
                          child: IconButton(
                            icon: const Icon(Icons.download),
                            onPressed: () {
                              manager.downLoadFile(
                                  data[manager.currentTrack].preview_url,
                                  data[manager.currentTrack].name,
                                  data[manager.currentTrack].image);
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 90),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.yellow,
                          ),
                        ),
                        ValueListenableBuilder<Duration>(
                          valueListenable: manager.positionNotifier,
                          builder: (context, position, child) {
                            return Container(
                                margin: const EdgeInsets.only(left: 70),
                                child: Text(
                                    "${manager.duration.inSeconds.toDouble() - position.inSeconds.toDouble()}s"));
                          },
                        ),
                      ],
                    ),
                    ValueListenableBuilder<Duration>(
                      valueListenable: manager.positionNotifier,
                      builder: (context, position, child) {
                        return Slider(
                          value: position.inSeconds.toDouble(),
                          onChanged: (newValue) {
                            Duration newPosition =
                                Duration(seconds: newValue.toInt());
                            manager.seek(newPosition);
                          },
                          min: 0,
                          max: manager.duration.inSeconds.toDouble(),
                        );
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: IconButton(
                            icon: _setIconLoop(),
                            onPressed: () {
                              setState(() {
                                manager.isLoop = !manager.isLoop;
                                manager.setPlay();
                              });
                            },
                          ),
                        ),
                        Expanded(
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (manager.currentTrack != 0) {
                                      manager.currentTrack--;
                                      manager.playOrpause(manager.currentTrack);
                                      isCalled = false;
                                    } else {
                                      print("This is the first track");
                                    }
                                  });
                                },
                                icon: const Icon(
                                  Icons.skip_previous,
                                  size: 30,
                                ))),
                        ValueListenableBuilder<bool>(
                          valueListenable: manager.isLoading,
                          builder: (context, isLoading, child) {
                            return isLoading
                                ? const CircularProgressIndicator()
                                : Expanded(
                                    child: IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            manager.isPlaying =
                                                !manager.isPlaying;
                                          });
                                          manager.playOrpause(
                                              manager.currentTrack);
                                        },
                                        icon: _setIconPlaying()));
                          },
                        ),
                        Expanded(
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (manager.currentTrack !=
                                        data.length - 1) {
                                      manager.currentTrack++;
                                      manager.playOrpause(manager.currentTrack);
                                      isCalled = false;
                                    } else {
                                      print("This is the last track");
                                    }
                                  });
                                },
                                icon: const Icon(
                                  Icons.skip_next,
                                  size: 30,
                                ))),
                        Expanded(
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showSetVolume = !showSetVolume;
                                  });
                                },
                                icon: const Icon(Icons.volume_up)))
                      ],
                    ),
                    if (showSetVolume)
                      SizedBox(
                        width: 200,
                        child: Slider(
                          value: manager.volume,
                          onChanged: (value) {
                            setState(() {
                              manager.volume = value;
                            });
                            manager.setPlay();
                          },
                          activeColor: Colors.blue,
                          inactiveColor: Colors.grey,
                        ),
                      )
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('$snapshot.error');
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }

  Icon _setIconPlaying() {
    if (manager.isPlaying) {
      return const Icon(
        Icons.pause,
        size: 40,
      );
    } else {
      return const Icon(
        Icons.play_arrow,
        size: 40,
      );
    }
  }

  Icon _setIconLoop() {
    if (manager.isLoop) {
      return const Icon(Icons.repeat_one_rounded);
    } else {
      return const Icon(Icons.repeat);
    }
  }
}

/*
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:ui_music_app/models/TrackManager.dart';
import 'models/Track.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'gallery.dart';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PlayerState();
  }
}

class _PlayerState extends State<Player> {
  bool isCalled = false;
  bool showSetVolume = false;
  final ReceivePort _port = ReceivePort();
  bool gotId = false;
  late int id;

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      int status = data[1];
      int progress = data[2];
      setState(() {});
    });
    FlutterDownloader.registerCallback(TrackManager.downloadCallback);

    // Thêm listener trạng thái trình phát vào đây
    manager.audioPlayer.onPlayerStateChanged.listen((state) async {
      if (state == PlayerState.completed) {
        manager.positionNotifier.value = Duration.zero;
        await manager.playOrpause(manager.currentTrack + 1);
        if (mounted) {
          setState(() {
            isCalled = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  void play() async {
    await manager.playOrpause(manager.currentTrack);
    manager.listen();
  }

  @override
  Widget build(BuildContext context) {
    if (gotId == false) {
      id = ModalRoute.of(context)!.settings.arguments as int;
      manager.currentTrack = id;
      gotId = true;
    }
    if (isCalled == false) {
      manager.playOrpause(manager.currentTrack);
      manager.listen();
      isCalled = true;
    }

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
            future: manager.dataFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<Track> data = snapshot.data!;
                return Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 25),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            data[manager.currentTrack].image,
                            height: 250,
                            width: 250,
                            fit: BoxFit.contain,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        data[manager.currentTrack].name,
                        style:
                        const TextStyle(fontSize: 24, color: Colors.amber),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 40),
                          child: IconButton(
                            icon: const Icon(Icons.download),
                            onPressed: () {
                              manager.downLoadFile(
                                  data[manager.currentTrack].preview_url,
                                  data[id].name);
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 90),
                          child: const Icon(
                            Icons.ios_share,
                            color: Colors.yellow,
                          ),
                        ),
                        ValueListenableBuilder<Duration>(
                          valueListenable: manager.positionNotifier,
                          builder: (context, position, child) {
                            return Container(
                                margin: const EdgeInsets.only(left: 70),
                                child: Text(
                                    "${manager.duration.inSeconds.toDouble() - position.inSeconds.toDouble()}s"));
                          },
                        ),
                      ],
                    ),
                    ValueListenableBuilder<Duration>(
                      valueListenable: manager.positionNotifier,
                      builder: (context, position, child) {
                        return Slider(
                          value: position.inSeconds.toDouble(),
                          onChanged: (newValue) {
                            Duration newPosition =
                            Duration(seconds: newValue.toInt());
                            manager.seek(newPosition);
                          },
                          min: 0,
                          max: manager.duration.inSeconds.toDouble(),
                        );
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: IconButton(
                            icon: _setIconLoop(),
                            onPressed: () {
                              setState(() {
                                manager.isLoop = !manager.isLoop;
                                manager.setPlay();
                              });
                            },
                          ),
                        ),
                        Expanded(
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    // manager.playOrpause(manager.currentTrack - 1);
                                    manager.currentTrack--;
                                    isCalled = false;
                                  });
                                },
                                icon: const Icon(
                                  Icons.skip_previous,
                                  size: 30,
                                ))),
                        ValueListenableBuilder<bool>(
                          valueListenable: manager.isLoading,
                          builder: (context, isLoading, child) {
                            return isLoading
                                ? const CircularProgressIndicator()
                                : Expanded(
                                child: IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        manager.isPlaying =
                                        !manager.isPlaying;
                                      });
                                      manager.playOrpause(
                                          manager.currentTrack);
                                    },
                                    icon: _setIconPlaying()));
                          },
                        ),
                        Expanded(
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    // manager.playOrpause(manager.currentTrack + 1);
                                    manager.currentTrack++;
                                    isCalled = false;
                                  });
                                },
                                icon: const Icon(
                                  Icons.skip_next,
                                  size: 30,
                                ))),
                        Expanded(
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showSetVolume = !showSetVolume;
                                  });
                                },
                                icon: const Icon(Icons.volume_up)))
                      ],
                    ),
                    if (showSetVolume)
                      SizedBox(
                        width: 200,
                        child: Slider(
                          value: manager.volume,
                          onChanged: (value) {
                            setState(() {
                              manager.volume = value;
                            });
                            manager.setPlay();
                          },
                          activeColor: Colors.blue,
                          inactiveColor: Colors.grey,
                        ),
                      )
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('$snapshot.error');
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }

  Icon _setIconPlaying() {
    if (manager.isPlaying) {
      return const Icon(
        Icons.pause,
        size: 40,
      );
    } else {
      return const Icon(
        Icons.play_arrow,
        size: 40,
      );
    }
  }

  Icon _setIconLoop() {
    if (manager.isLoop) {
      return const Icon(Icons.repeat_one_rounded);
    } else {
      return const Icon(Icons.repeat);
    }
  }
}

 */
