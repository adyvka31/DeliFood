import 'package:ecommerce_mobile/features/onboarding/onboarding2.dart';
import 'package:ecommerce_mobile/prefrences/color.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  // Key untuk mengelola Form
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  // Definisikan style border kustom untuk error (merah)
  final OutlineInputBorder errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Colors.redAccent, width: 2),
  );

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Warna background yang Anda gunakan

    return Scaffold(
      backgroundColor: MainColors.secondaryColor,
      body: SingleChildScrollView(
        // Mencegah overflow
        child: Center(
          // Bungkus dengan Form untuk validasi
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 110.0,
                horizontal: 24.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Free Delivery",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Reach your destination faster with\nour free delivery service",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 50),

                  Image.asset(
                    "assets/images/onboarding1.png",
                    width: 350,
                    height: 350,
                  ),

                  const SizedBox(height: 50),

                  // Input Field dengan Validator
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: _nameController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "How can we call you?",
                        hintStyle: TextStyle(color: Colors.grey),

                        errorStyle: const TextStyle(
                          color: Color(0xffEF4444), // Mengubah warna teks error
                          fontSize: 12, // Opsional: Mengatur ukuran font error
                        ),

                        // Style Border diisi putih agar kontras di background warna
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: errorBorder, // Border merah saat error
                        focusedErrorBorder: errorBorder,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 10,
                        ),
                      ),
                      // Validator: Mengembalikan pesan error jika input kosong
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon isi nama Anda untuk melanjutkan!';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tombol navigasi
                  ElevatedButton(
                    onPressed: () {
                      // Cek validasi sebelum navigasi
                      if (_formKey.currentState!.validate()) {
                        String nameController = _nameController.text;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Onboarding2(name: nameController),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      // Menggunakan warna putih agar kontras dengan background utama
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black, // Warna teks hitam
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 100,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Let's Started",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
