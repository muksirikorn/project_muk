class Location {
  String info;
  int geohash;

  Location({
    this.info,
    this.geohash,
  });

  factory Location.fromJSON(Map<String, dynamic> json) {
    return Location(
      info: json['i'],
      geohash: json['g'],
    );
  }
}
