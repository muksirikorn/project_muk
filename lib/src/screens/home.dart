import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import '../theme/app_themes.dart';
import '../services/auth_service.dart';
import '../services/logging_service.dart';

import '../scoped_models/user.dart';
import 'province_serach.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {Key key, this.auth, this.userId, this.logoutCallback, this.userEmail})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final String userEmail;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() { 
    super.initState();
  }
  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<User>(
      builder: (BuildContext context, Widget child, User model) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: AppTheme.GG_COLOR,
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.directions_car, color: Colors.black)),
                  Tab(icon: Icon(Icons.directions_bike, color: Colors.black)),
                ],
              ),
              automaticallyImplyLeading: false,
              backgroundColor: AppTheme.GREEN_COLOR,
              title: Text('ร้านซ่อมรถ'),
              actions: <Widget>[
                FlatButton(
                    child: Icon(Icons.exit_to_app, color: Colors.white),
                    onPressed: signOut)
              ],
            ),
            body: TabBarView(
              children: [
                homeCar(),
                homeBike(),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              tooltip: 'ค้นหา',
              onPressed: () async {
                model.updateUserRole(widget.userEmail);
                showSearch(context: context, delegate: DataSearch());
              },
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              label: Text("ค้นหา", style: TextStyle(color: Colors.black)),
              backgroundColor: AppTheme.GREEN_COLOR,
            ),
          ),
        );
      },
    );
  }

  Widget dataView(String type) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('image')
            .where("type", isEqualTo: type)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                  child: Text('Loading...',
                      style: TextStyle(color: Colors.black)));
            default:
              return Container(
                  child: GridView.builder(
                      itemCount: snapshot.data.documents.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          child: Card(
                            elevation: 5.0,
                            child: Container(
                              alignment: Alignment.center,
                              child: Image.network(
                                snapshot.data.documents[index]['images'][0]
                                    ['src'],
                                width: 300,
                                height: 300,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        );
                      }));
          }
        });
  }

  Widget homeCar() {
    return dataView('car');
  }

  Widget homeBike() {
    return dataView('motorbike');
  }
}
