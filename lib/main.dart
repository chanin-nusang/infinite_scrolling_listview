import 'package:flutter/material.dart';
import 'package:infinite_scrolling_listview/starwars_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: Colors.amberAccent,
          fontFamily: 'Kanit',
        ),
        home: Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Star Wars People List',
                      style: TextStyle(color: Colors.black, fontSize: 20)),
                  Image.asset(
                    'images/Star_Wars_Logo.png',
                    fit: BoxFit.contain,
                    height: 35,
                  ),
                ],
              ),
            ),
            body: StarwarsList()));
  }
}
