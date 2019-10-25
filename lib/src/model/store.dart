import 'address.dart';
import 'contact.dart';

class Store {
  String name;
  String description;
  Address address;
  Contact contact;
  String image;

  Store({this.name, this.address, this.contact, this.description, this.image});
}