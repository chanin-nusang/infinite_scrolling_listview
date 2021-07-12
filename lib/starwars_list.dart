import 'package:flutter/material.dart';
import 'package:infinite_scrolling_listview/starwars_repo.dart';

class StarwarsList extends StatefulWidget {
  const StarwarsList({Key? key}) : super(key: key);
  @override
  _StarwarsListState createState() => _StarwarsListState();
}

class _StarwarsListState extends State<StarwarsList> {
  List<People> people = [];
  int page = 1;

  @override
  void initState() {
    getPeople();
    super.initState();
  }

  Future<List<People>> getPeople() async {
    List<People> peoplePage = await StarwarsRepo().getPage(page);
    people.addAll(peoplePage);
    return people;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Starwars People List',
            style: TextStyle(color: Colors.black, fontSize: 20)),
      ),
      body: FutureBuilder(
        future: getPeople(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) => Wrap(
                      children: [
                        PeopleTile(people: snapshot.data[index]),
                        if (index < snapshot.data.length - 1)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Divider(),
                          )
                      ],
                    ));
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }
}

class PeopleTile extends StatelessWidget {
  PeopleTile({@required this.people});
  final People? people;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Row(
        children: [
          CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                  'https://starwars-visualguide.com/assets/img/characters/${people?.no}.jpg')),
          SizedBox(
            width: 10,
          ),
          Expanded(
            //height: 100,
            child: Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    people?.name ?? ' ',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Gender : ${people?.gender}   Height : ${people?.height.toString()}   Mass : ${people?.mass.toString()}",
                    style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                  ),
                  Text(
                      'Hair/Skin/Eye Color : ${people?.hairColor}/${people?.skinColor}/${people?.eyeColor}',
                      style: TextStyle(color: Colors.grey[600])),
                  Text('Year of Birth : ${people?.birthYear}',
                      style: TextStyle(
                          color: Colors.grey[600], fontWeight: FontWeight.w400))
                ],
              ),
            ),
          )
        ],
      ),
    );
    // ListTile(
    //   dense: true,
    //   leading: _leading(),
    //   title: _title(),
    //   subtitle: _subtitle(),
    //   isThreeLine: true,
    //   trailing: Text(
    //     "${people?.no}",
    //     style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
    //   ),
    //   onTap: () {},
    //   onLongPress: () {},
    // );
  }

  Widget _leading() {
    return CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(
            'https://starwars-visualguide.com/assets/img/characters/${people?.no}.jpg'));
  }

  Widget _subtitle() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Gender : ${people?.gender}   Height : ${people?.height.toString()}   Mass : ${people?.mass.toString()}",
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
        Row(
          children: [
            Flexible(
              child: Text(
                  'Hair/Skin/Eye Color : ${people?.hairColor}/${people?.skinColor}/${people?.eyeColor}'),
            )
          ],
        ),
        Row(
          children: [Text('Year of Birth : ${people?.birthYear}')],
        ),
      ],
    );
  }

  Widget _title() {
    return Row(
      children: [
        Text(
          people?.name ?? ' ',
          style: TextStyle(fontSize: 20),
        )
      ],
    );
  }
}
