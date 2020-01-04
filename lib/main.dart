import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './src/root.dart';
import './src/theme/app_themes.dart';
import './src/services/auth_services.dart';
import './src/scoped_models/user.dart';

Future main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await DotEnv().load('.env');
  runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User _model = User();
    return ScopedModel<User>(
      model: _model,
      child: MaterialApp(
        theme: appThemes(),
        debugShowCheckedModeBanner: false,
        title: "ค้นหาร้านซ่อมรถ",
        home: Root(
          auth: AuthServices(),
        ),
      ),
    );
  }
}
