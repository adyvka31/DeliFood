import 'package:ecommerce_mobile/features/home/model/item_modal.dart';
import 'package:ecommerce_mobile/features/track_status/track_status_screen.dart';
import 'package:ecommerce_mobile/prefrences/color.dart';
import 'package:ecommerce_mobile/service/database_service.dart';
import 'package:flutter/material.dart';

class InputAdress extends StatefulWidget {
  final int totalPrice;
  // Parameter tambahan untuk fitur Buy Now (langsung beli 1 barang)
  final ItemFoodModel? singleItem;
  final int? quantity;

  const InputAdress({
    super.key,
    required this.totalPrice,
    this.singleItem,
    this.quantity,
  });

  @override
  State<InputAdress> createState() => _InputAdressState();
}

class _InputAdressState extends State<InputAdress> {
  bool _isLoading = false; // Untuk indikator loading

  // Fungsi untuk menampilkan dialog sukses
  void showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // User tidak bisa menutup sembarangan
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(32),
            height: 550,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: MainColors.secondaryColor.withOpacity(0.5),
                      width: 3,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: const BoxDecoration(
                      color: MainColors.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  "Congratulations!!!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1E222B),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Your order have been taken and is being attended to",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xff878787), fontSize: 16),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Tutup dialog & modal, lalu pindah ke Track Status
                      Navigator.pop(context); // Tutup dialog
                      Navigator.pop(context); // Tutup modal sheet input address

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TrackStatusScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MainColors.secondaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: const Text(
                      "Track order",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text(
                      "Continue shopping",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- LOGIKA UTAMA: PROSES ORDER ---
  Future<void> _processOrder() async {
    setState(() => _isLoading = true);

    try {
      if (widget.singleItem != null && widget.quantity != null) {
        await DatabaseService().checkoutBuyNow(
          widget.singleItem!,
          widget.quantity!,
          widget.totalPrice,
        );
      } else {
        await DatabaseService().checkout(widget.totalPrice);
      }

      if (mounted) {
        setState(() => _isLoading = false);
        showSuccessDialog(); // Tampilkan sukses
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal memproses order: $e")));
      }
    }
  }

  void showModaPayWithCard() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 40,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildInput("Card Holders Name", "Adyvka Pratama"),
              buildInput("Card Number", "1234 5678 9012 1314"),
              Row(
                children: [
                  Expanded(child: buildInput("Date", "10/30")),
                  const SizedBox(width: 15),
                  Expanded(child: buildInput("CCV", "123")),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context); // Tutup modal kartu dulu
                        await _processOrder(); // Jalankan proses order
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: MainColors.secondaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                      ),
                      child: const Text("Complete order"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              children: [
                buildInput(
                  "Delivery address",
                  "10th avenue, Lekki, Lagos State",
                ),
                buildInput("Number we can call", "09090605708"),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _processOrder, // Panggil logika order
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: MainColors.secondaryColor,
                          ),
                          foregroundColor: MainColors.secondaryColor,
                        ),
                        child: const Text("Pay on delivery"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          showModaPayWithCard();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: MainColors.secondaryColor,
                          ),
                          foregroundColor: MainColors.secondaryColor,
                        ),
                        child: const Text("Pay with card"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  Widget buildInput(String title, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          TextFormField(decoration: InputDecoration(hintText: hintText)),
        ],
      ),
    );
  }
}
