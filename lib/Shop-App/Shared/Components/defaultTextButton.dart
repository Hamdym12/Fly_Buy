
import 'package:flutter/material.dart';

Widget defaultTextButton({
  required VoidCallback? onPressed,
  required Text? text,
})=> TextButton(
onPressed:onPressed ,
child:text!,
);