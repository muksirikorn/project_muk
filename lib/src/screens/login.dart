import 'package:flutter/material.dart';
import 'package:project_muk/src/theme/app_themes.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/user.dart';
import '../services/auth_service.dart';
import '../services/logging_service.dart';

class LoginPage extends StatefulWidget {
  final BaseAuth auth;

  final VoidCallback loginCallback;
  LoginPage({
    Key key,
    this.auth,
    this.loginCallback,
  });

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<User>(
      builder: (BuildContext context, Widget child, User model) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              _showForm(),
              _showCircularProgress(),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Email',
          icon: const Icon(
            Icons.mail,
            color: AppTheme.GREY_COLOR,
          ),
        ),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Text(
        _errorMessage,
        style: TextStyle(
          fontSize: 13.0,
          color: AppTheme.RED_COLOR,
          height: 1.0,
          fontWeight: FontWeight.w300,
        ),
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return Hero(
      tag: 'hero',
      child: Container(
        width: 150,
        height: 300,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 48.0,
            child: Image.asset(
              'assets/images/car.png',
            ),
          ),
        ),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Password',
          icon: const Icon(
            Icons.lock,
            color: AppTheme.GREY_COLOR,
          ),
        ),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: RaisedButton(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: AppTheme.GREEN_COLOR,
          child: Text(
            _isLoginForm ? 'Login' : 'Create account',
            style: TextStyle(
              fontSize: 20.0,
              color: AppTheme.WHITE_COLOR,
            ),
          ),
          onPressed: validateAndSubmit,
        ),
      ),
    );
  }

  Widget showSecondaryButton() {
    return FlatButton(
      child: Text(
        _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w300,
        ),
      ),
      onPressed: toggleFormMode,
    );
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await widget.auth.signIn(_email, _password);
        } else {
          userId = await widget.auth.signUp(_email, _password);
          widget.auth.sendEmailVerification();
          _showVerifyEmailSentDialog();
        }
        setState(() {
          _isLoading = false;
        });
        if (userId.length > 0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        }
      } catch (e) {
        logger.e(e);
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showForm() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            showLogo(),
            showEmailInput(),
            showPasswordInput(),
            showPrimaryButton(),
            showSecondaryButton(),
            showErrorMessage(),
          ],
        ),
      ),
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Verify your account"),
          content:
              const Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            FlatButton(
              child: const Text("Dismiss"),
              onPressed: () {
                toggleFormMode();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
