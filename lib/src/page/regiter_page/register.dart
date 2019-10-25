import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_muk/src/model/address.dart';
import 'package:project_muk/src/model/contact.dart';
import 'package:project_muk/src/model/insert.dart';
import 'package:project_muk/src/utils/constant.dart';
import 'package:datetime_picker_formfield/time_picker_formfield.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  File _image;

  Future getImageFromCam() async {
    // for camera
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> _colors = <String>['', 'red', 'green', 'blue', 'orange'];
  String _color = '';
  final timeFormat = DateFormat("h:mm a");
  DateTime date;
  TimeOfDay opentime, closetime;

  Insert newInsert = new Insert();
  Contact newContact = new Contact();
  Address newAddress = new Address();

  Future<Null> _submitForm() async {
    final FormState form = _formKey.currentState;
    form.save();
    await Firestore.instance.collection('store').document().setData({
      "name": 'hi',
      "address": {
        "detail": newAddress.detail,
        "provicne_id": "hi",
        "districts_id": "hi",
      },
      "contact": {"mobilePhone": newContact.mobilePhoneNumber},
      "location": {
        "lat": "hi",
        "lng": "hi",
      },
      "description": newInsert.description,
      "operation": {"open": opentime, "close": closetime},
    });

    print('Name: ${newInsert.name}');
    print('Address: ${newAddress.detail}');
    print('MobilePhoneNumber: ${newContact.mobilePhoneNumber}');
    print('Description: ${newInsert.description}');
    print('OpenTime: ${opentime}');
    print('CloseTime: ${closetime}');
    print('Lat: ${newInsert.lat}');
    print('Lng: ${newInsert.lng}');
    print('Src: ${newInsert.src}');

    print('done');
    return Null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constant.BK_COLOR,
        appBar: AppBar(
          backgroundColor: Constant.ORANGE_COLOR,
          centerTitle: true,
          title: Text("login"),
        ),
        body: Form(
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
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(),
                            hintText: 'กรุณาป้อนชื่อร้าน',
                            labelText: 'ชื่อร้าน',
                            prefixIcon: const Icon(
                              Icons.store_mall_directory,
                            ),
                          ),
                          onSaved: (val) => newInsert.name = val,
                        ),
                        buildSizedBox(),
                        TextFormField(
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(),
                            hintText: 'กรุณาป้อนที่อยู่',
                            labelText: 'ที่อยู่',
                            prefixIcon: const Icon(
                              Icons.home,
                            ),
                          ),
                          onSaved: (val) => newAddress.detail = val,
                        ),
                        buildSizedBox(),
                        TextFormField(
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(),
                            hintText: 'กรุณาป้อนเบอร์โทรศัพท์',
                            labelText: 'เบอร์โทรศัพท์',
                            prefixIcon: const Icon(
                              Icons.phone,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (val) => newContact.mobilePhoneNumber = val,
                        ),
                        buildSizedBox(),
                        TextFormField(
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(),
                            hintText: 'กรุณาป้อนรายละเอียดร้าน',
                            labelText: 'รายละเอียดร้าน',
                            prefixIcon: const Icon(
                              Icons.library_books,
                            ),
                          ),
                          onSaved: (val) => newInsert.description = val,
                        ),
                        buildSizedBox(),
                        TimePickerFormField(
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
                        TextFormField(
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(),
                            hintText: 'กรุณา�����้อนละติจูด',
                            labelText: 'ละติจูด',
                            prefixIcon: const Icon(
                              Icons.location_on,
                            ),
                          ),
                        ),
                        buildSizedBox(),
                        TextFormField(
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(),
                            hintText: 'กรุณาป้อ���ลองติจูด',
                            labelText: 'ลองติจูด',
                            prefixIcon: const Icon(
                              Icons.location_on,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 100.0,
                              width: 130.0,
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
                            color: Color(0xFFD56343),
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
                            onPressed: () {
                              _submitForm();
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
        ));
  }

  SizedBox buildSizedBox() {
    return SizedBox(
      height: 13,
    );
  }
}
