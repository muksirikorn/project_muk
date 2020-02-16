import 'package:flutter/material.dart';
import './services/auth_service.dart';
import './screens/login.dart';
import './screens/home.dart';

enum AuthStatus {
  LOGGED_OUT,
  LOGGED_IN,
}

class Root extends StatefulWidget {
  Root({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => _RootState();
}

class _RootState extends State<Root> {
  AuthStatus authStatus = AuthStatus.LOGGED_OUT;
  String _userId = "";
  String _userEmail = "";
  String _currentState;

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.LOGGED_OUT : AuthStatus.LOGGED_IN;

        _currentState = user?.uid == null ? 'LOG_OUT' : 'LOG_IN';
      });
    });
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
        _userEmail = user.email;
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
      _currentState = 'LOG_IN';
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.LOGGED_OUT;
      _userId = "";
      _currentState = 'LOG_OUT';
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.LOGGED_OUT:
        return LoginPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return HomePage(
            userId: _userId,
            userEmail: _userEmail,
            auth: widget.auth,
            logoutCallback: logoutCallback,
            state: _currentState,
          );
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}
