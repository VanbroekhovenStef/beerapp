import 'package:beerapp/widgets/navigation.dart';
import 'package:flutter/material.dart';
import '../widgets/armultipletargets.dart';

class ArBeerPage extends StatefulWidget {

  const ArBeerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ArBeerPageState();
}

class _ArBeerPageState extends State<ArBeerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan beer"),
      ),
      body: const Center(
          // Here we load the Widget with the AR Dino experience
          child: ArMultipleTargetsWidget()),
      bottomNavigationBar: const NavigationWidget(),
    );
  }
}
