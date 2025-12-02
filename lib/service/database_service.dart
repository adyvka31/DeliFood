import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../features/home/model/item_modal.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Ambil Stream Produk (Mendukung Search)
  Stream<List<ItemFoodModel>> getProducts(String query) {
    Query ref = _db.collection('products');

    return ref.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ItemFoodModel.fromSnapshot(doc)).where((item) {
        return item.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  // Tmbahkan ke Cart
  Future<void> addToCart(ItemFoodModel item) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    final cartRef = _db.collection('users').doc(user.uid).collection('cart');

    // Cek apakah barang sudah ada, jika ada tambah quantity (logic opsional)
    // Di sini kita tambah baru aja
    await cartRef.add({
      ...item.toMap(),
      'quantity': 1,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  // Ambil Data Cart
  Stream<QuerySnapshot> getCart() {
    User? user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    return _db.collection('users').doc(user.uid).collection('cart').snapshots();
  }

  // Hapus Dari Cart
  Future<void> removeFromCart(String docId) async {
    User? user = _auth.currentUser;
    if (user == null) return;
    await _db.collection('users').doc(user.uid).collection('cart').doc(docId).delete();
  }

  // Checkout (beli semua)
  Future<void> checkout(int totalPrice) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    // Pindahkan item dari cart ke orders
    var cartSnapshot = await _db.collection('users').doc(user.uid).collection('cart').get();

    List<Map<String, dynamic>> items = [];
    for (var doc in cartSnapshot.docs) {
      items.add(doc.data());
      // Hapus dari cart setelah dipindah
      await doc.reference.delete();
    }

    // Buat order baru
    await _db.collection('users').doc(user.uid).collection('orders').add({
      'items': items,
      'totalPrice': totalPrice,
      'status': 'Processing',
      'date': FieldValue.serverTimestamp(),
    });
  }

  Future<void> toggleWhislist(ItemFoodModel item) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    final whislistRef = _db.collection('users').doc(user.uid).collection('whislist');
    final existing = await whislistRef.where('name', isEqualTo: item.title).get();

    if (existing.docs.isNotEmpty) {
      await whislistRef.add(item.toMap());
    } else {
      await existing.docs.first.reference.delete();
    }
  }
}