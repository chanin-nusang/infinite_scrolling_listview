import 'package:flutter/material.dart';
import 'package:infinite_scrolling_listview/starwars_repo.dart';

class StarwarsList extends StatefulWidget {
  const StarwarsList({Key? key}) : super(key: key);
  @override
  _StarwarsListState createState() => _StarwarsListState();
}

class _StarwarsListState extends State<StarwarsList> {
  List<People> people = [];
  int? page, itemPerPage;
  bool? error, loading, hasMore;

  @override
  void initState() {
    page = 1;
    itemPerPage = 10;
    error = false;
    loading = true;
    hasMore = true;
    getPeople();
    super.initState();
  }

  Future getPeople() async {
    try {
      print("Page = $page");
      List<People> peoplePage = await StarwarsRepo().getPage(page!);
      print("PeoplePage lenght : ${peoplePage.length}");

      setState(() {
        hasMore = peoplePage.length == itemPerPage;
        loading = false;
        page = page! + 1;
        people.addAll(peoplePage);
        print("People lenght : ${people.length}");
      });
    } catch (e) {
      print(e);
      loading = false;
      error = true;
    }
  }

  empty() {
    if (loading!) {
      return Center(
        child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.amberAccent)),
      );
    } else if (error!) {
      return Center(
          child: InkWell(
        onTap: () {
          setState(() {
            loading = true;
            error = false;
            getPeople();
          });
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Error!, tap to try loading again."),
          ),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (people.isEmpty) {
      return empty();
    } else {
      return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: people.length + (hasMore! ? 1 : 0),
          itemBuilder: (BuildContext context, int index) {
            if (index == people.length - 5) {
              if (page! < 10) {
                getPeople();
              }
            }
            if (index == people.length) {
              if (error!) {
                return Center(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        loading = true;
                        error = false;
                        getPeople();
                      });
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Error!, tap to try loading again."),
                      ),
                    ),
                  ),
                );
              } else
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Colors.amberAccent)),
                  ),
                );
            }
            print("Name : ${people[index].name}");
            print("Index : $index");
            print("Error : $error");
            People _people = people[index];
            return Wrap(
              children: [
                PeopleTile(people: _people),
                if (index < people.length - 1)
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Divider(),
                  )
              ],
            );
          });
    }
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
          Container(
            width: 80,
            height: 80,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.transparent,
              backgroundImage: Image.asset(
                'images/Star_Wars_Logo_Square.png',
                fit: BoxFit.cover,
              ).image,
              foregroundImage: NetworkImage(
                  'https://starwars-visualguide.com/assets/img/characters/${people?.no}.jpg'),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
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
          )
        ],
      ),
    );
  }
}
