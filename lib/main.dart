import 'package:flutter/material.dart';
import './src/root.dart';
import './src/screens/district.dart';
import './src/screens/home.dart';
import './src/screens/shop/shop_detail.dart';
import './src/screens/shop/shops_page.dart';
import './src/screens/login.dart';
import './src/screens/shop/new_shop_page.dart';
import './src/theme/app_themes.dart';
import './src/services/constant.dart';
import './src/services/auth_services.dart';

void main() {
  return runApp(Home());
}

class Home extends StatelessWidget {
  final _route = <String, WidgetBuilder>{
    Constant.HOME_ROUTE: (context) => HomePage(),
    Constant.DISTRICT_ROUTE: (context) => DistrictPage(),
    Constant.NAME_SHOP_ROUTE: (context) => ShopsPage(),
    Constant.LOCATION_DETAIL_ROUTE: (context) => ShopDetailPage(),
    Constant.LOGIN_ROUTE: (context) => LoginPage(),
    Constant.REIGTER_ROUTE: (context) => NewShopPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appThemes(),
      debugShowCheckedModeBanner: false,
      title: "ค้นหาร้านซ่อมรถ",
      routes: _route,
      home: Root(auth: AuthServices()),
    );
  }
}
