import 'package:beerapp/pages/arbeer.dart';
import 'package:beerapp/pages/consumption_list.dart';
import 'package:flutter/material.dart';
import '../models/beer.dart';
import '../apis/beer_api.dart';
import 'beer_detail.dart';
import 'beer_list.dart';
import 'scan.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State {
  int currentPageIndex = 1;
  List<Beer> beerList = [];
  int count = 0;

  @override
  void initState() {
    super.initState();
    _getBeers();
  }

  void _getBeers() {
    BeerApi.fetchBeers().then((result) {
      setState(() {
        beerList = result;
        count = result.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Discover"),
      ),
      body: Container(
        padding: const EdgeInsets.all(15.0),
        alignment: Alignment.center,
        color: const Color.fromARGB(255, 158, 157, 149),
        child: Column(children: <Widget>[
          TextField(
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  hintText: 'Search beers or breweries',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(15),
                    child: Icon(Icons.search),
                    width: 18,
                  ))),
          const Divider(height: 50.0, color: Colors.white),
          const Text(
            "Progress",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          _beerListItems(),
        ]),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
          if (index == 0) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ArBeerPage()));
          } else if (index == 2) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ConsumptionListPage()));
          }
          debugPrint(index.toString());
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.add_a_photo),
            label: 'Scan',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Discover',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bookmark),
            icon: Icon(Icons.bookmark_border),
            label: 'Saved',
          ),
        ],
      ),
    );
  }

  ListView _beerListItems() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Text(beerList[position].name.substring(0, 1)),
            ),
            title: Text(beerList[position].name),
            subtitle: Text(
                "${beerList[position].type} bier, ${beerList[position].alcoholPercentage}% alcohol"),
            onTap: () {
              _navigateToDetail(beerList[position].id);
            },
          ),
        );
      },
    );
  }

  void _navigateToDetail(int id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BeerDetailPage(id: id)),
    );

    _getBeers();
  }
}
