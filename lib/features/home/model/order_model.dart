import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrderModel {
  final String id;
  final List<Map<String, dynamic>> items;
  final int totalPrice;
  final String status; // 'Placed', 'Preparing', 'Shipped', 'Delivered'
  final List<Map<String, dynamic>> timeline; // Riwayat status
  final DateTime orderDate;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.timeline,
    required this.orderDate,
  });

  // Helper untuk format harga
  String get formattedPrice {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(totalPrice);
  }

  // Convert dari Firebase ke Object Dart
  factory OrderModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      items: List<Map<String, dynamic>>.from(data['items'] ?? []),
      totalPrice: data['total_price'] ?? 0,
      status: data['status'] ?? 'Placed',
      timeline: List<Map<String, dynamic>>.from(data['timeline'] ?? []),
      orderDate: (data['order_date'] as Timestamp).toDate(),
    );
  }
}