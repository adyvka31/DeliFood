import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_mobile/features/home/screen/main_screen/main_screen.dart';
import 'package:ecommerce_mobile/features/onboarding/onboarding2.dart'; // Digunakan untuk navigasi ke Login
import 'package:ecommerce_mobile/prefrences/color.dart';

// Asumsikan LoginPage ada di sini (untuk navigasi)

class SignupPage extends StatefulWidget {
  const SignupPage({super.key}); 

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Key untuk validasi Form
  final _formKey = GlobalKey<FormState>();

  // Instance Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers untuk input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  
  // State untuk Date Picker dan Loading
  DateTime? _selectedDate; 
  bool _isLoading = false;

  // --- Fungsi Date Picker ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000), // Default 1/1/2000
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Format tanggal (DD/MM/YYYY)
        _dateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}"; 
      });
    }
  }
  // --- Akhir Fungsi Date Picker ---

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

  // --- Fungsi Pendaftaran Firebase & Firestore ---
  Future<void> _signUp() async {
    // Validasi form lokal
    if (!_formKey.currentState!.validate()) {
      return; 
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Firebase Authentication (Membuat Pengguna Baru)
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. Menyimpan Data Tambahan ke Firestore
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'birthDate': _dateController.text, // Tanggal Lahir
          'address': _addressController.text.trim(), // Alamat Singkat
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        _showSnackBar("Pendaftaran berhasil! Selamat datang.");

        // 3. Navigasi ke MainScreen setelah sukses
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'Password terlalu lemah. Gunakan kombinasi yang lebih kuat.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Email sudah terdaftar. Silakan gunakan email lain atau Login.';
      } else {
        errorMessage = 'Gagal mendaftar: ${e.message}';
      }
      _showSnackBar(errorMessage, isError: true);
    } catch (e) {
      _showSnackBar('Terjadi kesalahan tak terduga: $e', isError: true);
    } finally {
      if(mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dateController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Definisikan style UnderlineInputBorder agar lebih rapi
  UnderlineInputBorder get _defaultInputBorder => const UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
  );
  UnderlineInputBorder get _focusedInputBorder => UnderlineInputBorder(
    borderSide: BorderSide(color: MainColors.secondaryColor, width: 2), // Sekarang membuat UnderlineInputBorder
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColors.secondaryColor,
      body: SingleChildScrollView( // Mencegah overflow
        child: Column(
          children: [
            // Bagian Header (SignUp)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              height: MediaQuery.of(context).size.height * 0.20,
              decoration: BoxDecoration(
                color: MainColors.secondaryColor,
                image: const DecorationImage(
                  image: AssetImage("assets/images/bg-login.jpg"), // Pastikan aset tersedia
                  fit: BoxFit.cover,
                  opacity: 0.05,
                ),
              ),
              child: const Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            // Bagian Form
            Container(
              padding: const EdgeInsets.all(40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Full Name
                    const Text("Name", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama wajib diisi.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter your Full Name",
                        border: _defaultInputBorder,
                        focusedBorder: _focusedInputBorder,
                        filled: false,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 2. Email (Wajib diisi)
                    const Text("Email", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
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
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        border: _defaultInputBorder,
                        focusedBorder: _focusedInputBorder,
                        filled: false,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 3. Tanggal Lahir 
                    const Text("Tanggal Lahir", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    TextFormField(
                      controller: _dateController,
                      readOnly: true, 
                      onTap: () => _selectDate(context), 
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tanggal lahir wajib diisi.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Pilih Tanggal Lahir (DD/MM/YYYY)",
                        suffixIcon: const Icon(Icons.calendar_today),
                        border: _defaultInputBorder,
                        focusedBorder: _focusedInputBorder,
                        filled: false,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 4. Address Singkat
                    const Text("Alamat Singkat", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    TextFormField(
                      controller: _addressController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Alamat wajib diisi.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Contoh: Jl. Sudirman No. 12",
                        border: _defaultInputBorder,
                        focusedBorder: _focusedInputBorder,
                        filled: false,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 5. Password
                    const Text("Password", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password wajib diisi.';
                        }
                        if (value.length < 6) {
                          return 'Password minimal 6 karakter.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter your password (min 6 characters)",
                        border: _defaultInputBorder,
                        focusedBorder: _focusedInputBorder,
                        filled: false,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 6. Confirm Password
                    const Text("Confirm Password", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konfirmasi Password wajib diisi.';
                        }
                        if (value != _passwordController.text) {
                          return 'Password tidak cocok.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Confirm your password",
                        border: _defaultInputBorder,
                        focusedBorder: _focusedInputBorder,
                        filled: false,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Tombol Sign Up
                    ElevatedButton(
                      onPressed: _isLoading ? null : _signUp, // Nonaktifkan saat loading
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: MainColors.secondaryColor,
                        minimumSize: const Size(double.infinity, 50), // Lebar penuh
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
                              "Sign Up",
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                    
                    const SizedBox(height: 25), 
                    
                    // Teks "Already have an account?"
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700], 
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Tombol Kedua (Login)
                    OutlinedButton(
                      onPressed: () {
                        // Navigasi ke halaman LoginPage (Menggunakan Onboarding2 sebagai placeholder login)
                        Navigator.pushReplacement( 
                          context,
                          MaterialPageRoute(
                            // Ganti Onboarding2 dengan class LoginPage Anda yang sebenarnya
                            builder: (context) =>  Onboarding2(name: _nameController.text), 
                        ));
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50), // Lebar penuh
                        side: BorderSide(color: MainColors.secondaryColor, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(color: MainColors.secondaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}