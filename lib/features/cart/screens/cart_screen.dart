import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_mobile/components/app_back_button.dart';
import 'package:ecommerce_mobile/features/cart/screens/input_adress_screen.dart';
import 'package:ecommerce_mobile/features/home/model/item_modal.dart';
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
  String? _appliedCoupon;

  String formatRupiah(int price) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  void showModal(int total) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: InputAdress(totalPrice: total),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 100,
        leading: Center(
          child: AppBackButton(
            backgroundColor: Colors.white.withOpacity(0.3),
            iconColor: Colors.white,
          ),
        ),
        title: const Text(
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
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var cartDocs = snapshot.data!.docs;

          // Hitung Total
          int subTotal = 0;
          for (var doc in cartDocs) {
            subTotal += (doc['price'] as int) * (doc['quantity'] as int);
          }
          int deliveryFee = 8000;
          int total = subTotal + deliveryFee;

          return Column(
            children: [
              // 1. LIST ITEM (SCROLLABLE - BAGIAN ATAS)
              Expanded(
                child: cartDocs.isEmpty
                    ? const Center(child: Text("Keranjang Kosong"))
                    : ListView(
                        padding: const EdgeInsets.only(
                          top: 25,
                          left: 25,
                          right: 25,
                          bottom: 20,
                        ),
                        children: cartDocs.map((doc) {
                          var data = doc.data() as Map<String, dynamic>;
                          var docId = doc.id;

                          return Dismissible(
                            key: Key(docId),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) {
                              _dbService.removeFromCart(docId);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Item dihapus")),
                              );
                            },
                            background: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: _buildBasketItem(docId: docId, data: data),
                          );
                        }).toList(),
                      ),
              ),

              // 2. BOTTOM SECTION (STICKY - MENEMPEL DI BAWAH)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // A. PROMO CODE CARD
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D202020),
                            spreadRadius: -5,
                            blurRadius: 30,
                            offset: Offset(0, 0),
                          ),
                        ],
                        border: Border.all(color: Colors.black, width: 0.1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.discount_outlined,
                                color: MainColors.secondaryColor,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Promo Code",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_appliedCoupon == null) {
                                final String? couponCode =
                                    await showModalBottomSheet<String>(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return const CouponInputSheet();
                                      },
                                    );

                                if (couponCode != null &&
                                    couponCode.isNotEmpty) {
                                  setState(() {
                                    _appliedCoupon = couponCode;
                                  });
                                }
                              } else {
                                setState(() {
                                  _appliedCoupon = null;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MainColors.secondaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                            ),
                            child: Text(_appliedCoupon ?? "Apply"),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // B. TOTAL PRICE CARD
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D202020),
                            spreadRadius: -5,
                            blurRadius: 30,
                            offset: Offset(0, 0),
                          ),
                        ],
                        border: Border.all(color: Colors.black, width: 0.1),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Subtotal",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                formatRupiah(subTotal),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Divider(
                              color: Colors.grey.withOpacity(0.3),
                              thickness: 0.5,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Delivery",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                formatRupiah(deliveryFee),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Divider(
                              color: Colors.grey.withOpacity(0.3),
                              thickness: 0.5,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                formatRupiah(total),
                                style: const TextStyle(
                                  color: MainColors.secondaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // C. CHECKOUT BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (cartDocs.isNotEmpty) {
                            showModal(total);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Keranjang kosong")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MainColors.secondaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Checkout",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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

  // WIDGET ITEM KERANJANG
  Widget _buildBasketItem({
    required String docId,
    required Map<String, dynamic> data,
  }) {
    String imagePath = data['imagepath'] ?? '';
    bool isNetworkImage = imagePath.startsWith('http');
    String title = data['title'] ?? 'Item';
    int price = data['price'] ?? 0;
    int quantity = data['quantity'] ?? 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D202020),
            spreadRadius: -5,
            blurRadius: 30,
            offset: Offset(0, 0),
          ),
        ],
        border: Border.all(color: Colors.black, width: 0.1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[200]?.withOpacity(0.5),
            ),
            child: isNetworkImage
                ? Image.network(
                    imagePath,
                    width: 70,
                    height: 70,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.fastfood,
                      size: 40,
                      color: Colors.grey,
                    ),
                  )
                : Image.asset(
                    imagePath,
                    width: 70,
                    height: 70,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.fastfood,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  "$quantity Packs",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatRupiah(price * quantity),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (quantity > 1) {
                              _dbService.updateCartQuantity(
                                docId,
                                quantity - 1,
                              );
                            } else {
                              _dbService.removeFromCart(docId);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Item dihapus")),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: MainColors.secondaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text("$quantity", style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () async {
                            _dbService.updateCartQuantity(docId, quantity + 1);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: MainColors.secondaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
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
  final _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 40,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
