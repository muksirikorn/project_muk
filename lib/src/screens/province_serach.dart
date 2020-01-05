import 'package:flutter/material.dart';
import '../models/province.dart';
import '../services/algolia_services.dart';
import 'district.dart';

class DataSearch extends SearchDelegate<String> {
  final algoliaService = AlogoliaServices.instance;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
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