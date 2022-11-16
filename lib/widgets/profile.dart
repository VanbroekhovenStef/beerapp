import 'package:beerapp/models/beer.dart';
import 'package:beerapp/pages/consumption_list.dart';
import 'package:beerapp/pages/home.dart';
import 'package:beerapp/pages/scan.dart';
import 'package:beerapp/pages/variables.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key, required this.beer}) : super(key: key);
  final Beer beer;

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  static const double circleRadius = 100.0;
  static const double circleBorderWidth = 8.0;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: circleRadius / 2.0),
        child: Container(
            color: Colors.white,
            height: 150.0,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                const SizedBox(height: circleRadius / 2),
                Text(widget.beer.name,
                    style: const TextStyle(
                        fontSize: 40.0,
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                Text(
                    "${widget.beer.type}, ${widget.beer.alcoholpercentage}% alcohol",
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
          decoration:
              const ShapeDecoration(shape: CircleBorder(), color: Colors.white),
          child: Padding(
            padding: EdgeInsets.all(circleBorderWidth),
            child: DecoratedBox(
                decoration: ShapeDecoration(
                    shape: const CircleBorder(),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.beer.picture)))),
          )),
    ]);
  }
}
