import 'package:beerapp/widgets/navigation.dart';
import 'package:flutter/material.dart';
import '../models/beer.dart';
import '../apis/beer_api.dart';
import 'beer_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State {
  List<Beer> beerList = [];
  int count = 0;

  // Load all beers to the page
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

  // Calling api that fetches beers with value that was put in searchbar. Update state with new list of beers.
  void _getFilteredBeers(String search) {
    BeerApi.searchBeerByName(search).then((result) {
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
        alignment: Alignment.topCenter,
        height: MediaQuery.of(context).size.height,
        color: const Color.fromARGB(255, 158, 157, 149),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                )),
            onSubmitted: (value) {
              _getFilteredBeers(value);
            },
          ),
          const Divider(height: 50.0, color: Colors.white),
          _beerListItems(),
        ]),
        )  
      ),
      // Custom navigation bar
      bottomNavigationBar: const NavigationWidget()
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
                "${beerList[position].type} bier, ${beerList[position].alcoholpercentage}% alcohol"),
            onTap: () {
              _navigateToDetail(beerList[position].name);
            },
          ),
        );
      },
    );
  }

  void _navigateToDetail(String name) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BeerDetailPage(name: name)),
    );

    _getBeers();
  }
}
