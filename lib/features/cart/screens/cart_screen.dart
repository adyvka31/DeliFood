import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_mobile/components/app_back_button.dart';
import 'package:ecommerce_mobile/features/cart/screens/input_adress_screen.dart';
import 'package:ecommerce_mobile/prefrences/color.dart';
import 'package:ecommerce_mobile/service/database_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final DatabaseService _dbService = DatabaseService();

  String formatRupiah(int price) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  void showModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: InputAdress(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: Center(
          child: AppBackButton(
            backgroundColor: Colors.white.withOpacity(0.3),
            iconColor: Colors.white,
          ),
        ),
        title: Text(
          "My Basket",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: MainColors.secondaryColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(17.0),
          child: Container(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _dbService.getCart(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          var cartDocs = snapshot.data!.docs;

          if (cartDocs.isEmpty) {
            return Center(child: Text("Keranjang Kosong"));
          }

          // Hitung Total Belanja
          int subTotal = 0;
          for (var doc in cartDocs) {
            subTotal += (doc['price'] as int) * (doc['quantity'] as int);
          }
          int deliveryFee = 8000;
          int total = subTotal + deliveryFee;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(25),
                  itemCount: cartDocs.length,
                  itemBuilder: (context, index) {
                    var data = cartDocs[index].data() as Map<String, dynamic>;
                    var docId = cartDocs[index].id;

                    return Dismissible(
                      key: Key(docId),
                      onDismissed: (_) => _dbService.removeFromCart(docId),
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16),
                        // ... Gunakan Container basketItem lama Anda tapi dengan data dinamis ...
                        child: Row(
                          children: [
                            Image.network(
                              data['image'],
                              width: 90,
                              height: 90,
                            ), // Gunakan Network Image
                            // ... Tampilkan Nama & Harga (data['name'], data['price'])
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bagian Total & Checkout
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total"),
                        Text(
                          formatRupiah(total),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () async {
                        // Fitur BELI SEMUA / Checkout
                        await _dbService.checkout(total);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Order Successful!")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MainColors.secondaryColor,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text("Checkout All Items"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Container basketItem(
    String name,
    String imagePath,
    String quantity,
    String price,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D202020),
            spreadRadius: -5,
            blurRadius: 30,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[200]?.withOpacity(0.5),
            ),
            child: Image.asset(imagePath, width: 90, height: 90),
          ),
          SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 3),
                Text(
                  quantity,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[400],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: MainColors.secondaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        SizedBox(width: 14),
                        Text("1", style: TextStyle(fontSize: 16)),
                        SizedBox(width: 14),
                        Container(
                          decoration: BoxDecoration(
                            color: MainColors.secondaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(Icons.add, color: Colors.white, size: 22),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CouponInputSheet extends StatefulWidget {
  const CouponInputSheet({super.key});

  @override
  State<CouponInputSheet> createState() => _CouponInputSheetState();
}

class _CouponInputSheetState extends State<CouponInputSheet> {
  // Controller untuk mengambil teks dari form
  final _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Padding ini penting agar keyboard tidak menutupi modal
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 40,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Agar tinggi modal sesuai konten
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Code Coupon",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _couponController,
            decoration: const InputDecoration(hintText: "Enter Your Coupon"),
            autofocus: true,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Saat ditekan, tutup modal dan kirim teks sebagai "hasil"
                Navigator.pop(context, _couponController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MainColors.secondaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text("Use Your Coupon"),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
