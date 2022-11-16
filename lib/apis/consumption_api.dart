import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/consumption.dart';

class ConsumptionApi {
  static String server = 'edge-service-vanbroekhovenstef.cloud.okteto.net';

  static Future<List<Consumption>> fetchConsumptions() async {
    var url = Uri.https(server, "/consumptions");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((consumption) => Consumption.fromJson(consumption))
          .toList();
    } else {
      throw Exception('Failed to load consumptions');
    }
  }

  static Future<List<Consumption>> fetchConsumptionsByBeer(String name) async {
    var url = Uri.https(server, "/consumptions/");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((consumption) => Consumption.fromJson(consumption))
          .toList();
    } else {
      throw Exception('Failed to load consumptions');
    }
  }

  static Future<List<Consumption>> fetchConsumptionsByUser(String name) async {
    var url = Uri.https(server, "/consumptions");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((consumption) => Consumption.fromJson(consumption))
          .toList();
    } else {
      throw Exception('Failed to load consumptions');
    }
  }

  static Future<Consumption> fetchConsumptionById(String id) async {
    var url = Uri.https(server, '/consumptions/$id');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Consumption.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load consumption');
    }
  }

  static Future<String> createConsumption(Consumption consumption) async {
    var url = Uri.https(server, '/consumptions');

    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(consumption),
    );
    if (response.statusCode == 200) {
      return "Success";
    } else {
      throw Exception('Failed to create consumption');
    }
  }

  static Future<String> updateConsumption(String id, Consumption consumption) async {
    var url = Uri.https(server, '/consumptions/$id');

    final http.Response response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(consumption),
    );
    if (response.statusCode == 200) {
      return "Success";
    } else {
      throw Exception('Failed to update consumption');
    }
  }

  static Future deleteConsumption(String id) async {
    var url = Uri.https(server, '/consumptions/$id');
    
    final http.Response response =
        await http.delete(url);
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete consumption');
    }
  }
}
