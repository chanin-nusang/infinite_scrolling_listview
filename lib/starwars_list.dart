import 'package:flutter/material.dart';
import 'package:infinite_scrolling_listview/starwars_repo.dart';

class StarwarsList extends StatefulWidget {
  const StarwarsList({Key? key}) : super(key: key);
  @override
  _StarwarsListState createState() => _StarwarsListState();
}

class _StarwarsListState extends State<StarwarsList> {
  List<People>? people;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Starwars People List',
            style: TextStyle(color: Colors.black, fontSize: 20)),
      ),
    );
  }
}
