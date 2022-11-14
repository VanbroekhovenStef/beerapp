import 'package:beerapp/pages/consumption_detail.dart';
import 'package:flutter/material.dart';
import '../models/consumption.dart';
import '../models/user.dart';
import '../models/beer.dart';
import '../apis/consumption_api.dart';

class ConsumptionListPage extends StatefulWidget {
  const ConsumptionListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConsumptionListPageState();
}

class _ConsumptionListPageState extends State {
  List<Consumption> consumptionList = [];
  int count = 0;

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
        child: _consumptionListItems(),
      ),
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
