import 'package:project_muk/src/model/province.dart';


class ProvinceViewModel {
  List<Province> menuItems;

  ProvinceViewModel({this.menuItems});

  List<Province> getItems() {
    return menuItems = <Province>[
      Province(
    name: "Joe",
    districtCount: 1,
    provinceKey: "111"
//        imagesTitleesTitle: "https://scontent.fbkk5-8.fna.fbcdn.net/v/t1.0-1/p480x480/71717552_2671324706252925_7524708378182942720_n.jpg?_nc_cat=106&_nc_oc=AQmCiui5GoWsev5ApeoOB2peZKALywALp0PR0AByxdbjwpiBNXqkX_7mkjkhuhjm2P4&_nc_ht=scontent.fbkk5-8.fna&oh=1fceebafd8de8381bb50fb4e0b5797c2&oe=5E35EDE5",
//        nameProvince: "กทม",
//        nameDistrict: ["อำเภอเมืองกำแพงเพชร1","อำเภอไทรงาม1","อำเภอคลองลาน1","อำเภอขาณุวรลักษบุรี1","อำเภอคลองขลุง1"],
//        nameShop: "Codemobiles1",
//        address: "บริษัท โค้ดโมบายส์ จำกัด (สำนักงานใหญ่)3761/104-105 ตรอกนอกเขต แขวงบางโคล่ เขตบางคอแหลม กรุงเทพมหานคร 10120 Tax ID: 0105553021528",
//        detail: "ทำช่วงล่างรถยนต์",
//        tel: "08888888888",
//        time: "09.00-16.00น.",
//        lat: "13.6969768",
//        lng: "100.5148331",
//      ),
//      Province(
//        imagesTitle: "https://scontent.fbkk5-8.fna.fbcdn.net/v/t1.0-1/p480x480/71717552_2671324706252925_7524708378182942720_n.jpg?_nc_cat=106&_nc_oc=AQmCiui5GoWsev5ApeoOB2peZKALywALp0PR0AByxdbjwpiBNXqkX_7mkjkhuhjm2P4&_nc_ht=scontent.fbkk5-8.fna&oh=1fceebafd8de8381bb50fb4e0b5797c2&oe=5E35EDE5",
//        nameProvince: "กำแพงเพชร",
//        nameDistrict: ["อำเภอเมืองกำแพงเพชร2","อำเภอไทรงาม2","อำเภอคลองลาน2","อำเภอขาณุวรลักษบุรี2","อำเภอคลองขลุง2"],
//        nameShop: "Codemobiles2",
//        address: "บริษัท โค้ดโมบายส์ จำกัด (สำนักงานใหญ่)3761/104-105 ตรอกนอกเขต แขวงบางโคล่ เขตบางคอแหลม กรุงเทพมหานคร 10120 Tax ID: 0105553021528",
//        detail: "ทำช่วงล่างรถยนต์",
//        tel: "0833333338",
//        time: "09.00-16.00น.",
//        lat: "13.6969768",
//        lng: "100.5148331",
//      ),
      )];
  }
}