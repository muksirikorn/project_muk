import 'package:dio/dio.dart';
import 'package:project_muk/src/models/nearby.dart';

class ApiServices {
  Dio dio = Dio();
  Future<Nearby> fetchNearBy(int id, double lat, double lng, int radius) async {
    final response = await dio.get(
      'https://nearby-nmfzexfhgq-uc.a.run.app/near_by',
      queryParameters: {
        "app_id": id,
        "lat": lat,
        "lng": lng,
        "radius": radius,
      },
    );
    if (response.statusCode == 200) {
      return Nearby.fromJson(response.data);
    } else {
      throw Exception('Failed to load post');
    }
  }
}
