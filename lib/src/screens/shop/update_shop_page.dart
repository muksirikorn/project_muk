import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/time_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:project_muk/src/components/shared_components.dart';
import 'package:project_muk/src/models/address.dart';
import 'package:project_muk/src/models/contact.dart';
import 'package:project_muk/src/models/store.dart';
import 'package:project_muk/src/services/image_service.dart';
import 'package:project_muk/src/services/logging_service.dart';
import 'package:project_muk/src/theme/app_themes.dart';

class UpdateShopPage extends StatefulWidget {
  final String docID;

  final String provinceId;
  final String districtId;
  UpdateShopPage({
    Key key,
    this.docID,
    this.provinceId,
    this.districtId,
  }) : super(key: key);

  @override
  _UpdateShopPageState createState() => _UpdateShopPageState();
}

class _UpdateShopPageState extends State<UpdateShopPage> {
  File _image;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final timeFormat = DateFormat.Hm();
  Geoflutterfire geo = Geoflutterfire();
  final Firestore databaseReference = Firestore.instance;

  DateTime date;
  TimeOfDay opentime, closetime;

  Shop newShop = Shop();
  Contact newContact = Contact();
  Address newAddress = Address();

  LocationData startLocation;
  LocationData _currentLocation;

  StreamSubscription<LocationData> _locationSubscription;

  Location _locationService = Location();
  bool _permission = false;
  String error;

  bool currentWidget = true;

