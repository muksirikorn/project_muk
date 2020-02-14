import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nearby.dart';

class ApiServices {
  Future<Nearby> fetchNearBy(int id, double lat, double lng, int radius) async {
    final response = await http.get(
        'https://nearby-nmfzexfhgq-uc.a.run.app/near_by?app_id=$id&lat=$lat&lng=$lng&radius=$radius');
    if (response.statusCode == 200) {
      return Nearby.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }
}
