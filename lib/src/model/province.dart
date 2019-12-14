class Province {
  String documentID;
  String name;
  String objectID;

  Province({this.documentID, this.name, this.objectID});

  factory Province.fromJSON(Map<String, dynamic> json) {
    return Province(
      documentID: json['documentID'],
      name: json['name'],
      objectID: json['objectID']);
  }
}
