import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ui_music_app/screens/gallery.dart';

import '../models/Track.dart';
import '../screens/player.dart';

class VerticalList extends StatelessWidget {
  final String name;
  final Future<List<Track>> data;
  final String location;

  const VerticalList(
      {super.key,
      required this.name,
      required this.data,
      required this.location});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: FutureBuilder(
                    future: data,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final List<Track> value = snapshot.data!;
                        return ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                child: Row(
                                  children: [
                                    (location == "download")
                                        ? Image.file(File(value[index].image))
                                        : FadeInImage.assetNetwork(
                                      placeholder: 'assets/images/img9.png',
                                      image: "${value[index].image}",
                                      width: 80,
                                    ),
                                    (location == "download")?
                                    Expanded(
                                      child: Text(
                                        value[index]
                                            .name
                                            .substring(0, value[index].name.length - 4),
                                        softWrap: true,
                                      ),
                                    ):Expanded(
                                      child: Text(
                                        value[index]
                                            .name,
                                        softWrap: true,
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  manager.currentTrack = index;
                                  manager.localAudio = location;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Player(),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('$snapshot.error'));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )),
            ],
          ),
    ));
  }
}
