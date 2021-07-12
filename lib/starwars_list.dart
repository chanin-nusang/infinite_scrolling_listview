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
    return ListTile(
      // leading: ,
      title: _title(),
      subtitle: _subtitle(),
      isThreeLine: true,
      trailing: Text(
        "${people?.no}",
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
      onTap: () {},
      onLongPress: () {},
    );
  }

  Widget _subtitle() {
    return Column(
      children: [
        Row(
          children: [Text(people?.gender ?? ' ')],
        )
      ],
    );
  }

  Widget _title() {
    return Row(
      children: [Text(people?.name ?? ' ')],
    );
  }
}
