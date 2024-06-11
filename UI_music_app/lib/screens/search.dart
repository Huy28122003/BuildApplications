import 'package:flutter/material.dart';
import 'package:ui_music_app/screens/gallery.dart';
import 'package:ui_music_app/screens/player.dart';
import '../models/Track.dart';
import '../widgets/verticalList.dart';
import 'home.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late TextEditingController _controller;
  late Future<List<Track>> tracks;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController();
    tracks = manager.findTrack("");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("S e a r c h"),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Nhập tên bài hát',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.blue)),
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
              onChanged: (value) {
                setState(() {
                  tracks = manager.findTrack(value);
                });
              },
            ),
          ),
          FutureBuilder(
              future: tracks,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<Track> data = snapshot.data!;
                  return Expanded(
                      child: ListView(
                    children: [
                      for (int i = 0; i < data.length; i++)
                        GestureDetector(
                          child: Row(
                            children: [
                              FadeInImage.assetNetwork(
                                placeholder: 'assets/images/img8.png',
                                image: data[i].image,
                                width: 100,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/img8.png',
                                    // Đường dẫn đến hình ảnh thay thế trong assets
                                    width: 100,
                                  );
                                },
                              ),
                              Expanded(
                                child: Text(
                                  data[i].name,
                                  softWrap: true,
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            manager.localAudio =
                                manager.findTrackLocation(data[i].name);
                            setState(() {
                              manager.isSlected = true;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Player()),
                            );
                          },
                        )
                    ],
                  ));
                } else if (snapshot.hasError) {
                  return Text('$snapshot.error');
                } else {
                  return const CircularProgressIndicator();
                }
              })
        ],
      ),
            bottomNavigationBar:
            Column(mainAxisSize: MainAxisSize.min, children: [
              if (manager.isSlected == true)
                Container(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Player()));
                                },
                                child: Text(
                                  manager.tracks[manager.currentTrack].name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                          ValueListenableBuilder<bool>(
                              valueListenable: manager.isLoading,
                              builder: (context, isLoading, child) {
                                if (!isLoading) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    setState(() {});
                                  });
                                }
                                return IconButton(
                                    onPressed: () {
                                      setState(() {
                                        manager.isPlaying = !manager.isPlaying;
                                      });
                                      manager.playOrpause(manager.currentTrack);
                                    },
                                    icon: (isLoading == false)
                                        ? _setIconPlaying()
                                        : const CircularProgressIndicator());
                              })
                        ],
                      ),
                      ValueListenableBuilder<Duration>(
                          valueListenable: manager.positionNotifier,
                          builder: (context, position, child) {
                            return LinearProgressIndicator(
                              value: (manager.duration != Duration.zero)
                                  ? position.inSeconds.toDouble() /
                                  manager.duration.inSeconds.toDouble()
                                  : 0.0,
                            );
                          }),
                    ],
                  ),
                ),
              BottomNavigationBar(
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
                    label: 'Hom',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.library_add_check),
                    label: 'Downloaded',
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Search()));
                      break;
                    case 2:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Home()));
                      break;
                    case 3:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VerticalList(
                                  name: "Download",
                                  data: manager.dataLocal,
                                  location: "download")));
                      break;
                    case 4:
                      print('Profile item tapped!');
                      break;
                  }
                },
              ),
            ])
    ));
  }
  Icon _setIconPlaying() {
    if (manager.isPlaying) {
      return const Icon(
        Icons.pause,
        size: 30,
      );
    } else {
      return const Icon(
        Icons.play_arrow,
        size: 30,
      );
    }
  }
}
