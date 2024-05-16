import 'dart:convert';
import './models/Track.dart';
import './home.dart';
import 'package:flutter/material.dart';
import './player.dart';
import 'package:http/http.dart' as http;

Future<List<Track>> getPlaylistTracks() async {
  String id = '37i9dQZF1DX4Wsb4d7NKfP';
  String offset = '0';
  String limit = '100';
  List<Track> listTrack = [];
  final response = await http.get(
      Uri.parse(
          "https://spotify23.p.rapidapi.com/playlist_tracks/?id=$id&offset=$offset&limit=$limit"),
      headers: {
        'X-RapidAPI-Key': 'efa54cf780msh342b557c7a552e0p1ff86bjsnae99b46c9498',
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

Future<List<Track>> getTrackRecommendations() async {
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
        'X-RapidAPI-Key': 'efa54cf780msh342b557c7a552e0p1ff86bjsnae99b46c9498',
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

class Gallery extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GalleryState();
  }
}

class GalleryState extends State<Gallery> {
  late final Future<List<Track>> listTrackFuture;

  late final Future<List<Track>> listTrackRecommendationFuture;

  @override
  void initState() {
    super.initState();
    listTrackFuture = getPlaylistTracks();
    listTrackRecommendationFuture = getTrackRecommendations();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Gallery"),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                "assets/images/img1.png",
                height: 200,
                fit: BoxFit.fitWidth,
              ),
              const Positioned(
                top: 100,
                child: Text(
                  "A.L.O.N.E",
                  style: TextStyle(fontSize: 36, color: Colors.white),
                ),
              ),
              Positioned(
                top: 135,
                left: 22,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {},
                  child: const Text(
                    'Theo dõi',
                    style: TextStyle(
                        fontSize: 16, fontFamily: "Inter", color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          Row(children: [
            const Text(
              "Discography",
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            Container(
              margin: const EdgeInsets.only(left: 200.0),
              child: const Text(
                "See all",
                style: TextStyle(color: Colors.yellow, fontSize: 16),
              ),
            )
          ]),
          FutureBuilder(
              future: listTrackFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<Track> data = snapshot.data!;
                  return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (int i = 0; i < data.length; i++)
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Player(),
                                        settings: RouteSettings(arguments: data[i])));
                              },
                              child: Column(
                                children: [
                                  FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/img9.png',
                                    image: "${data[i].image}",
                                    width: 100,
                                  ),
                                  Text(
                                    "${data[i].name}",
                                    style: TextStyle(
                                      fontSize: 8,
                                    ),
                                  ),

                                ],
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
              margin: const EdgeInsets.only(left: 190.0),
              child: const Text(
                "See all",
                style: TextStyle(color: Colors.yellow, fontSize: 16),
              ),
            )
          ]),
          FutureBuilder(
              future: listTrackRecommendationFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<Track> data = snapshot.data!;
                  return Expanded(
                      child: ListView(
                    children: [
                      for (int i = 0; i < data.length; i++)
                        Row(
                          children: [
                            FadeInImage.assetNetwork(
                              placeholder: 'assets/images/img8.png',
                              image: "${data[i].image}",
                              width: 100,
                            ),
                            Expanded(child:
                            Text(
                              "${data[i].name}",
                              softWrap: true,
                            ),)
                          ],
                        ),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Home()));
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
