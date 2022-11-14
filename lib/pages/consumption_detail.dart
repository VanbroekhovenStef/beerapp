import 'package:beerapp/apis/consumption_api.dart';
import 'package:beerapp/models/consumption.dart';
import 'package:beerapp/pages/consumption_create.dart';
import 'package:flutter/material.dart';
import '../models/beer.dart';
import '../apis/beer_api.dart';
import 'package:givestarreviews/givestarreviews.dart';

const List<String> choices = <String>[
  'Edit consumption',
  'Delete consumption',
  'Back'
];

class ConsumptionDetailPage extends StatefulWidget {
  final int id;

  const ConsumptionDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConsumptionDetailPageState();
}

class _ConsumptionDetailPageState extends State<CreateConsumptionPage> {
  Beer? beer;
  Consumption? consumption;
  int score = 0;

  TextEditingController remarkController = TextEditingController();
  bool _isEnable = false;

  void _menuSelected(String index) async {
    switch (index) {
      case "0": // Save User & Back
        _saveConsumption();
        break;
      case "1": // Delete User
        _deleteConsumption();
        break;
      case "2": // Back to List
        Navigator.pop(context, true);
        break;
      default:
    }
  }

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

  void _saveConsumption() {
    consumption!.remark = remarkController.text;
    consumption!.score = score;
    consumption!.beerId = beer!.id;
    consumption!.userId = 1;
    consumption!.count = 1;
    consumption!.createdAt = DateTime.now().toString();

    if (consumption!.id != 0) {
      ConsumptionApi.updateConsumption(consumption!.id, consumption!)
          .then((result) {
        Navigator.pop(context, true);
      });
    }
  }

  void _deleteConsumption() {
    ConsumptionApi.deleteConsumption(widget.id).then((result) {
      Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add new beer"),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: _menuSelected,
              itemBuilder: (BuildContext context) {
                return choices.asMap().entries.map((entry) {
                  return PopupMenuItem<String>(
                    value: entry.key.toString(),
                    child: Text(entry.value),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Container(
          color: const Color.fromARGB(255, 158, 157, 149),
          padding: const EdgeInsets.all(5.0),
          child: _viewConsumption(),
        ));
  }

  _viewConsumption() {
    const double circleRadius = 100.0;
    const double circleBorderWidth = 8.0;

    if (beer == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      TextStyle? textStyle = Theme.of(context).textTheme.bodyText1;

      return Column(children: <Widget>[
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
        const Text("What did you think of this beer?",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 20.0,
                decoration: TextDecoration.none,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        Row(
            children: <Widget>[
              Container(
                width: 100,
                child: TextField(
                  controller: remarkController,
                  enabled: _isEnable,
                ),
              ),
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEnable = true;
                    });
                  })
            ],
          ),
        Container(
          height: 15,
        ),
        const Text("Leave a rating",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 20.0,
                decoration: TextDecoration.none,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        StarRating(onChanged: (rate) {}, value: consumption!.score),
      ]);
    }
  }

  // _beerDetailsBottom() {}
}
