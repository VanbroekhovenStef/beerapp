import 'package:beerapp/apis/consumption_api.dart';
import 'package:beerapp/models/consumption.dart';
import 'package:beerapp/pages/home.dart';
import 'package:beerapp/pages/variables.dart';
import 'package:beerapp/widgets/profile.dart';
import 'package:flutter/material.dart';
import '../models/beer.dart';
import '../apis/beer_api.dart';
import 'package:givestarreviews/givestarreviews.dart';

const List<String> choices = <String>['Save & Back', 'Delete', 'Back'];
// CreateConsumptionPage is used to create and also edit consumptions

class CreateConsumptionPage extends StatefulWidget {
  // Variables needed for API calls that are requested when loading the page
  final String beerId;
  final String consumptionId;
  final String beerName;

  CreateConsumptionPage(
  // Variables are not required. Can vary depending on which page navigates to the creation page.
      {Key? key, this.beerId = "", this.consumptionId = "", this.beerName = ""})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateConsumptionPageState();
}

class _CreateConsumptionPageState extends State<CreateConsumptionPage> {
  // Additional variables used on the page
  Beer? beer;
  Consumption? consumption;
  int score = 0;
  String menuText = "";

  TextEditingController remarkController = TextEditingController();
  bool _isEnable = true;

  // Method to execute the correct method based on the choice that was made by the user
  void _menuSelected(String index) async {
    switch (index) {
      case "0": // Save beer & Back
        _saveConsumption();
        break;
      case "1": // Delete beer
        _deleteConsumption();
        break;
      case "2": // Back to List
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
        break;
      default:
    }
  }

  // Save or update consumption based on what parameters were filled in on navigation to this page.
  void _saveConsumption() {
    var dateTime = DateTime.now().toString();
    dateTime = dateTime.replaceAll(' ', 'T');
    dateTime = "${dateTime}Z";

    consumption!.remark = remarkController.text;
    consumption!.score = score;
    consumption!.beerId = beer!.id.toString();
    consumption!.userId = userId;
    consumption!.count = 1;
    consumption!.createdAt = dateTime;

    currentPageIndex = 1;

    if (widget.consumptionId == "") {
      ConsumptionApi.createConsumption(consumption!).then((result) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      });
    } else {
      debugPrint(consumption!.beer!.name);
      ConsumptionApi.updateConsumption(widget.consumptionId, consumption!)
          .then((result) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      });
    }
  }

  void _deleteConsumption() {
    ConsumptionApi.deleteConsumption(widget.consumptionId).then((result) {
      currentPageIndex = 1;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    // If the beerId was filled in on navigation, then the page will create a new consumption
    if (widget.beerId != "") {
      menuText = "Add new beer";
      _getBeer(widget.beerName);
    }
    // If a consumptionId wass filled in on navigation, then the page will update the consumption
    if (widget.consumptionId != "") {
      _isEnable = false;
      menuText = "View consumption";
      _getConsumption(widget.consumptionId);
    }
  }

  // _getBeer is called when only the beer information needs to be fetched. This will be used to create the consumption
  void _getBeer(String name) {
    BeerApi.fetchBeer(name).then((result) {
      // call the api to fetch the user data
      setState(() {
        beer = result;
        consumption = Consumption(
            id: "",
            beerId: widget.beerId.toString(),
            userId: userId.toString(),
            score: score,
            count: 0,
            createdAt: "",
            remark: "");
      });
    });
  }

  // _getConsumption is called when the consumption needs to be edited. The beer object is also filled to provide correct layout of the page.
  void _getConsumption(String id) {
    ConsumptionApi.fetchConsumptionById(id).then((result) {
      setState(() {
        consumption = result;
        beer = result.beer;
      });
      remarkController.text = result.remark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(menuText),
        actions: <Widget>[
          // Create menu in top right that displays options for save, delete and back navigation.
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
          height: MediaQuery.of(context).size.height,
          color: const Color.fromARGB(255, 158, 157, 149),
          padding: const EdgeInsets.all(5.0),
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical, child: _addConsumption())),
    );
  }
  
  // Page contents
  _addConsumption() {
    if (beer == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      TextStyle? textStyle = Theme.of(context).textTheme.bodyText1;

      return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        ProfileWidget(beer: beer!),
        const SizedBox(height: 15.0),
        const Text("What did you think of this beer?",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 20.0,
                decoration: TextDecoration.none,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        Container(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300.0,
              child: TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  hintText: 'Remarks',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
                ),
                controller: remarkController,
                enabled: _isEnable,
              ),
            ),
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    _isEnable = !_isEnable;
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
        StarRating(
          onChanged: (rate) {
            score = rate;
          },
          value: consumption!.score,
        ),
      ]);
    }
  }
}
