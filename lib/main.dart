import 'package:flutter/material.dart';
import './src/page/district_page/district.dart';
import './src/page/home_page/home.dart';
import './src/page/location_detali_page/location_detail.dart';
import './src/page/login_page/login.dart';
import './src/page/name_shop_page/nameshop.dart';
import './src/page/register_page/register.dart';
import './src/themes/app_themes.dart';
import './src/utils/constant.dart';

void main() {
  return runApp(Home());
}

class Home extends StatelessWidget {
  final _route = <String, WidgetBuilder>{
    Constant.HOME_ROUTE: (context) => HomePage(),
    Constant.DISTRICT_ROUTE: (context) => DistrictPage(),
    Constant.NAME_SHOP_ROUTE: (context) => NameShopPage(),
    Constant.LOCATION_DETAIL_ROUTE: (context) => LocationDetailPage(),
    Constant.LOGIN_ROUTE: (context) => LoginPage(),
    Constant.REIGTER_ROUTE: (context) => RegisterPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appThemes(),
      debugShowCheckedModeBanner: false,
      title: "ค้นหาร้านซ่อมรถ",
      routes: _route,
      home: LoginPage(),
    );
  }
}
