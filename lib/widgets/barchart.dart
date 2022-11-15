import 'package:beerapp/models/consumption.dart';
import 'package:beerapp/models/datapoint.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import "package:collection/collection.dart";

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({Key? key, required this.consumptions})
      : super(key: key);
  final List<Consumption> consumptions;

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  List<DataPoint>? points;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: BarChart(
        BarChartData(
          barGroups: _chartGroups(),
          borderData: FlBorderData(
              border: const Border(bottom: BorderSide(), left: BorderSide())),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: _bottomTitles),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }

  convertToDatapoints(List<Consumption> consumptions) {
    List<DataPoint> datapoints = [];
    DataPoint datapoint = DataPoint(x: 0, y: 0);
    consumptions.forEach((element) {
      datapoint.x = DateTime.parse(element.createdAt).month;
      datapoint.y = 1;
      datapoints.add(datapoint);
    });
    datapoints.sort((a, b) => a.x.compareTo(b.y));

    var counter = 0;
    List<DataPoint> groupedPoints = [];
    int monthInd = 0;

    while (counter < datapoints.length) {
      monthInd = datapoints[counter].x;
      double number = 0;
      while (counter < datapoints.length && datapoints[counter].x == monthInd) {
        number += 1;
        counter += 1;
      }
      datapoint.x = monthInd;
      datapoint.y = number;
      groupedPoints.add(datapoint);
    }

    DataPoint datapoint1 = DataPoint(x: 1, y: 4);
    DataPoint datapoint2 = DataPoint(x: 2, y: 5);
    DataPoint datapoint3 = DataPoint(x: 3, y: 10);
    groupedPoints.add(datapoint1);
    groupedPoints.add(datapoint2);
    groupedPoints.add(datapoint3);


    return groupedPoints;
  }

  List<BarChartGroupData> _chartGroups() {
    debugPrint(widget.consumptions.toString());
    debugPrint(widget.consumptions.length.toString());
    debugPrint("Dit was de log");
    points = convertToDatapoints(widget.consumptions);

    return points!
        .map((point) => BarChartGroupData(
            x: point.x.toInt(), barRods: [BarChartRodData(toY: point.y)]))
        .toList();
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          String text = '';
          switch (value.toInt()) {
            case 1:
              text = 'Jan';
              break;
            case 2:
              text = 'Feb';
              break;
            case 3:
              text = 'Mar';
              break;
            case 4:
              text = 'Apr';
              break;
            case 5:
              text = 'May';
              break;
            case 6:
              text = 'Jun';
              break;
            case 7:
              text = 'Jul';
              break;
            case 8:
              text = 'Aug';
              break;
            case 9:
              text = 'Sep';
              break;
            case 10:
              text = 'Oct';
              break;
            case 11:
              text = 'Nov';
              break;
            case 12:
              text = 'Dec';
              break;
            default:
              'other?';
          }

          return Text(text);
        },
      );
}
