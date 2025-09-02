import 'package:flutter/widgets.dart';

class ItemFoodModel {
  final String imagepath;
  final String title;
  final String price;
  Color? bgColor = Color(0xffffffff);

  ItemFoodModel({
    required this.imagepath,
    required this.title,
    required this.price,
    this.bgColor,
  });
}