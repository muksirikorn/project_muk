import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/time_picker_formfield.dart';
import 'package:location/location.dart';

import '../../models/store.dart';
import '../../models/address.dart';
import '../../models/contact.dart';
import '../../services/constant.dart';
import '../../services/image_service.dart';

import '../home.dart';
import '../../components/shared_components.dart';

class UpdateShopPage extends StatefulWidget {
  UpdateShopPage({Key key, this.docID, this.provinceId, this.districtId})
      : super(key: key);

  final String docID;
  final String provinceId;
  final String districtId;
  @override
  _UpdateShopPageState createState() => _UpdateShopPageState();
}

class _UpdateShopPageState extends State<UpdateShopPage> {
  File _image;

  Future getImageFromCam() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final timeFormat = DateFormat.Hm();
  DateTime date;
  TimeOfDay opentime, closetime;

  Shop newShop = new Shop();
  Contact newContact = new Contact();
  Address newAddress = new Address();

  LocationData _startLocation;
  LocationData _currentLocation;

  StreamSubscription<LocationData> _locationSubscription;

  Location _locationService = Location();
  bool _permission = false;
  String error;

  bool currentWidget = true;

  int _radioValue1 = -1;

  @override
  void initState() {
    super.initState();

    _initPlatformState();
  }

  _initPlatformState() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 1000);

    LocationData location;
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
        if (_permission) {
          location = await _locationService.getLocation();

          _locationSubscription = _locationService
              .onLocationChanged()
              .listen((LocationData result) async {
            setState(() {
              _currentLocation = result;
            });
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          _initPlatformState();
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
      _startLocation = location;
    });
  }

  Future<bool> _submitForm(String provinceId, String districtId) async {
    final FormState form = _formKey.currentState;
    form.save();
    //upload image
    String imgUrl = await onImageUploading(_image);

    await Firestore.instance
        .collection('store')
        .document(widget.docID)
        .updateData({
      "name": newShop.name,
      "address": {
        "detail": newAddress.detail,
        "provicne_id": provinceId,
        "districts_id": districtId,
      },
      "images": [
        {"src": imgUrl}
      ],
      "contact": {"mobilePhone": newContact.mobilePhoneNumber},
      "location": {
        "lat": _currentLocation.latitude,
        "lng": _currentLocation.longitude,
      },
      "description": newShop.description,
      "type": newShop.type,
      "operation": {
        "open": opentime.format(context),
        "close": closetime.format(context)
      },
    });

    print('Name: ${newShop.name}');
    print('Address: ${newAddress.detail}');
    print('MobilePhoneNumber: ${newContact.mobilePhoneNumber}');
    print('Description: ${newShop.description}');
    print(opentime.format(context));
    print(closetime.format(context));
    print('Lat: ${_currentLocation.latitude}');
    print('Lng: ${_currentLocation.longitude}');
    print('Src: ${imgUrl}');

    return true;
  }

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;

      switch (_radioValue1) {
        case 0:
          newShop.type = 'car';
          print('select car');
          break;
        case 1:
          newShop.type = 'bike';
          print('select bike');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constant.GG_COLOR,
        appBar: AppBar(
          backgroundColor: Constant.GREEN_COLOR,
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
                return Text("Loading");
              }
              var document = snapshot.data;
              var _openHour = document['operation']['open'].split(":")[0];
              var _openMinute = document['operation']['open'].split(":")[1];
              TimeOfDay _openTime = TimeOfDay(
                hour: int.parse(_openHour),
                minute: int.parse(_openMinute),
              );

              var _closeHour = document['operation']['close'].split(":")[0];
              var _closeMinute = document['operation']['close'].split(":")[1];
              TimeOfDay _closeTime = TimeOfDay(
                hour: int.parse(_closeHour),
                minute: int.parse(_closeMinute),
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
                                onSaved: (val) => newShop.name = val,
                              ),
                              buildSizedBox(),
                              TextFormField(
                                initialValue: document['address']['detail'],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'กรุณาป้อนที่อยู่',
                                  labelText: '���อยู่',
                                  prefixIcon: const Icon(
                                    Icons.home,
                                  ),
                                ),
                                onSaved: (val) => newAddress.detail = val,
                              ),
                              buildSizedBox(),
                              TextFormField(
                                initialValue: document['contact']
                                    ['mobilePhone'],
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
                                    newContact.mobilePhoneNumber = val,
                              ),
                              buildSizedBox(),
                              TextFormField(
                                initialValue: document['description'],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'กรุณาป้อนรายละเ���ยดร้าน',
                                  labelText: 'รายละเอียดร้าน',
                                  prefixIcon: const Icon(
                                    Icons.library_books,
                                  ),
                                ),
                                onSaved: (val) => newShop.description = val,
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
                                    Text(
                                      'อู่รถยนต์',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    Radio(
                                      value: 1,
                                      groupValue: _radioValue1,
                                      onChanged: _handleRadioValueChange1,
                                    ),
                                    Text(
                                      'อู่มอเตอร์ไซด์',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ]),
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
                              RaisedButton(
                                  child: Text('เรียกตำแหน่งที่ตั้ง',
                                      style: TextStyle(fontSize: 28)),
                                  color: Colors.orange[200],
                                  onPressed: () {
                                    _initPlatformState();
                                  }),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    height: 200.0,
                                    width: 200.0,
                                    child: Center(
                                      child:
                                          document['images'][0]['src'] == null
                                              ? Text('No Image')
                                              : Image.network(
                                                  document['images'][0]['src']),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 200.0,
                                    width: 200.0,
                                    child: Center(
                                      child: _image == null
                                          ? Text('กรุณาเลือกรูปภาพ')
                                          : Image.file(_image),
                                    ),
                                  ),
                                  FloatingActionButton(
                                    onPressed: getImageFromCam,
                                    tooltip: 'Pick Image',
                                    child: Icon(
                                      Icons.add_a_photo,
                                    ),
                                  ),
                                ],
                              ),
                              buildSizedBox(),
                              Container(
                                height: 50,
                                width: double.infinity,
                                child: RaisedButton(
                                  color: Color(0xFF4CAF50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    "ยืนยัน",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () async {
                                    bool done = await _submitForm(
                                        widget.provinceId, widget.districtId);
                                    if (done) {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return HomePage();
                                      }));
                                    }
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
            }));
  }
}
