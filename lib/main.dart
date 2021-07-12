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
          accentColor: Colors.yellow,
          fontFamily: 'Kanit',
        ),
        home: StarwarsList());
  }
}
