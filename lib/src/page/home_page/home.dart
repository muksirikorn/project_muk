import 'package:flutter/material.dart';
import 'package:project_muk/src/utils/constant.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.BK_COLOR, //set color
      appBar: AppBar(
        bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
        automaticallyImplyLeading: false,
        backgroundColor: Constant.ORANGE_COLOR,
        title: Text('ร้านซ่อมรถ'),
        actions: <Widget>[
          const Icon(Icons.exit_to_app),
        onPressed: () {
            Navigator.pushNamed(context, Constant.LOGINPAGE_ROUTE);
                      },
                    ,
        ],
      ),

       body: new GridView.count(
        crossAxisCount: 2,
        children: new List<Widget>.generate(16, (index) {
          return new GridTile(
            child: new Card(
              color: Colors.white,
              child: new Center(
                child: new Text(''),
              )
            ),
          );
        }),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Column(
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 100,
                    child: RaisedButton(
                      color: Color(0xFFD56343), //set color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        "ค้นหา",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, Constant.PROVINCE_ROUTE);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
