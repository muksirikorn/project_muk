class Location {
  String name;
  double lat;
  double lon;

  Location({
    this.name,
    this.lat,
    this.lon,
  });

  factory Location.fromJSON(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      lat: json['lat'],
      lon: json['lon'],
    );
  }
}
