import 'package:beerapp/widgets/armultipletargets.dart';
import 'package:beerapp/widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_plugin.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_response.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanPageState();
}

// This page loads the AR widget and does checks on device compatibility
class _ScanPageState extends State<ScanPage> {
  List<String> features = ["image_tracking"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan label of beer"),
      ),
      body: const Center(
        child: ArMultipleTargetsWidget()
      ),
      bottomNavigationBar: const NavigationWidget(),
    );
  }

 Future<WikitudeResponse> checkDeviceCompatibility() async {
    return await WikitudePlugin.isDeviceSupporting(features);
  }

  Future<WikitudeResponse> requestARPermissions() async {
    return await WikitudePlugin.requestARPermissions(features);
  }
}
