import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/time_picker_formfield.dart';
import '../../model/address.dart';
import '../../model/contact.dart';
import '../../model/insert.dart';
import '../home_page/home.dart';
import '../../utils/constant.dart';
import '../../utils/image_service.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.provinceId, this.districtId}) : super(key: key);

  final String provinceId;

  final String districtId;
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
  final timeFormat = DateFormat("h:mm a");
  DateTime date;
  TimeOfDay opentime, closetime;

  Insert newInsert = new Insert();
  Contact newContact = new Contact();
  Address newAddress = new Address();

  Future<bool> _submitForm(String provinceId, String districtId) async {
    final FormState form = _formKey.currentState;
    form.save();
    //upload image
    String imgUrl = await onImageUploading(_image);

    await Firestore.instance.collection('store').document().setData({
      "name": newInsert.name,
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
        "lat": "",
        "lng": "",
      },
      "description": newInsert.description,
      "operation": {
        "open": opentime.format(context),
        "close": closetime.format(context)
      },
    });

    print('Name: ${newInsert.name}');
    print('Address: ${newAddress.detail}');
    print('MobilePhoneNumber: ${newContact.mobilePhoneNumber}');
    print('Description: ${newInsert.description}');
    print(opentime.format(context));
    print(closetime.format(context));
    print('Lat: ${newInsert.lat}');
    print('Lng: ${newInsert.lng}');
    print('Src: ${newInsert.src}');

    print('done');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constant.BK_COLOR,
        appBar: AppBar(
          backgroundColor: Constant.ORANGE_COLOR,
          centerTitle: true,
          title: Text('Add new shop'),
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
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
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
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
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
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
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
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
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
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'กรุณาป้อนละติจูด',
                            labelText: 'ละติจูด',
                            prefixIcon: const Icon(
                              Icons.location_on,
                            ),
                          ),
                        ),
                        buildSizedBox(),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'รุณาป้อนลองติจูด',
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
                              borderRadius: BorderRadius.circular(5),
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
        ));
  }

  SizedBox buildSizedBox() {
    return SizedBox(
      height: 13,
    );
  }
}
