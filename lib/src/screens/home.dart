import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/province.dart';
import '../services/constant.dart';
import '../services/algolia_services.dart';
import '../services/auth_services.dart';

import 'district.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Constant.GG_COLOR,
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car, color: Colors.black)),
              Tab(icon: Icon(Icons.directions_bike, color: Colors.black)),
            ],
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Constant.GREEN_COLOR,
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
          onPressed: () {
            showSearch(context: context, delegate: DataSearch());
          },
          icon: Icon(
            Icons.search,
            color: Colors.black,
          ),
          label: Text("ค้นหา", style: TextStyle(color: Colors.black)),
          backgroundColor: Constant.GREEN_COLOR,
        ),
      ),
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

class DataSearch extends SearchDelegate<String> {
  final algoliaService = AlogoliaService.instance;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Province>>(
      future: algoliaService.performProvinceSearch(text: query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final provinces = snapshot.data.map((province) {
            return Container(
              child: Center(
                  child: GestureDetector(
                child: Card(
                  color: Colors.orange[200],
                  child: Column(
                    children: <Widget>[
                      Row(children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(7.0),
                            child: Text(
                              province.name,
                              style: TextStyle(fontSize: 18.0),
                            )),
                      ]),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DistrictPage(
                            provinceName: province.name,
                            provinceId: province.documentID)),
                  );
                },
              )),
            );
          }).toList();

          return ListView(children: provinces);
        } else if (snapshot.hasError) {
          return Center(
            child: Text("${snapshot.error.toString()}"),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
