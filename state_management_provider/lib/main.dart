import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/Theme.dart';
import './models/BackGround.dart';
import './models/Counter.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CounterProvider()),
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => BackGroundProvider()),
    ],
    child: Home(),
  ));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // data là biến đại diện cho class MyProvider
    return Consumer3<ThemeProvider,BackGroundProvider,CounterProvider>(
        builder: (context,theme,backGr,counter,child){
          return MaterialApp(
            theme: ThemeData(
                brightness: theme.isDark ? Brightness.dark : Brightness.light
            ),
            home: Scaffold(
              appBar: AppBar(
                title: const Text("Home"),
                actions: [
                  Switch(
                      value: theme.isDark,
                      onChanged: (newValue){
                        theme.setBrightness(newValue);
                      }
                  )
                ],
              ),
              backgroundColor: backGr.color,
              drawer: Drawer(
                child: ListView(
                  children: [
                    const DrawerHeader(child: Text("Consumer")),
                    ListTile(
                      title: const Text("Change color"),
                      onTap: () {
                        backGr.changeColor();
                      },
                    ),
                    ListTile(
                      title: const Text("Change text"),
                      onTap: () {
                        backGr.changeText();
                      },
                    )
                  ],
                ),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(context.watch<CounterProvider>().counter.toString()),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Second()));
                        },
                        child: const Text("Next")),
                    ElevatedButton(
                        onPressed: () {
                          backGr.changeText();
                        },
                        child: const Text("Change text")),
                    Text(backGr.text),
                    ElevatedButton(
                        onPressed: () {
                          backGr.setColor(Colors.indigoAccent);
                        },
                        child: const Text("Change color"))
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(onPressed: () {
                context.read<CounterProvider>().increment();
              }),
            ),
          );
        }
    );
  }
}

class Second extends StatelessWidget {
  const Second({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.watch<CounterProvider>().counter.toString()),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Back"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        context.read<CounterProvider>().increment();
      }),
    );
  }
}
