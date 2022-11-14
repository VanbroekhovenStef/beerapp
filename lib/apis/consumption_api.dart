import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/consumption.dart';

class ConsumptionApi {
  static String server = 'fine-dancers-shop-84-197-242-116.loca.lt';
  static final Map<String, String> _queryParameters = <String, String>{
    '_expand': 'beer'
  };

  static Future<List<Consumption>> fetchConsumptions() async {
    var url = Uri.https(server, "/consumptions", _queryParameters);

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

  static Future<Consumption> fetchConsumption(int id) async {
    var url = Uri.https(server, '/consumptions/$id', _queryParameters);

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Consumption.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load consumption');
    }
  }

  static Future<Consumption> createConsumption(Consumption consumption) async {
    var url = Uri.https(server, '/consumptions');

    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(consumption),
    );
    if (response.statusCode == 201) {
      return Consumption.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create consumption');
    }
  }

  static Future<Consumption> updateConsumption(int id, Consumption consumption) async {
    var url = Uri.https(server, '/consumptions/$id');

    final http.Response response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(consumption),
    );
    if (response.statusCode == 200) {
      return Consumption.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update consumption');
    }
  }

  static Future deleteConsumption(int id) async {
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
