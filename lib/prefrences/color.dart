import 'dart:ui';
import 'package:flutter/material.dart';

class MainColors {

  MainColors._();

  static const greyColor = MaterialColor(0XffF3F4F9, {
    200: Color(0xff86869E),
  });

  static const primaryColor = MaterialColor(0xff62E465, {
    400: Color(0xffF5F5F5),
    500: Color(0xffE0E0E0),
    600: Color(0xffCCCCCC),
    800: Color(0xffB8B8B8),
  });

  static const secondaryColor = MaterialColor(0xff047884, {
    400: Color(0xff62E465),
    500: Color(0xff4CD964),
    600: Color(0xff44C35A),
    800: Color(0xff329645),
  });

  static const accentColor = MaterialColor(0xFF4CD964, {
    200: Color(0xFF7CDB94),
    400: Color(0xFF60D47D),
    600: Color(0xFF44C35A),
    800: Color(0xFF329645),
  });

}