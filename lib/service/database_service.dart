import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../features/home/model/item_modal.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1. GET PRODUCTS (SEARCH & CATEGORY)
  Stream<List<ItemFoodModel>> getProducts(String query, {String? category}) {
    Query ref = _db.collection('products');

    // Filter Kategori (Jika ada)
    if (category != null && category != "All" && category != "Hottest") {}

    return ref.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ItemFoodModel.fromSnapshot(doc)).where((
        item,
      ) {
        final matchesQuery = item.title.toLowerCase().contains(
          query.toLowerCase(),
        );
        final matchesCategory = (category == null || category == "All")
            ? true
            : item.category.toLowerCase().contains(category.toLowerCase());
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  // 2. ADD TO CART (FIX DUPLICATE & QUANTITY)
  Future<void> addToCart(ItemFoodModel item) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    final cartRef = _db.collection('users').doc(user.uid).collection('cart');

    // Cek apakah produk sudah ada?
    final existing = await cartRef.where('title', isEqualTo: item.title).get();

    if (existing.docs.isNotEmpty) {
      // UPDATE: Jika ada, tambah quantity +1
      var doc = existing.docs.first;
      int currentQty = doc['quantity'] ?? 1;
      await doc.reference.update({'quantity': currentQty + 1});
    } else {
      // CREATE: Jika belum ada, buat baru
      await cartRef.add({
        ...item.toMap(),
        'quantity': 1,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // 3. GET CART
  Stream<QuerySnapshot> getCart() {
    User? user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    return _db.collection('users').doc(user.uid).collection('cart').snapshots();
  }

  // 4. REMOVE FROM CART
  Future<void> removeFromCart(String docId) async {
    User? user = _auth.currentUser;
    if (user == null) return;
    await _db
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(docId)
        .delete();
  }

  // 5. CHECKOUT
  Future<void> checkout(int totalPrice) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    var cartSnapshot = await _db
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .get();

    if (cartSnapshot.docs.isEmpty) return;

    List<Map<String, dynamic>> items = [];
    for (var doc in cartSnapshot.docs) {
      items.add(doc.data());
      await doc.reference.delete();
    }

    await _db.collection('users').doc(user.uid).collection('orders').add({
      'items': items,
      'total_price': totalPrice,
      'status': 'Processing',
      'order_date': FieldValue.serverTimestamp(),
    });
  }

  // 6. TOGGLE WISHLIST (FIXED LOGIC)
  Future<void> toggleWhislist(ItemFoodModel item) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    final wishlistRef = _db
        .collection('users')
        .doc(user.uid)
        .collection('wishlist');
    final existing = await wishlistRef
        .where('title', isEqualTo: item.title)
        .get();

    if (existing.docs.isNotEmpty) {
      // JIKA ADA -> HAPUS
      await existing.docs.first.reference.delete();
    } else {
      // JIKA TIDAK ADA -> TAMBAH
      await wishlistRef.add({
        ...item.toMap(),
        'added_at': FieldValue.serverTimestamp(),
      });
    }
  }

  // 7. GET WISHLIST
  Stream<QuerySnapshot> getWishlist() {
    User? user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    return _db
        .collection('users')
        .doc(user.uid)
        .collection('wishlist')
        .snapshots();
  }

  // 8. GET ORDERS
  Stream<QuerySnapshot> getOrders() {
    User? user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    return _db
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .orderBy('order_date', descending: true)
        .snapshots();
  }

  // 9. ADD DATA DUMMY PRODUCT
  Future<void> seedDatabase() async {
    CollectionReference products = _db.collection('products');

    // --- ITEM 1: Honey lime combo (Hottest & Popular) ---
    var check1 = await products
        .where('title', isEqualTo: 'Honey lime combo')
        .limit(1)
        .get();

    final data1 = {
      'title': 'Honey lime combo',
      'price': 20000,
      'rating': 4.5,
      'category': 'Hottest',
      'imagepath': 'assets/images/combo1.png',
      'description':
          'Nikmati kesegaran alami dari perpaduan Honey Lime Combo. Terbuat dari jeruk nipis pilihan yang diperas segar dan dicampur dengan madu murni berkualitas tinggi.',
    };

    if (check1.docs.isEmpty) {
      await products.add(data1);
      print("Item 1 berhasil ditambahkan.");
    } else {
      await check1.docs.first.reference.update(data1);
      print("Item 1 berhasil di-update kategorinya.");
    }

    // --- ITEM 2: Bery mango combo (Popular Only) ---
    var check2 = await products
        .where('title', isEqualTo: 'Bery mango combo')
        .limit(1)
        .get();

    final data2 = {
      'title': 'Bery mango combo',
      'price': 35000,
      'rating': 4.3,
      'category': 'Hottest, Popular',
      'imagepath': 'assets/images/combo2.png',
      'description':
          'Rasakan sensasi tropis dalam satu gigitan dengan Bery Mango Combo. Potongan mangga harum manis yang lembut dipadukan dengan aneka buah beri.',
    };

    if (check2.docs.isEmpty) {
      await products.add(data2);
      print("Item 2 berhasil ditambahkan.");
    } else {
      await check2.docs.first.reference.update(data2);
      print("Item 2 berhasil di-update.");
    }
  }
}
