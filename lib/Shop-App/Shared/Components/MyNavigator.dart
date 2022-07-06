import 'package:flutter/material.dart';

void NavigateTo(context,widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context)=> widget));
}

void NavigateAndFinish(context,widget) {
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context)=> widget),
          (Route<dynamic> route)=>false
  );
}// دي بستخدمها عشان لو عاوز مرجعش تاني لصفحه الاون بوردينج
