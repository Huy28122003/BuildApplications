import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  // runApp(MyStateFul(true));
  //  runApp(MyGridView());
  //  runApp(MyListView());
  // runApp(MyStack());
  // runApp(const MyApp());
  // runApp(MyLayout());
  runApp(DiagramLayout());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: "First App",
      home: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.amberAccent,
              title: const Text(
                "First App",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 30,
                    color: Colors.deepPurpleAccent),
              ),
            ),
            body: const Center(
              child: Column(
                children: [
                  Text(
                    "Tất cả các thành phần liên quan đến giao diện người dùng"
                    " đều là các widget từ những đơn widget như Text, Button ..."
                    "đến những group widget như row, column, ...",
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textScaler: TextScaler.linear(1.5),
                    style: TextStyle(
                      color: Colors.indigoAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic,
                      fontFamily: "ThuPhap",
                      wordSpacing: 5,
                      // Khoảng cách giữa các từ
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  SizedBox(
                    height: 210,
                    child: Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text(
                              '1625 Main Street',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            subtitle: const Text('My City, CA 99984'),
                            leading: Icon(
                              Icons.restaurant_menu,
                              color: Colors.blue,
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            title: const Text(
                              '(408) 555-1212',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            leading: Icon(
                              Icons.contact_phone,
                              color: Colors.blue,
                            ),
                          ),
                          ListTile(
                            title: const Text('costa@example.com'),
                            leading: Icon(
                              Icons.contact_mail,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
            // body: MyStateFul(false),
            ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyStateFul extends StatefulWidget {
  final bool check;
  MyStateFul(this.check);

  @override
  State<StatefulWidget> createState() {
    return MyState();
  }
}

class MyState extends State<MyStateFul> {
  late bool _check;

  @override
  void initState() {
    _check = widget.check;
  }

  @override
  Widget build(BuildContext context) {
    return _check
        ? MaterialApp(
            home: SafeArea(
              child: Scaffold(
                body: Center(
                    child: Column(
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          print("Text button is pressed");
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.indigoAccent,
                          backgroundColor: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          elevation: 20,
                          shadowColor: Colors.deepPurple.withOpacity(0.5),
                          side: const BorderSide(width: 5, color: Colors.green),
                        ),
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text(
                          "Text Button",
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        )),
                    Container(
                      margin: EdgeInsets.all(20),
                      color: Colors.black45,
                      padding: EdgeInsets.all(10),
                      child: ElevatedButton.icon(
                          onPressed: () {
                            print("Elevated Button is pressed");
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.amber,
                              padding: const EdgeInsets.all(10)),
                          icon: const Icon(
                            Icons.delete,
                            size: 20,
                            color: Colors.red,
                          ),
                          label: const Text(
                            "Elevated button",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          )),
                    ),
                    OutlinedButton.icon(
                        onPressed: () {
                          print("Outlined button is pressed");
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.amberAccent,
                        ),
                        icon: const Icon(
                          Icons.update,
                          size: 20,
                        ),
                        label: const Text(
                          "Outline button",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.asset('assets/images/pic1.png'),
                        ),
                        Expanded(
                          flex: 2,
                          child: Image.asset('assets/images/pic2.png'),
                        ),
                        Expanded(
                          child: Image.asset('assets/images/pic3.png'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.green[500]),
                        Icon(Icons.star, color: Colors.green[500]),
                        Icon(Icons.star, color: Colors.green[500]),
                        const Icon(Icons.star, color: Colors.black),
                        const Icon(Icons.star, color: Colors.black),
                      ],
                    ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 10, color: Colors.black38),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      margin: const EdgeInsets.all(4),
                      child: Image.asset('assets/images/img.png'),
                    ))
                  ],
                )),
              ),
            ),
          )
        : FloatingActionButton(onPressed: onClick);
  }

  void onClick() {
    setState(() {
      _check = true;
    });
  }
}

class MyGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.amberAccent,
                title: const Text(
                  "First App",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 30,
                      color: Colors.deepPurpleAccent),
                ),
              ),
              body: GridView.extent(
                  maxCrossAxisExtent: 150,
                  padding: const EdgeInsets.all(4),
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  children: _buildGridTileList(30)))),
    );
  }

  List<Container> _buildGridTileList(int count) => List.generate(
      count, (i) => Container(child: Image.asset('assets/images/img.png')));
}

