import 'package:beerapp/pages/consumption_create.dart';
import 'package:flutter/material.dart';
import '../models/beer.dart';
import '../apis/beer_api.dart';
import 'package:readmore/readmore.dart';

class BeerDetailPage extends StatefulWidget {
  final int id;

  const BeerDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BeerDetailPageState();
}

class _BeerDetailPageState extends State<BeerDetailPage> {
  Beer? beer;

  @override
  void initState() {
    super.initState();
    _getBeer(widget.id);
  }

  void _getBeer(int id) {
    BeerApi.fetchBeer(id).then((result) {
      // call the api to fetch the user data
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
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToNewConsumption(beer!.id);
        },
        tooltip: "Add new Consumption",
        child: const Icon(Icons.add),
        ),
        body: Container(
          color: const Color.fromARGB(255, 158, 157, 149),
          padding: const EdgeInsets.all(5.0),
          child: _beerProfile(),
        )
    );
  }

  _navigateToNewConsumption(int id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateConsumptionPage(id: id)),
    );
  }

  _beerProfile() {
    const double circleRadius = 100.0;
    const double circleBorderWidth = 8.0;

    if (beer == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Column(
        children: <Widget>[
        Stack(alignment: Alignment.topCenter, children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: circleRadius / 2.0),
            child: Container(
                color: Colors.white,
                height: 150.0,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: circleRadius / 2),
                    Text(beer!.name,
                        style: const TextStyle(
                            fontSize: 40.0,
                            decoration: TextDecoration.none,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    Text("${beer!.type}, ${beer!.alcoholPercentage}% alcohol",
                        style: const TextStyle(
                            fontSize: 20.0,
                            decoration: TextDecoration.none,
                            color: Colors.black,
                            fontWeight: FontWeight.normal)),
                  ],
                )),
          ),
          Container(
              width: circleRadius,
              height: circleRadius,
              decoration: const ShapeDecoration(
                  shape: CircleBorder(), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(circleBorderWidth),
                child: DecoratedBox(
                    decoration: ShapeDecoration(
                        shape: const CircleBorder(),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(beer!.picture)))),
              )),
        ]),
        const SizedBox(height: 15.0),
        const Text(
          "Description",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20.0,
            decoration: TextDecoration.none,
            color: Colors.black,
            fontWeight: FontWeight.bold)),
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
      ]);
    }
  }
  
  // _beerDetailsBottom() {}
}
