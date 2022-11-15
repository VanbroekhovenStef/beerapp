import 'package:beerapp/models/datapoint.dart';
import 'package:beerapp/pages/consumption_detail.dart';
import 'package:beerapp/widgets/barchart.dart';
import 'package:flutter/material.dart';
import '../models/consumption.dart';
import '../models/user.dart';
import '../models/beer.dart';
import '../apis/consumption_api.dart';
import 'package:fl_chart/fl_chart.dart';

class ConsumptionListPage extends StatefulWidget {
  const ConsumptionListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConsumptionListPageState();
}

class _ConsumptionListPageState extends State {
  List<Consumption> consumptionList = [];
  int count = 0;
  DataPoint datapoint = DataPoint(x: 1, y: 1);
  List<DataPoint> datapoints = [];

  @override
  void initState() {
    super.initState();
    _getConsumptions();
  }

  void _getConsumptions() {
    ConsumptionApi.fetchConsumptions().then((result) {
      setState(() {
        consumptionList = result;
        count = result.length;
        // datapoints = consumptionList;
      });
    });
  }

  convertToDatapoints(List<Consumption> consumptions) {
    List<DataPoint> datapoints = [];
    DataPoint datapoint = DataPoint(x: 0, y: 0);
    consumptions.forEach((element) {
      datapoint.x = DateTime.parse(element.createdAt).month;
      datapoint.y += 1;
      datapoints.add(datapoint);
    });
    return datapoints;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consumptions"),
      ),
      body: Container(
          padding: const EdgeInsets.all(5.0),
          child: Column(children: <Widget>[
            const Text("Progress",
                style: TextStyle(
                    fontSize: 20.0,
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            BarChartWidget(consumptions: consumptionList),
            const Text("Beers you drunk",
                style: TextStyle(
                    fontSize: 20.0,
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            _consumptionListItems(),
          ])),
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
                      consumptionList[position].beer.name.substring(0, 1))),
              title: Text(consumptionList[position].beer.name),
              subtitle: Text(
                  "${consumptionList[position].beer.type}, ${consumptionList[position].beer.alcoholPercentage}% alcohol"),
              onTap: () {
                _navigateToDetail(consumptionList[position].id);
              },
            ));
      },
    );
  }

  _navigateToDetail(int id) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConsumptionDetailPage(id: id)),
    );

    _getConsumptions();
  }
}
