import 'package:beerapp/pages/consumption_create.dart';
import 'package:beerapp/widgets/profile.dart';
import 'package:flutter/material.dart';
import '../models/beer.dart';
import '../apis/beer_api.dart';
import 'package:readmore/readmore.dart';

class BeerDetailPage extends StatefulWidget {
  final String name;

  const BeerDetailPage({Key? key, required this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BeerDetailPageState();
}

class _BeerDetailPageState extends State<BeerDetailPage> {
  Beer? beer;

  // Load beer information to the page
  @override
  void initState() {
    super.initState();
    _getBeer(widget.name);
  }

  // Call to BeerAPI to fetch the beer and set state
  void _getBeer(String name) {
    BeerApi.fetchBeer(name).then((result) {
      setState(() {
        beer = result;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Beer details"),
        ),
        //Button to navigate to consumption_create page
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToNewConsumption(beer!.id.toString(), beer!.name);
        },
        tooltip: "Add new Consumption",
        child: const Icon(Icons.add),
        ),
        body: Container(
          color: const Color.fromARGB(255, 158, 157, 149),
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              // Profile layout for the beer
              ProfileWidget(beer: beer!),
              const Text(
                "Description",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20.0,
                  decoration: TextDecoration.none,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
              // Description of the beer in ReadMoreText widget so it can be maximized and minimized if needed
              ReadMoreText(
                  beer!.description,
                  trimLines: 2,
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: 'Show less',
                  moreStyle:
                      const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              )
          ]),
        )
    );
  }

  _navigateToNewConsumption(String id, String name) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateConsumptionPage(beerId: id, beerName: name)),
    );
  }  
}
