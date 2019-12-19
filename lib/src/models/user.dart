import 'package:scoped_model/scoped_model.dart';

class User extends Model {
  String username;
  String email;
  String _role;
  String token;

  String get role {
    return _role;
  }

  void updateUserRole(String email) {
    print(email);
   if (email == 'mukmind369@gmail.com') {
      _role = 'ADMIN';
    } else {
      _role = 'USER';
    }
    notifyListeners();
  }
}
