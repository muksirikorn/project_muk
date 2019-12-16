import 'operation.dart';
import 'address.dart';
import 'contact.dart';

class Insert {
  String name;
  Address address;
  Contact contact;
  String description;
  Operation operation;
  double lat;
  double lng;
  String src;

  Insert(
      {this.name,
      this.address,
      this.contact,
      this.description,
      this.operation,
      this.lat,
      this.lng,
      this.src});
}
