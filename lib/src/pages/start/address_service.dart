import 'package:apple_market/src/constants/keys.dart';
import 'package:apple_market/src/model/address_model.dart';
import 'package:apple_market/src/model/address_modelXY.dart';
import 'package:dio/dio.dart';
import 'package:apple_market/src/utils/logger.dart';
// import 'package:flutter/cupertino.dart';

class AddressService {
  // void dioTest() async {
  //   var resp = await Dio().get("https://randomuser.me/api/").catchError((e){
  //     logger.e(e.error);
  //   });
  //   logger.d('resp: [$resp]');
  // }

  // string -> json(이부분은 fltter에서 자동처리함) -> object
  Future<AddressModel> searchAddressByStr(String text) async {

    final formData = {
      'key':vWorldKey,
      'request':'search',
      'type':'ADDRESS',
      'category':'ROAD',
      'query':text,
      'size':30,
    };

    var resp = await Dio().get('http://api.vworld.kr/req/search', queryParameters: formData)
      .catchError((e){
        logger.e(e.message);
      });

    AddressModel addressModel = AddressModel.fromJson(resp.data['response']);

    return addressModel;
  }

  Future<List<AddressModelXY>> findAddressByCoordinate({required double log, required double lat}) async {

    List<Map<String, dynamic>> formData = <Map<String, dynamic>>[];

    for (var i=0; i<5; i++) {
      int x;
      int y;
      if (i==1){x = 0; y=1;}
      else if (i==2){x = 1; y=0;}
      else if (i==3){x = 0; y=-1;}
      else if (i==4){x = -1; y=0;}
      else {x = 0; y=0;}


      formData.add({
        'key':vWorldKey,
        'service':'address',
        'request':'getAddress',
        'type':'BOTH',
        'point':'${log+0.01*x},${lat+0.01*y}',
      });
    }
    // final formData = {
    //   'key':vWorldKey,
    //   'service':'address',
    //   'request':'getAddress',
    //   'type':'BOTH',
    //   'point':'$log,$lat',
    // };

    List<AddressModelXY> addressModelXYs = [];

    for(var data in formData) {
      var resp = await Dio().get('http://api.vworld.kr/req/address', queryParameters: data)
          .catchError((e){
        logger.e(e.message);
      });
      // logger.d('resp[response]: ${resp.data['response']}');
      // logger.d('resp[status]: ${resp.data['response']['status']}');

      AddressModelXY addressModelXY = AddressModelXY.fromJson(resp.data['response']);
      if(resp.data['response']['status'] == 'OK'){
        addressModelXYs.add(addressModelXY);
      }
    }
    logger.d('길이: ${addressModelXYs.length}');

    return addressModelXYs;
  }
}