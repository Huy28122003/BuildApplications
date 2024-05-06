import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import './home.dart';

class Player extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlayerState();
  }
}

class _PlayerState extends State<Player> {
  final audioPlayer = AudioPlayer();

  Stream<PlayerState> get playerStateStream => audioPlayer.onPlayerStateChanged;
  bool isPlaying = false;
  bool isLoop = false;
  bool isVolume = true;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.playing) {
        isPlaying = true;
      } else {
        isPlaying = false;
      }
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }
  double calculateProgress() {
    if (duration.inSeconds == 0) {
      return 0.0;
    } else {
      return position.inSeconds / duration.inSeconds;
    }
  }
  @override
  Widget build(BuildContext context) {
    int sound = ModalRoute.of(context)!.settings.arguments as int;
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Image.asset(
            "assets/images/profile.png",
            width: double.infinity,
            height: 300,
            fit: BoxFit.fill,
          ),
          const Text(
            "Alone in the Abyss",
            style: TextStyle(fontSize: 24, color: Colors.amber),
          ),
          Text("Youlakou"),
          Container(
            margin: EdgeInsets.only(left: 300),
            child: const Icon(
              Icons.ios_share,
              color: Colors.yellow,
            ),
          ),
          Row(
            children: [
              Container(
                  margin: EdgeInsets.only(left: 20),
                  child: const Text("Dynamic warmup |")),
              Container(
                  margin: EdgeInsets.only(left: 160),
                  child: Text(duration.inMinutes.toString() + " min"))
            ],
          ),
          Slider(
            value: position.inSeconds.toDouble(),
            min: 0.0,
            max: duration.inSeconds.toDouble(),
            onChanged: (value) {
              setState(() {
                position = Duration(seconds: value.toInt());
                audioPlayer.seek(position);
              });
            },
          ),
          Row(
            children: [
              Expanded(child: Icon(Icons.skip_previous_rounded)),
              Expanded(
                  child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoop = !isLoop;
                  });
                  if (isLoop) {
                    audioPlayer.setReleaseMode(ReleaseMode.loop);
                  } else {
                    audioPlayer.setReleaseMode(ReleaseMode.release);
                  }
                },
                child: Icon(isLoop ? Icons.repeat_one_rounded : Icons.repeat),
              )),
              Expanded(
                  child: ElevatedButton(
                onPressed: () {
                  if (sound == 2) {
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                    if (isPlaying) {
                      audioPlayer.play(AssetSource('musics/Tranh_Duyen.mp3'));
                    } else {
                      audioPlayer.pause();
                    }
                  } else if (sound == 3) {
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                    if (isPlaying) {
                      audioPlayer
                          .play(AssetSource('musics/Noi_Nay_Co_Anh.mp3'));
                    } else {
                      audioPlayer.pause();
                    }
                  } else {
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                    if (isPlaying) {
                      audioPlayer.play(AssetSource(
                          'musics/Chung_Ta_Khong_Thuoc_Ve_Nhau.mp3'));
                    } else {
                      audioPlayer.pause();
                    }
                  }
                },
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 50,
                ),
              )),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          sound++;
                          audioPlayer.play(AssetSource(
                              'musics/Chung_Ta_Khong_Thuoc_Ve_Nhau.mp3'));
                        });
                      },
                      child: Icon(Icons.skip_next))),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isVolume = !isVolume;
                        });
                        if (isVolume == false) {
                          audioPlayer.setVolume(0.0);
                        } else {
                          audioPlayer.setVolume(1.0);
                        }
                      },
                      child: isVolume
                          ? Icon(Icons.volume_down_rounded)
                          : Icon(Icons.volume_off_rounded)))
            ],
          )
        ],
      ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                label: 'Favorite',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.delete_outline_outlined),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  print("Favorite item tapped!");
                  break;
                case 1:
                  print('Search item tapped!');
                  break;
                case 2:
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>Home()));
                  break;
                case 3:
                  print('Cart item tapped!');
                  break;
                case 4:
                  print('Profile item tapped!');
                  break;
              }
            },
          ),
    ));
  }
}