  int _radioValue1 = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.GG_COLOR,
      appBar: AppBar(
        backgroundColor: AppTheme.GREEN_COLOR,
        centerTitle: true,
        title: Text('อัพเดทร้านซ่อมรถ'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('store')
            .document(widget.docID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text("Loading"));
          }
          var document = snapshot.data;
          var _openHour = document['operation']['open'].split(":")[0];
          var _openMinute = document['operation']['open'].split(":")[1];
          TimeOfDay _openTime = TimeOfDay(
            hour: int.parse(_openHour),
            minute: int.parse(_openMinute.split(" ")[0]),
          );

          var _closeHour = document['operation']['close'].split(":")[0];
          var _closeMinute = document['operation']['close'].split(":")[1];
          TimeOfDay _closeTime = TimeOfDay(
            hour: int.parse(_closeHour),
            minute: int.parse(_closeMinute.split(" ")[0]),
          );
          return Form(
            key: _formKey,
            autovalidate: true,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            initialValue: document['name'],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'กรุณาป้อนชื่อร้าน',
                              labelText: 'ชื่อร้าน',
                              prefixIcon: const Icon(
                                Icons.store_mall_directory,
                              ),
                            ),
                            onSaved: (val) => newShop.name = val.trim(),
                          ),
                          buildSizedBox(),
                          TextFormField(
                            initialValue: document['address']['detail'],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'กรุณาป้อนที่อยู่',
                              labelText: 'ที่อยู่',
                              prefixIcon: const Icon(
                                Icons.home,
                              ),
                            ),
                            onSaved: (val) => newAddress.detail = val.trim(),
                          ),
                          buildSizedBox(),
                          TextFormField(
                            initialValue: document['contact']['mobilePhone'],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'กรุณาป้อนเบอร์โทรศัพท์',
                              labelText: 'เบอร์โทรศัพท์',
                              prefixIcon: const Icon(
                                Icons.phone,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (val) =>
                                newContact.mobilePhoneNumber = val.trim(),
                          ),
                          buildSizedBox(),
                          TextFormField(
                            initialValue: document['description'],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'กรุณาป้อนรายละเอียดร้าน',
                              labelText: 'รายละเอียดร้าน',
                              prefixIcon: const Icon(
                                Icons.library_books,
                              ),
                            ),
                            onSaved: (val) => newShop.description = val.trim(),
                          ),
                          buildSizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Radio(
                                value: 0,
                                groupValue: _radioValue1,
                                onChanged: _handleRadioValueChange1,
                              ),
                              const Text(
                                'อู่รถยนต์',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Radio(
                                value: 1,
                                groupValue: _radioValue1,
                                onChanged: _handleRadioValueChange1,
                              ),
                              const Text(
                                'อู่มอเตอร์ไซด์',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                          buildSizedBox(),
                          TimePickerFormField(
                            initialValue: _openTime,
                            format: timeFormat,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'เวลาเปิด',
                                prefixIcon: const Icon(
                                  Icons.access_time,
                                )),
                            onChanged: (t) => setState(() => opentime = t),
                          ),
                          buildSizedBox(),
                          TimePickerFormField(
                            initialValue: _closeTime,
                            format: timeFormat,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'เวลาปิด',
                                prefixIcon: const Icon(
                                  Icons.access_time,
                                )),
                            onChanged: (t) => setState(() => closetime = t),
                          ),
                          buildSizedBox(),
                          FlatButton(
                            child: Center(
                              child: const Text(
                                'เรียกตำแหน่งที่ตั้ง',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            color: AppTheme.ORANGE_COLOR_200,
                            onPressed: () async {
                              await _initPlatformState();
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                height: 200.0,
                                width: 200.0,
                                child: Center(
                                  child: document['images'][0]['src'] == null
                                      ? const Text('No Image')
                                      : Image.network(
                                          document['images'][0]['src'],
                                        ),
                                ),
                              ),
                            ],
                          ),
                          FlatButton(
                            onPressed: getImageFromCam,
                            color: AppTheme.BLUE_COLOR_200,
                            child: Center(
                              child: const Text(
                                'เลือกรูปภาพ',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 200.0,
                                width: 200.0,
                                child: Center(
                                  child: _image == null
                                      ? const Text('กรุณาเลือกรูปภาพ')
                                      : Image.file(_image),
                                ),
                              ),
                            ],
                          ),
                          buildSizedBox(),
                          Container(
                            height: 50,
                            width: double.infinity,
                            child: RaisedButton(
                              color: AppTheme.GREEN_COLOR,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                "ยืนยัน",
                                style: TextStyle(
                                  color: AppTheme.WHITE_COLOR,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () async {
                                showProcessingDialog(context);
                                bool done = await _submitForm(
                                  widget.provinceId,
                                  widget.districtId,
                                );
                                Navigator.pop(context);
                                done
                                    ? Navigator.pop(context)
                                    : Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> getImageFromCam() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;

      switch (_radioValue1) {
        case 0:
          newShop.type = 'car';
          break;
        case 1:
          newShop.type = 'bike';
          break;
      }
    });
  }

  Future _initPlatformState() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 1000);

    LocationData location;
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        if (_permission) {
          location = await _locationService.getLocation();
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        if (serviceStatusResult) {
          await _initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      location = null;
    }

    setState(() {
      startLocation = location;
    });
  }

  Future<bool> _submitForm(String provinceId, String districtId) async {
    bool complete = false;
    final FormState form = _formKey.currentState;
    form.save();
    String imgUrl = await ImageServices().onImageUploading(_image);
    GeoFirePoint shopLocation = geo.point(
      latitude: startLocation.latitude,
      longitude: startLocation.longitude,
    );

    Map<String, dynamic> data = {
      'name': newShop.name,
      'address': {
        'detail': newAddress.detail,
        'provicne_id': provinceId,
        'districts_id': districtId,
      },
      'images': [
        {'src': imgUrl}
      ],
      'contact': {
        'mobilePhone': newContact.mobilePhoneNumber,
      },
      'location': shopLocation.data,
      'description': newShop.description,
      'type': newShop.type,
      'operation': {
        'open': opentime.format(context),
        'close': closetime.format(context)
      },
      'updatedAt': DateTime.now().millisecondsSinceEpoch
    };

    try {
      await databaseReference
          .collection('store')
          .document(widget.docID)
          .updateData(data);
      complete = true;
    } catch (e) {
      logger.e(e);
    }

    return complete;
  }
}
