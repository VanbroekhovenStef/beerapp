import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/beer.dart';

class BeerApi {
  static String okteto = 'edge-service-vanbroekhovenstef.cloud.okteto.net';

  static Future<List<Beer>> fetchBeers() async {
    var url = Uri.https(okteto, '/beers');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((beer) => Beer.fromJson(beer)).toList();
    } else {
      throw Exception('Failed to load beers');
    }
  }

  static Future<Beer> fetchBeer(String id) async {
    var url = Uri.https(okteto, '/beers/$id');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Beer.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load beer');
    }
  }

  static Future<List<Beer>> searchBeerByName(String beerName) async {
    var url = Uri.https(okteto, '/beers/search/$beerName');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((beer) => Beer.fromJson(beer)).toList();
    } else {
      throw Exception('Failed to load beers');
    }
  }
}
