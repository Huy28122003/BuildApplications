import 'package:flutter/material.dart';
import 'package:ui_music_app/gallery.dart';
class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
         body: Column(
           children: [
             Stack(
               children: [
                 Image.asset(
                   "assets/images/img.png",
                   width: double.infinity,
                   fit: BoxFit.fitWidth,
                 ),
                 const Positioned(
                   top: 190,
                     left: 44,
                     child: Text(
                       "Dacing between \n"
                           "The shadow \n"
                           "Of rhythm",
                       style: TextStyle(
                         fontSize: 36
                       ),
                     ),
                 ),
               ],
             ),
             Container(
               margin: const EdgeInsets.only(top: 20),
               child: SizedBox(
                 width: 230,
                 child: ElevatedButton(
                   onPressed: () {
                     Navigator.push(context, MaterialPageRoute(
                         builder: (context) =>  Gallery()
                     ));
                   },
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.deepOrange,
                   ),
                   child: const Text(
                     "Get started",
                     style: TextStyle(
                       fontSize: 20,
                       color: Colors.black,
                     ),
                   ),
                 ),
               ),
             ),
             ElevatedButton(
                 onPressed: (){

                 },
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.black,
                   side: const BorderSide(
                     color: Colors.deepOrange,
                     width: 1
                   )
                 ),
                 child: const Text(
                   "Continue with Email",
                   style: TextStyle(
                     fontSize: 20,
                     color: Colors.deepOrange
                   ),
                 )
             ),
             Container(
               margin: const EdgeInsets.only(top: 20),
               child: const Text(
                 "by continuing you agree to terms \n"
                     "of services and  Privacy policy",
                 style: TextStyle(
                   color: Colors.grey
                 ),
               ),
             )
           ],
         ),
        )
    );
  }
}


