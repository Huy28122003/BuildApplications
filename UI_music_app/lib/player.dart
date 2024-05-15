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
  late AudioPlayer audioPlayer;
  bool isPlaying = true;
  bool isVolume = true;
  bool isLoop = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.setReleaseMode(ReleaseMode.stop);
  }


  double _setValueSlider(){
    if(duration == Duration.zero){
      return 0.0;
    }
    else{
      return position.inSeconds/duration.inSeconds;
    }
  }

  @override
  Widget build(BuildContext context) {
    String url = ModalRoute
        .of(context)!
        .settings
        .arguments as String;
    Source source = UrlSource(url);
    if(isVolume ==false){
      audioPlayer.setVolume(0.0);
    }
    else{
      audioPlayer.setVolume(1.0);
    }
    if (isPlaying) {
      audioPlayer.play(source);
    }
    else {
      audioPlayer.pause();
    }

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
                      child: Text("${duration.inMinutes} min"))
                ],
              ),
              Slider(
                value: _setValueSlider(),
                onChanged: (value) {
                  setState(() {
                    position = Duration(seconds: value.toInt());
                    audioPlayer.seek(position);
                  });
                },
              ),
              Row(
                children: [
                  Expanded(child: IconButton(
                      onPressed: (){

                      },
                      icon: _setIconLoop())),
                  Expanded(child: IconButton(
                      onPressed: (){

                      },
                      icon: Icon(Icons.skip_previous, size: 30,))),
                  Expanded(child: IconButton(
                      onPressed: () {
                        setState(() {
                          isPlaying = !isPlaying;
                        });
                      },
                      icon: _setIconPlay())),
                  Expanded(child: IconButton(
                      onPressed: (){

                      },
                      icon: Icon(Icons.skip_next, size: 30,))),
                  Expanded(child: IconButton(
                      onPressed: (){
                        setState(() {
                          isVolume = !isVolume;
                        });
                      },
                      icon: _setIconVolume()))
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
                      MaterialPageRoute(builder: (context) => Home()));
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

  Icon _setIconPlay() {
    if (isPlaying) {
      return Icon(Icons.pause, size: 40,);
    }
    else {
      return Icon(Icons.play_arrow, size: 40,);
    }
  }
  Icon _setIconVolume(){
    if(isVolume == true){
      return Icon(Icons.volume_up,size: 25,);
    }
    else{
      return Icon(Icons.volume_off,size: 25,);
    }
  }

  Icon _setIconLoop(){
    if(isLoop){
      return Icon(Icons.repeat_one_rounded);
    }
    else{
      return Icon(Icons.repeat);
    }
  }
}
