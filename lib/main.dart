import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:project_muk/src/screens/home.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import './src/root.dart';
import './src/theme/app_themes.dart';
import './src/services/auth_service.dart';
import './src/scoped_models/user.dart';
import './src/services/service_locator.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await DotEnv().load('.env');
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  setupLocator();
  runApp(Home());
}

class Home extends StatelessWidget {
  final User _model = User();
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {
    return ScopedModel<User>(
      model: _model,
      child: MaterialApp(
        theme: AppTheme().appThemes(),
        debugShowCheckedModeBanner: false,
        title: "ค้นหาร้านซ่อมรถ",
        home: HomePage(),
        // home: Root(
        //   auth: AuthServices(),
        // ),
        navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
      ),
    );
  }
}
