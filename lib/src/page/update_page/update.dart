import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_muk/src/model/address.dart';
import 'package:project_muk/src/model/contact.dart';
import 'package:project_muk/src/model/insert.dart';
import 'package:project_muk/src/page/home_page/home.dart';
import 'package:project_muk/src/utils/constant.dart';
import 'package:datetime_picker_formfield/time_picker_formfield.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdatePage extends StatefulWidget {
  UpdatePage({Key key, this.docID, this.provinceId, this.districtId})
      : super(key: key);

  final String docID;
  final String provinceId;
  final String districtId;
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  File _image;

  Future getImageFromCam() async {
    // for camera
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  Future<String> onImageUploading(File imagePath) async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('${Uuid().v1()}.png');
    final StorageUploadTask task = firebaseStorageRef.putFile(imagePath);
    StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
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

    await Firestore.instance
        .collection('store')
        .document(widget.docID)
        .updateData({
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
    print(widget.provinceId);
    print(widget.districtId);
    return Scaffold(
        backgroundColor: Constant.BK_COLOR,
        appBar: AppBar(
          backgroundColor: Constant.ORANGE_COLOR,
          centerTitle: true,
          title: Text('Update shop'),
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
                                initialValue: document['address']['detail'],
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
                                initialValue: document['contact']
                                    ['mobilePhone'],
                                decoration: new InputDecoration(
                                  border: new OutlineInputBorder(),
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
                                decoration: new InputDecoration(
                                  border: new OutlineInputBorder(),
                                  hintText: 'กรุณาป้อนรายละเ���ยดร้าน',
                                  labelText: 'รายละเอียดร้าน',
                                  prefixIcon: const Icon(
                                    Icons.library_books,
                                  ),
                                ),
                                onSaved: (val) => newInsert.description = val,
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
                              TextFormField(
                                initialValue: document['location']['lat'],
                                decoration: new InputDecoration(
                                  border: new OutlineInputBorder(),
                                  hintText: 'กรุณาป้อนละติจูด',
                                  labelText: 'ละติจูด',
                                  prefixIcon: const Icon(
                                    Icons.location_on,
                                  ),
                                ),
                              ),
                              buildSizedBox(),
                              TextFormField(
                                initialValue: document['location']['lng'],
                                decoration: new InputDecoration(
                                  border: new OutlineInputBorder(),
                                  hintText: 'กรุณาป้อนลองติจูด',
                                  labelText: 'ลองติจูด',
                                  prefixIcon: const Icon(
                                    Icons.location_on,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                  //  Container(
                                  //   height: 100.0,
                                  //   width: 130.0,
                                  //   child: Center(
                                  //     initialValue: document['images']['0']['src'],
                                  //     child: _image == null
                                  //         ? Text('กรุณาเลือกรูปภาพ')
                                  //         : Image.file(_image),
                                  //   ),
                                  // ),
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

  SizedBox buildSizedBox() {
    return SizedBox(
      height: 13,
    );
  }
}