class MyListView extends StatelessWidget {
  static const showGrid = true; // Set to false to show ListView

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter layout demo'),
        ),
        body: Center(child: showGrid ? _buildGrid() : _buildList()),
      ),
    );
  }

  // #docregion grid
  Widget _buildGrid() => GridView.extent(
      maxCrossAxisExtent: 150,
      padding: const EdgeInsets.all(4),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: _buildGridTileList(30));

  List<Container> _buildGridTileList(int count) => List.generate(
      count, (i) => Container(child: Image.asset('assets/images/pic1.png')));

  // #enddocregion grid

  // #docregion list
  Widget _buildList() {
    return ListView(
      children: [
        _tile('CineArts at the Empire', '85 W Portal Ave', Icons.theaters),
        _tile('The Castro Theater', '429 Castro St', Icons.theaters),
        _tile('Alamo Drafthouse Cinema', '2550 Mission St', Icons.theaters),
        _tile('Roxie Theater', '3117 16th St', Icons.theaters),
        _tile('United Artists Stonestown Twin', '501 Buckingham Way',
            Icons.theaters),
        _tile('AMC Metreon 16', '135 4th St #3000', Icons.theaters),
        const Divider(),
        _tile('K\'s Kitchen', '757 Monterey Blvd', Icons.restaurant),
        _tile('Emmy\'s Restaurant', '1923 Ocean Ave', Icons.restaurant),
        _tile('Chaiya Thai Restaurant', '272 Claremont Blvd', Icons.restaurant),
        _tile('La Ciccia', '291 30th St', Icons.restaurant),
      ],
    );
  }

  ListTile _tile(String title, String subtitle, IconData icon) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(subtitle),
      leading: Icon(
        icon,
        color: Colors.blue[500],
      ),
    );
  }
}

class MyStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
          child: Scaffold(
        body: Stack(
          alignment: const Alignment(0.6, 0.6),
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/pic2.png'),
              radius: 100,
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.black45,
              ),
              child: const Text(
                'Mia B',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class MyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Image.asset(
                'assets/images/img.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
              Row(
                children: [
                  const Column(
                    children: [
                      Text(
                        "My name is Quang Huy",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text("Thai Binh, Viet Nam"),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(100, 0, 0, 0),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.red,
                        ),
                        Text("20")
                      ],
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: const Row(
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        Icon(
                          Icons.call,
                          size: 20,
                          color: Colors.indigoAccent,
                        ),
                        Text("CALL")
                      ],
                    )),
                    Expanded(
                        child: Column(
                      children: [
                        Icon(
                          Icons.send,
                          size: 20,
                          color: Colors.indigoAccent,
                        ),
                        Text("ROUTE")
                      ],
                    )),
                    Expanded(
                        child: Column(
                      children: [
                        Icon(
                          Icons.share,
                          size: 20,
                          color: Colors.indigoAccent,
                        ),
                        Text("SHARE")
                      ],
                    ))
                  ],
                ),
              ),
              Text(
                "My name is Nguyen Quang Huy."
                "I'm tewnty year old. I come from Thai Binh."
                "I study at Thuy Loi University, Information Technology major"
                "Current, i am working at VNCert",
                style: TextStyle(
                  fontFamily: "Time New Roman",
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DiagramLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Flutter layout demo';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              ImageSection(
                image: 'assets/images/img.png',
              ),
              TitleSection(
                name: 'Nguyen Quang Huy',
                location: "Thai Binh, Viet Nam",
              ),
              ButtonSection(),
              TextSection(
                description:
                    'Lake Oeschinen lies at the foot of the Blüemlisalp in the '
                    'Bernese Alps. Situated 1,578 meters above sea level, it '
                    'is one of the larger Alpine Lakes. A gondola ride from '
                    'Kandersteg, followed by a half-hour walk through pastures '
                    'and pine forest, leads you to the lake, which warms to 20 '
                    'degrees Celsius in the summer. Activities enjoyed here '
                    'include rowing, and riding the summer toboggan run.',
              ),
            ],
          ),
        ),
        // #enddocregion addWidget
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({
    super.key,
    required this.name,
    required this.location,
  });

  final String name;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          /*3*/
          // #docregion Icon
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          // #enddocregion Icon
          const Text('41'),
        ],
      ),
    );
  }
}

class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).primaryColor;
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ButtonWithText(
            color: color,
            icon: Icons.call,
            label: 'CALL',
          ),
          ButtonWithText(
            color: color,
            icon: Icons.near_me,
            label: 'ROUTE',
          ),
          ButtonWithText(
            color: color,
            icon: Icons.share,
            label: 'SHARE',
          ),
        ],
      ),
    );
  }
}

class ButtonWithText extends StatelessWidget {
  const ButtonWithText({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
  });

  final Color color;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class TextSection extends StatelessWidget {
  const TextSection({
    super.key,
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Text(
        description,
        softWrap: true,
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  const ImageSection({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    // #docregion Image-asset
    return Image.asset(
      image,
      width: 600,
      height: 240,
      fit: BoxFit.cover,
    );
    // #enddocregion Image-asset
  }
}
