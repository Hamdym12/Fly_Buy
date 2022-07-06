//POST
//UPDATE
//DELETE
//GET
//base_url(endpoints):'https://student.valuxapps.com/api/'

import 'package:flutter/cupertino.dart';
import 'package:shop_app/Shop-App/Log-In/LogInScreen.dart';
import 'package:shop_app/Shop-App/Shared/Components/MyNavigator.dart';
import 'package:shop_app/Shop-App/network/local/Cash_Helper.dart';

void signOut(context){//used signOut and remove token then navigate to loginScreen
  CacheHelper.removeData(key: 'token').then((value) {
    if (value) {
      NavigateAndFinish(context, ShopLoginScreen());
    }
  });
}

void printFullText(String text){//الميثود دي بستخدمها لو عاوز اطبع التيكست اللي هيرجعلي من المودل كله
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

String? token;