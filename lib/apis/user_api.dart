import 'package:beerapp/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserApi {
  static String server = 'edge-service-vanbroekhovenstef.cloud.okteto.net';

  static Future<User> fetchUserByName(String username) async {
    var url = Uri.https(server, '/users/$username');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      if (response.contentLength == 0) {
        return User(id: "0", firstName: "", name: "", dateOfBirth: "");
      } else {
        return User.fromJson(jsonDecode(response.body));
      }
    } else {
      throw Exception('Failed to load user');
    }
  }
}
