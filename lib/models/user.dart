import 'dart:core';

import 'package:flutter_loopez/constants.dart';

class User {
  String _phoneNumber;
  String _someThingAboutYou;
  List<String> myAdsIds;

//  User({this.phoneNumber, this.someThingAboutYou});
  User({String phoneNumber, String someThingAboutYou})
      : _phoneNumber = phoneNumber,
        _someThingAboutYou = someThingAboutYou;

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String value) {
    _phoneNumber = '+92' + value;
  }

  Map<String, dynamic> userAsMap() {
    return {
      kPhoneNumber: _phoneNumber,
      kSomethingAboutYou: _someThingAboutYou,
      kIsPhoneNumberVerified: false
    };
  }

  String get someThingAboutYou => _someThingAboutYou;

  set someThingAboutYou(String value) {
    _someThingAboutYou = value;
  }
}
