import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_muk/src/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
            RaisedButton(
              color: Constant.ORANGE_COLOR,
              child: const Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.pop(context);
              },
            )
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
            Navigator.pushNamed(context, Constant.PROVINCE_ROUTE);
          },
          icon: Icon(Icons.search),
          label: Text("ค้นหา"),
          backgroundColor: Constant.ORANGE_COLOR,
        ),
      ),
    );
  }

  Widget homeCar() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('store').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                  child: Text('Loading...',
                      style: TextStyle(color: Colors.white)));
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
                          onTap: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              child: CupertinoAlertDialog(
                                title: Column(
                                  children: <Widget>[
                                    Text("GridView"),
                                    Icon(
                                      Icons.favorite,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                                content: Text("Selected Item $index"),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("OK"))
                                ],
                              ),
                            );
                          },
                        );
                      }));
          }
        });
  }

  Widget homeBike() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}
