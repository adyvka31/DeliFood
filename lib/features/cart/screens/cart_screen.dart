import 'package:ecommerce_mobile/components/app_back_button.dart';
import 'package:ecommerce_mobile/features/cart/screens/input_adress_screen.dart';
import 'package:ecommerce_mobile/prefrences/color.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? _appliedCoupon;

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
      body: ListView(
        padding: EdgeInsets.only(top: 25, left: 25, right: 25),
        children: [
          basketItem(
            "Quinoa Fruit Salad",
            'assets/images/detail-food.png',
            "2 Packs",
            "Rp 20.000",
          ),
          SizedBox(height: 16),
          basketItem(
            "Melon Fruit Salad",
            'assets/images/combo1.png',
            "1 Packs",
            "Rp 15.000",
          ),
          SizedBox(height: 16),
          basketItem(
            "Tropical Fruit Salad",
            'assets/images/combo2.png',
            "1 Packs",
            "Rp 10.000",
          ),
          SizedBox(height: 24),
          Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
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

                      // Setelah modal ditutup, perbarui state jika ada hasilnya
                      if (couponCode != null && couponCode.isNotEmpty) {
                        setState(() {
                          _appliedCoupon = couponCode;
                        });
                      }
                    } else {
                      // Jika sudah ada kupon, aksi ini akan menghapusnya
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
                    padding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: Text(_appliedCoupon ?? "Apply"),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Subtotal", style: TextStyle(color: Colors.grey[600])),
                    Text(
                      "Rp 60.000",
                      style: TextStyle(fontWeight: FontWeight.w600),
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
                    Text("Delivery", style: TextStyle(color: Colors.grey[600])),
                    Text(
                      "Rp 8.000",
                      style: TextStyle(fontWeight: FontWeight.w600),
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
                      "Total",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Rp 68.000",
                      style: TextStyle(
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
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              showModal();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MainColors.secondaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              "Checkout",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
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
