import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/beer.dart';

class BeerApi {
  static String server = 'tough-cows-feel-84-197-242-116.loca.lt';

  static Future<List<Beer>> fetchBeers() async {
      var url = Uri.https(server, '/beers');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((beer) => Beer.fromJson(beer)).toList();
      } else {
        throw Exception('Failed to load beers');
      }
  }

  static Future<Beer> fetchBeer(int id) async {
    var url = Uri.https(server, '/beers/$id');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Beer.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load beer');
    }
  }
}