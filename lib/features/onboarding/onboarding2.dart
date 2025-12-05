import 'package:ecommerce_mobile/features/home/screen/main_screen/main_screen.dart';
import 'package:ecommerce_mobile/features/onboarding/signuppage.dart';
import 'package:ecommerce_mobile/prefrences/color.dart';
import 'package:flutter/material.dart';
// Import Firebase
import 'package:firebase_auth/firebase_auth.dart';

class Onboarding2 extends StatefulWidget {
  // name tidak digunakan lagi di sini, tapi dipertahankan untuk kompatibilitas
  final String name;
  const Onboarding2({super.key, required this.name});

  @override
  State<Onboarding2> createState() => _Onboarding2State();
}

class _Onboarding2State extends State<Onboarding2> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- Fungsi SnackBar untuk Notifikasi ---
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // --- Fungsi Login Firebase ---
  Future<void> _signIn() async {
    // 1. Validasi form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 2. Panggil Firebase Authentication untuk login
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      _showSnackBar("Login berhasil! Selamat datang.");

      // 3. Navigasi ke MainScreen setelah sukses
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      // 4. Penanganan Error Spesifik Firebase
      if (e.code == 'user-not-found') {
        errorMessage =
            'Email tidak terdaftar. Silakan daftar atau periksa kembali email Anda.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Password salah. Coba lagi.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Format email tidak valid.';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Terlalu banyak percobaan gagal. Coba lagi nanti.';
      } else {
        errorMessage = 'Gagal Login: ${e.message}';
      }
      _showSnackBar(errorMessage, isError: true);
    } catch (e) {
      _showSnackBar('Terjadi kesalahan tak terduga: $e', isError: true);
    } finally {
      // 5. Matikan loading
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColors.secondaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // =========================================================
            // SECTION ATAS (HEADER) - Sudah rata tengah (Center widget)
            // =========================================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              height:
                  MediaQuery.of(context).size.height *
                  0.40, // Disesuaikan agar tidak terlalu besar
              decoration: BoxDecoration(
                color: MainColors.secondaryColor,
                image: const DecorationImage(
                  image: AssetImage("assets/images/bg-login.jpg"),
                  fit: BoxFit.cover,
                  opacity: 0.05,
                ),
              ),
              child: Center(
                child: Text(
                  "Hallo ${widget.name}, Welcome to our app! Log into your account",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // =========================================================
            // SECTION BAWAH (FORM) - Diubah menjadi rata tengah vertikal
            // =========================================================
            Container(
              padding: const EdgeInsets.all(40),
              // Tinggi 0.60% dari layar sisa
              height: MediaQuery.of(context).size.height * 0.60,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Center(
                // Tambahkan Center di sini untuk Form jika Column Form-nya tidak mengisi tinggi penuh
                child: Form(
                  key: _formKey,
                  child: Column(
                    // KOREKSI: Tambahkan MainAxisAlignment.center untuk rata tengah vertikal
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- 1. Email ---
                      const Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email wajib diisi.';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Masukkan format email yang valid.';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Enter your email",
                          filled: false,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- 2. Password ---
                      const Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password wajib diisi.';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Enter your password",
                          filled: false,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // --- 3. Tombol Login ---
                          ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : _signIn, // Panggil fungsi login
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: MainColors.secondaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),

                          const SizedBox(height: 30),

                          // 4. Teks "Don't have an account?"
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // 5. Tombol Sign Up
                          OutlinedButton(
                            onPressed: () {
                              // Navigasi ke halaman pendaftaran (SignupPage)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignupPage(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(
                                color: MainColors.secondaryColor,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                color: MainColors.secondaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
