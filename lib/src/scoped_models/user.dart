import 'package:scoped_model/scoped_model.dart';

class User extends Model {
  String username;
  String email;
  String role;
  String token;

  User({this.username, this.email, this.role, this.token});

  String get userRole {
    return role;
  }

  String get userToken {
    return token;
  }

  void updateUserRole(String email) {
    if (email == 'mukmind369@gmail.com') {
      role = 'ADMIN';
    } else {
      role = 'USER';
    }
    notifyListeners();
  }
}
