import 'operation.dart';
import 'address.dart';
import 'contact.dart';

class Shop {
  String name;
  Address address;
  Contact contact;
  String description;
  String type;
  Operation operation;
  double lat;
  double lng;

  Shop({
    this.name,
    this.address,
    this.contact,
    this.description,
    this.operation,
    this.lat,
    this.lng,
    this.type,
  });
}
