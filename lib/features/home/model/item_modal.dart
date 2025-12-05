import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ItemFoodModel {
  final String id;
  final String imagepath;
  final String title;
  final int price;
  final double rating;
  final String category;
  final String description;

  ItemFoodModel({
    required this.id,
    required this.imagepath,
    required this.title,
    required this.price,
    this.rating = 0.0,
    this.category = 'General',
    this.description = '',
  });

  String get formattedPrice {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  // Convert Firebase Document to Dart Object
  factory ItemFoodModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ItemFoodModel(
      id: doc.id,
      title: data['title'] ?? '',
      price: (data['price'] is int)
          ? data['price']
          : int.tryParse(
                  data['price'].toString().replaceAll(RegExp(r'[^0-9]'), ''),
                ) ??
                0,
      imagepath: data['imagepath'] ?? 'assets/images/detail-food.png',
      rating: (data['rating'] ?? 0.0).toDouble(),
      category: data['category'] ?? 'General',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imagepath': imagepath,
      'price': price,
      'rating': rating,
      'category': category,
      'description': description,
    };
  }
}
