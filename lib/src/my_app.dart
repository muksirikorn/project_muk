
import 'package:project_muk/src/page/district_page/district.dart';
import 'package:project_muk/src/page/home_page/home.dart';
import 'package:flutter/material.dart';
import 'package:project_muk/src/page/location_detali_page/location_detail.dart';
import 'package:project_muk/src/page/login_page/login.dart';
import 'package:project_muk/src/page/name_shop_page/nameshop.dart';
import 'package:project_muk/src/page/province_page/province.dart';
import 'package:project_muk/src/page/regiter_page/register.dart';
import 'package:project_muk/src/themes/app_themes.dart';
import 'package:project_muk/src/utils/constant.dart';


class MyApp extends StatelessWidget {
  final _route = <String, WidgetBuilder>{
    Constant.HOME_ROUTE: (context) => HomePage(),
    Constant.PROVINCE_ROUTE: (context) => ProvincePage(),
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
      home: HomePage(),
    );
  }
}

