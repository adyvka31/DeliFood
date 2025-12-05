import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce_mobile/components/app_back_button.dart';
import 'package:ecommerce_mobile/features/cart/screens/cart_screen.dart';
import 'package:ecommerce_mobile/features/cart/screens/input_adress_screen.dart';
import 'package:ecommerce_mobile/features/home/model/item_modal.dart';
import 'package:ecommerce_mobile/prefrences/color.dart';
import 'package:ecommerce_mobile/service/database_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import Intl untuk format Rupiah

class DetailPage extends StatefulWidget {
  final ItemFoodModel model;

  const DetailPage({super.key, required this.model});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late List<String> _images;
  int _selectedIndex = 0;
  bool _isFavorited = false;

  // 1. VARIABLE UNTUK MENYIMPAN JUMLAH PESANAN
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _images = [
      widget.model.imagepath,
      'assets/images/combo2.png',
      'assets/images/hotest1.png',
      'assets/images/hotest2.png',
    ];
    _checkIfFavorited();
  }

  // --- LOGIKA TAMBAH & KURANG JUMLAH ---
  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  // --- FORMATTER HARGA TOTAL ---
  String get _totalPriceFormatted {
    int total = widget.model.price * _quantity;
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(total);
  }

  // Cek Favorit
  Future<void> _checkIfFavorited() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final query = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .where('title', isEqualTo: widget.model.title)
          .limit(1)
          .get();
      if (mounted && query.docs.isNotEmpty) {
        setState(() {
          _isFavorited = true;
        });
      }
    } catch (e) {
      print("Error checking wishlist: $e");
    }
  }

  Widget _buildImage(String path, {BoxFit fit = BoxFit.contain}) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: fit,
        errorBuilder: (ctx, err, stack) =>
            const Icon(Icons.fastfood, color: Colors.grey),
      );
    } else {
      return Image.asset(
        path,
        fit: fit,
        errorBuilder: (ctx, err, stack) =>
            const Icon(Icons.fastfood, color: Colors.grey),
      );
    }
  }

  void _showAddressModal() {
    int totalBuyNow = widget.model.price * _quantity;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85, // Tinggikan modal
          child: InputAdress(totalPrice: totalBuyNow),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.grey[100],
              height: 450,
              child: Stack(
                children: [
                  Align(
                    alignment: const Alignment(0.0, 0.3),
                    child: SizedBox(
                      width: 250,
                      height: 250,
                      child: _selectedIndex == 0
                          ? Hero(
                              tag: widget.model.imagepath,
                              child: _buildImage(_images[_selectedIndex]),
                            )
                          : _buildImage(_images[_selectedIndex]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 65,
                      left: 30,
                      right: 30,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppBackButton(),
                        const Text(
                          "Product Details",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              await DatabaseService().toggleWhislist(
                                widget.model,
                              );
                              setState(() {
                                _isFavorited = !_isFavorited;
                              });
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      _isFavorited
                                          ? "Added to Wishlist"
                                          : "Removed from Wishlist",
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                            child: Icon(
                              _isFavorited
                                  ? Icons.favorite
                                  : Icons.favorite_border_rounded,
                              color: const Color(0xff047884),
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 36),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: -5,
                            blurRadius: 15,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Wrap(
                        spacing: 6.0,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          ...List.generate(4, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = index;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _selectedIndex == index
                                        ? MainColors.secondaryColor
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: SizedBox(
                                  width: 43,
                                  height: 43,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: _buildImage(
                                      _images[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                          Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              color: MainColors.secondaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                "+10",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // BAGIAN BODY (INFO PRODUK)
            Padding(
              padding: const EdgeInsets.only(top: 30, right: 30, left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.model.category.isNotEmpty
                            ? widget.model.category
                            : "Food",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 24),
                          const SizedBox(width: 4),
                          Text(
                            "${widget.model.rating}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.model.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _decrementQuantity,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                              ),
                              child: const Icon(Icons.remove),
                            ),
                          ),

                          // Teks Jumlah
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              "$_quantity", // Menampilkan jumlah dinamis
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),

                          GestureDetector(
                            onTap: _incrementQuantity,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.grey[200]?.withOpacity(0.5),
                                border: Border.all(
                                  color: const Color(0xffFFF2E7),
                                ),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: MainColors.secondaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Text(
                        _totalPriceFormatted,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),
                  Divider(color: Colors.grey.withOpacity(0.3), thickness: 0.5),
                  const SizedBox(height: 22),
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.model.description.isNotEmpty
                        ? widget.model.description
                        : "Delicious food specifically made for you with high-quality ingredients.",
                    style: const TextStyle(height: 1.7, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),

            // BAGIAN FOOTER (TOMBOL ADD TO BASKET)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _showAddressModal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MainColors.secondaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Buy Now"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        // UPDATE: Kirim quantity yang dipilih ke Firebase
                        await DatabaseService().addToCart(
                          widget.model,
                          quantity: _quantity,
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Added $_quantity items to Basket!",
                              ),
                              backgroundColor: MainColors.secondaryColor,
                            ),
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Add To Basket"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
