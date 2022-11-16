import 'package:beerapp/pages/consumption_list.dart';
import 'package:beerapp/pages/home.dart';
import 'package:beerapp/pages/scan.dart';
import 'package:beerapp/pages/variables.dart';
import 'package:flutter/material.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({Key? key}) : super(key: key);

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
        if (index == 0) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ScanPage()));
        } else if (index == 2) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const ConsumptionListPage(),
            ),
            (route) => false,
          );
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
            (route) => false,
          );
        }
        debugPrint(index.toString());
      },
      selectedIndex: currentPageIndex,
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.add_a_photo),
          label: 'Scan',
        ),
        NavigationDestination(
          icon: Icon(Icons.search),
          label: 'Discover',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.bookmark),
          icon: Icon(Icons.bookmark_border),
          label: 'Saved',
        ),
      ],
    );
  }
}
