import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ui_music_app/screens/search.dart';
import 'screens/home.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true,
      ignoreSsl: true
  );
  // github nang cao
  runApp(MaterialApp(
      theme: ThemeData(brightness: Brightness.light), home: const Home()));
}

// hello
// day la code tu remote new
// thuc hien lam viec voi git nang cao

// giai quyet conflict code
