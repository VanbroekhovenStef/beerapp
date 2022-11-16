import 'package:beerapp/models/datapoint.dart';
import 'package:beerapp/pages/consumption_create.dart';
import 'package:beerapp/pages/variables.dart';
import 'package:beerapp/widgets/barchart.dart';
import 'package:beerapp/widgets/navigation.dart';
import 'package:flutter/material.dart';
import '../models/consumption.dart';
import '../apis/consumption_api.dart';

class ConsumptionListPage extends StatefulWidget {
  const ConsumptionListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConsumptionListPageState();
}

class _ConsumptionListPageState extends State {
  List<Consumption> consumptionList = [];
  int count = 0;
  DataPoint? datapoint;
  List<DataPoint> datapoints = [];

  @override
  void initState() {
    super.initState();
    _getConsumptions();
  }

  void _getConsumptions() {
    ConsumptionApi.fetchConsumptionsByUser(userId).then((result) {
      setState(() {
        consumptionList = result;
        count = result.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consumptions"),
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: <Widget>[
              const Text("Progress",
                  style: TextStyle(
                      fontSize: 20.0,
                      decoration: TextDecoration.none,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              Container(
                height: 30,
              ),
              BarChartWidget(consumptions: consumptionList),
              const Text("Beers you drunk",
                  style: TextStyle(
                      fontSize: 20.0,
                      decoration: TextDecoration.none,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              Container(
                height: 15,
              ),
              _consumptionListItems(),
            ])),
      ),
      bottomNavigationBar: const NavigationWidget(),
    );
  }

  ListView _consumptionListItems() {
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
                  child: Text(
                      consumptionList[position].beer!.name.substring(0, 1))),
              title: Text(consumptionList[position].beer!.name),
              subtitle: Text(
                  consumptionList[position].createdAt.substring(0, 10)),
              onTap: () {
                _navigateToDetail(consumptionList[position].id);
              },
            ));
      },
    );
  }

  _navigateToDetail(String id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateConsumptionPage(consumptionId: id)),
    );

    _getConsumptions();
  }
}
