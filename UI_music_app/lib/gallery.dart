import './home.dart';
import 'package:flutter/material.dart';
import './player.dart';

class Gallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
                Container(
                  child: const Text(
                    "Discography",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 200.0),
                  child: const Text(
                    "See all",
                    style: TextStyle(color: Colors.yellow, fontSize: 16),
                  ),
                )
              ]),
              SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for(int i=2;i<5;i++)
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => Player(),
                              settings: RouteSettings(
                                arguments: i
                              )
                            ));
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Image.asset("assets/images/img$i.png"),
                                Text("Alone"),
                                Text("2000"),
                              ],
                            ),
                          ),
                        ),
                    ],
                  )),
              Row(children: [
                Container(
                  child: const Text(
                    "Popular singles",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 190.0),
                  child: const Text(
                    "See all",
                    style: TextStyle(color: Colors.yellow, fontSize: 16),
                  ),
                )
              ]),
              Expanded(
                  child: ListView(
                    children: [
                      for(int i=5;i<7;i++)
                        Row(
                          children: [
                            Image.asset("assets/images/img$i.png"),
                            Column(
                              children: [Text("Attention $i"), Text("200$i")],
                            )
                          ],
                        ),
                    ],
                  ))
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