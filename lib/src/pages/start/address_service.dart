import 'package:apple_market/src/constants/keys.dart';
import 'package:apple_market/src/model/address_model.dart';
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
  void searchAddressByStr(String text) async {

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
    logger.d('resp: [$resp]');
    logger.d('resp.data is Map: [${resp.data is Map}]');

    AddressModel addressService = AddressModel.fromJson(resp.data['response']);
    logger.d('addressService: [$addressService]');
  }
}