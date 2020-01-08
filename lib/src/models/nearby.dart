import 'location.dart';

class Nearby {
  List<Location> locations;

  Nearby({this.locations});

  factory Nearby.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['result'] as List;
    List<Location> locationList =
        list.map((i) => Location.fromJSON(i)).toList();

    return Nearby(locations: locationList);
  }
}
