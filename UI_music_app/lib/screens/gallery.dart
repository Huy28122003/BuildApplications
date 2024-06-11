import 'dart:async';
import 'package:ui_music_app/models/TrackManager.dart';
import 'package:ui_music_app/screens/search.dart';
import 'package:ui_music_app/widgets/box.dart';
import 'package:ui_music_app/widgets/verticalList.dart';
import '../models/Track.dart';
import './home.dart';
import 'package:flutter/material.dart';
import 'player.dart';
import 'package:marquee/marquee.dart';

TrackManager manager = TrackManager();

class Gallery extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GalleryState();
  }
}

class GalleryState extends State<Gallery> {
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 9) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text("G a l l e r y"),
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 220,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Stack(
                          children: [
                            NeuBox(
                              child: SizedBox(
                                width: 250,
                                height: 200,
                                child: Image.asset(
                                  "assets/images/img${index + 1}.png",
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 130,left: 20),
                              child: const Text(
                                "A.L.O.N.E",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 160,left: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {},
                                child: const Text(
                                  'Theo dõi',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Inter",
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Row(children: [
                  const Text(
                    "Discography",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 190.0),
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VerticalList(
                                      name: "Discography",
                                      data: manager.dataFuture,
                                      location: 'recommendation')),
                            );
                          },
                          child: const Text("See all",
                              style: TextStyle(
                                  color: Colors.yellow, fontSize: 16))))
                ]),
                FutureBuilder(
                    future: manager.dataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final List<Track> data = snapshot.data!;
                        return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (int i = 0; i < data.length; i++)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        manager.currentTrack = i;
                                        manager.localAudio = "recommendation";
                                        setState(() {
                                          manager.isSlected = true;
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Player()),
                                        );
                                      },
                                      child: SizedBox(
                                        width: 80,
                                        // Giới hạn chiều rộng của widget
                                        child: Column(
                                          children: [
                                            FadeInImage.assetNetwork(
                                              placeholder:
                                                  'assets/images/img9.png',
                                              image: "${data[i].image}",
                                              width: 80,
                                            ),
                                            SizedBox(
                                              height: 20,
                                              // Giới hạn chiều cao của Text widget
                                              child: Marquee(
                                                text: "${data[i].name}",
                                                style: TextStyle(fontSize: 8),
                                                scrollAxis: Axis.horizontal,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                blankSpace: 20.0,
                                                velocity: 10.0,
                                                pauseAfterRound:
                                                    Duration(seconds: 1),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ));
                      } else if (snapshot.hasError) {
                        return Text('$snapshot.error');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
                Row(children: [
                  const Text(
                    "Popular singles",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 170.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerticalList(
                                    name: "Popular singles",
                                    data: manager.dataPlaylists,
                                    location: 'popular')),
                          );
                        },
                        child: const Text(
                          "See all",
                          style: TextStyle(color: Colors.yellow, fontSize: 16),
                        ),
                      ))
                ]),
                FutureBuilder(
                    future: manager.dataPlaylists,
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
                                  manager.currentTrack = i;
                                  manager.localAudio = "popular";
                                  setState(() {
                                    manager.isSlected = true;
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Player()),
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
            ])));
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
