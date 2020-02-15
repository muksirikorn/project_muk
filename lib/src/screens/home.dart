import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_muk/src/root.dart';
import 'package:project_muk/src/scoped_models/user.dart';
import 'package:project_muk/src/screens/nearby_page.dart';
import 'package:project_muk/src/screens/province_serach.dart';
import 'package:project_muk/src/services/auth_service.dart';
import 'package:project_muk/src/services/logging_service.dart';
import 'package:project_muk/src/theme/app_themes.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  final BaseAuth auth;

  final VoidCallback logoutCallback;
  final String userId;
  final String userEmail;
  final String state;
  const HomePage({
    Key key,
    this.auth,
    this.userId,
    this.logoutCallback,
    this.userEmail,
    this.state,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Firestore _firestore = Firestore.instance;
  GoogleMapController mapController;
  Geoflutterfire geo = Geoflutterfire();
  Stream<List<DocumentSnapshot>> stream;
  GeoFirePoint center;
  String error;
  var collectionReference;

  List<Widget> bikeList = [];
  List<Widget> carList = [];

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
                  Tab(
                    icon: const Icon(
                      Icons.directions_car,
                      color: AppTheme.BLACK_COLOR,
                    ),
                  ),
                  Tab(
                    icon: const Icon(
                      Icons.directions_bike,
                      color: AppTheme.BLACK_COLOR,
                    ),
                  ),
                ],
              ),
              automaticallyImplyLeading: false,
              backgroundColor: AppTheme.GREEN_COLOR,
              title: const Text('ร้านซ่อมรถ'),
              actions: <Widget>[
                FlatButton(
                  child: const Icon(
                    Icons.near_me,
                    color: AppTheme.WHITE_COLOR,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Nearby(),
                    ),
                  ),
                ),
                widget.state == 'LOG_IN'
                    ? FlatButton(
                        child: Icon(
                          Icons.exit_to_app,
                          color: AppTheme.WHITE_COLOR,
                        ),
                        onPressed: () => {
                          signOut(),
                        },
                      )
                    : FlatButton(
                        child: Icon(
                          Icons.person,
                          color: AppTheme.WHITE_COLOR,
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Root(
                              auth: AuthServices(),
                            ),
                          ),
                        ),
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
              onPressed: () async {
                model.updateUserRole(widget.userEmail);
                showSearch(
                  context: context,
                  delegate: DataSearch(),
                );
                // signOut();
              },
              icon: Icon(
                Icons.search,
                color: AppTheme.BLACK_COLOR,
              ),
              label: const Text(
                "ค้นหา",
                style: TextStyle(
                  color: AppTheme.BLACK_COLOR,
                ),
              ),
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
          .collection('store')
          .where("type", isEqualTo: type)
          // add where lat lng query here
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          default:
            if (snapshot.hasData) {
              return Container(
                child: GridView.builder(
                  itemCount: snapshot.data.documents.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: Card(
                        elevation: 5.0,
                        child: Container(
                          alignment: Alignment.center,
                          child: Image.network(
                            snapshot.data.documents[index]['images'][0]['src'],
                            width: 300,
                            height: 300,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return SnackBar(
                content: Text(
                  snapshot.error.toString(),
                ),
              );
            }
            break;
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget homeBike() {
    return dataView('bike');
    // print(bikeList);
    // return Container(
    //   child: GridView.count(
    //     crossAxisCount: 2,
    //     padding: EdgeInsets.all(8.0),
    //     crossAxisSpacing: 8.0,
    //     mainAxisSpacing: 5.0,
    //     children: bikeList.map((data) => data).toList(),
    //   ),
    // );
  }

  Widget homeCar() {
    return dataView('car');
    // print(carList);
    // return Container(
    //   child: GridView.count(
    //     crossAxisCount: 2,
    //     padding: EdgeInsets.all(8.0),
    //     crossAxisSpacing: 8.0,
    //     mainAxisSpacing: 5.0,
    //     children: carList.map((data) => data).toList(),
    //   ),
    // );
  }

  @override
  void initState() {
    super.initState();
    loadData('car');
    loadData('bike');
  }

  void loadData(String type) {
    collectionReference =
        _firestore.collection('store').where("type", isEqualTo: type);

    Stream<List<DocumentSnapshot>> stream =
        geo.collection(collectionRef: collectionReference).within(
              center: geo.point(latitude: 13.7828896, longitude: 100.5661049),
              radius: 50,
              field: 'location',
              strictMode: true,
            );

    stream.listen((List<DocumentSnapshot> documentList) {
      documentList.forEach((DocumentSnapshot document) {
        _addGrid(document, type);
      });
    });
  }

  void signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      logger.e(e);
    }
  }

  Widget toggleIcon() {
    return Container();
  }

  void _addGrid(DocumentSnapshot document, String type) {
    GeoPoint point = document.data['location']['geopoint'];
    print(point.latitude);
    var _marker = GestureDetector(
      child: Card(
        elevation: 5.0,
        child: Container(
          alignment: Alignment.center,
          child: Image.network(
            document.data['images'][0]['src'],
            width: 300,
            height: 300,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
    setState(() {
      if (type == 'car') {
        carList.add(_marker);
      } else {
        bikeList.add(_marker);
      }
    });
  }
}
