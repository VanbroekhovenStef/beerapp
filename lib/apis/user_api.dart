import 'package:beerapp/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/beer.dart';

class UserApi {
  static String server = 'fine-dancers-shop-84-197-242-116.loca.lt';

  static Future<List<User>> fetchUserByName(String username) async {
      Map<String, String> queryParameters = <String, String> {
        "name": username
      };

      var url = Uri.https(server, '/users', queryParameters);

      final response = await http.get(url);

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((user) => User.fromJson(user)).toList();
      } else {
        throw Exception('Failed to load beers');
      }
  }

  static Future<User> fetchUserById(int id) async {
    var url = Uri.https(server, '/users/$id');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load beer');
    }
  }
}