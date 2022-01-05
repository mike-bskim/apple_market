import 'package:apple_market/src/constants/keys.dart';
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
  }
}