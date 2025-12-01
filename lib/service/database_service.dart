import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../features/home/model/item_modal.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<ItemFoodModel>> getProducts(String query) {
    Query ref = _db.collection('products');

    return ref.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ItemFoodModel.fromSnapshot(doc)).where((item) {
        return item.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> addToCart(ItemFoodModel item) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    final cartRef = _db.collection('users').doc(user.uid).collection('cart');

    await cartRef.add({
      ...item.toMap(),
      'quantity': 1,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }
}