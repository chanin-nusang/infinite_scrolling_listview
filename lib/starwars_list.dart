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
  static Map<String, Color?>? color = {
    'black': Colors.black,
    'blond': Color(0xFFFAF0BE),
    'fair': Color(0xFFF3CFBB),
    'blue': Colors.blue,
    'gold': Color(0xFFd4af37),
    'yellow': Colors.yellow,
    'white': Colors.white,
    'red': Colors.red,
    'brown': Colors.brown,
    'light': Colors.amber[100],
    'grey': Colors.grey,
    'auburn': Color(0xFF922704),
    'blue-gray': Color(0xFF657895),
    'green': Colors.green,
    'green-tan': Color(0xFFa9be70),
    'orange': Colors.orange,
    'hazel': Color(0xFF9e6b4a),
    'pale': Color(0xFFFFBFDF),
    'metal': Color(0xFFAAA9AD),
    'dark': Color(0xFF3A3B3C),
    'brown mottle': Color(0xFF654321),
    'mottled green': Color(0xFF98fb98),
    'pink': Colors.pink,
    'tan': Color(0xFFD2B48C),
    'blonde': Color(0xFFF0E2B6),
    'silver': Color(0xFFC0C0C0),
  };

  List<String>? hair, skin, eye;
  colorSplit() async {
    hair = people?.hairColor!.split(', ');
    skin = people?.skinColor!.split(', ');
    eye = people?.eyeColor!.split(', ');
  }

  List<Widget>? wid = [];
  colorSquare() async {
    for (int i = 0; i < hair!.length; i++) {
      if (color!.containsKey(hair![i])) {
        wid!.add(Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(),
            color: color![hair![i]],
          ),
          height: 13,
          width: 13,
        ));
      } else
        wid!.add(Text(" - ", style: TextStyle(color: Colors.grey[600])));
    }
    wid!.add(Text("/", style: TextStyle(color: Colors.grey[600])));
    for (int i = 0; i < skin!.length; i++) {
      if (color!.containsKey(skin![i])) {
        wid!.add(Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(),
            color: color![skin![i]],
          ),
          height: 13,
          width: 13,
        ));
      } else
        wid!.add(Text(" - ", style: TextStyle(color: Colors.grey[600])));
    }
    wid!.add(Text("/", style: TextStyle(color: Colors.grey[600])));
    for (int i = 0; i < eye!.length; i++) {
      if (color!.containsKey(eye![i])) {
        wid!.add(Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(),
            color: color![eye![i]],
          ),
          height: 13,
          width: 13,
        ));
      } else
        wid!.add(Text(" - ", style: TextStyle(color: Colors.grey[600])));
    }
  }

  @override
  Widget build(BuildContext context) {
    colorSplit();
    colorSquare();
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
                Row(
                  children: [
                    Flexible(
                      flex: 6,
                      child: Text('Hair/Skin/Eye Colors : ',
                          style: TextStyle(color: Colors.grey[600])),
                    ),
                    for (var item in wid!) Flexible(child: item)
                  ],
                ),
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
