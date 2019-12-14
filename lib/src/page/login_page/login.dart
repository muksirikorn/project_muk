import 'package:flutter/material.dart';
import 'package:project_muk/src/utils/constant.dart';
import 'package:project_muk/src/utils/custom_simple_dialog.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.BK_COLOR,
      body: Center(
        child: Card(
          color: Colors.white,
          margin: EdgeInsets.only(left: 40, right: 40),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    Constant.IMAGE_CAR,
                    width: 400,
                  ),
                  buildUsernameTextFormField(),
                  buildPasswordTextFormField(),
                  buildLoginContainer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoginContainer() {
    return Container(
      margin: EdgeInsets.only(top: 32),
      width: double.infinity,
      child: RaisedButton(
        color: Constant.PRIMARY_COLOR,
        splashColor: Colors.green,
        child: Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () async {
          Navigator.pushNamed(context, Constant.HOME_ROUTE);
        },
      ),
    );
  }

  TextFormField buildPasswordTextFormField() {
    return TextFormField(
      onSaved: (String value) {},
      obscureText: true,
      decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
          ),
          labelText: "Password"),
    );
  }

  TextFormField buildUsernameTextFormField() {
    return TextFormField(
      onSaved: (String value) {},
      decoration: InputDecoration(
          icon: Icon(
            Icons.person,
          ),
          // hintText: "example@gmail.com",
          labelText: "Username"),
    );
  }

  void showAlertDialog({String title, String content}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomSimpleDialog(
          title: title,
          content: content,
          onPress: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
