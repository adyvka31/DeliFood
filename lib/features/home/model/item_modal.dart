import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemFoodModel {
  final String id;
  final String imagepath;
  final String title;
  final int price;
  final double rating;
  final String category;

  Color? bgColor = Color(0xffffffff);

  ItemFoodModel({
    required this.id,
    required this.imagepath,
    required this.title,
    required this.price,
    required this.rating,
    required this.category,
    this.bgColor,
  });

  factory ItemFoodModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ItemFoodModel(
      id: doc.id,
      imagepath: data['imagepath'] ?? 'assets/images/detail-food.png',
      title: data['name'] ?? '',
      price: data['price'] ?? 0,
      rating: (data['rating'] ?? 0.0).toDouble(),
      category: data['category'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': title,
      'imagepath': imagepath,
      'price': price,
      'rating':rating,
      'category': category,
    };
  }
}