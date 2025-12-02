import 'package:flutter/material.dart';
// Impor Firebase untuk otentikasi dan database
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_mobile/prefrences/color.dart';
// Asumsi AppBackButton ada di components
import 'package:ecommerce_mobile/components/app_back_button.dart'; 
// Asumsi MainScreen dan Onboarding2 (untuk logout) ada di sini
import 'package:ecommerce_mobile/features/home/screen/main_screen/main_screen.dart';
import 'package:ecommerce_mobile/features/onboarding/onboarding2.dart'; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Future untuk menyimpan hasil fetch data
  late Future<Map<String, dynamic>> _userDataFuture;
  
  // State untuk URL foto profil (jika diunggah), null jika belum ada
  String? _profileImageUrl; 

  @override
  void initState() {
    super.initState();
    // Panggil fungsi pengambilan data saat widget dibuat
    _userDataFuture = _fetchUserData();
  }

  // --- 1. Fungsi Fetch Data Pengguna ---
  Future<Map<String, dynamic>> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user == null) {
      // Jika tidak ada pengguna, navigasi ke login
      if (mounted) {
         // Menggunakan pushAndRemoveUntil untuk mengarahkan pengguna ke halaman Login
         Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Onboarding2(name: '')),
            (route) => false,
          );
      }
      return {};
    }

    try {
      // Ambil dokumen pengguna dari koleksi 'users'
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        // Set URL foto profil dari Firestore
        _profileImageUrl = data['profileImageUrl'] as String?;
        return data;
      } else {
        // Data di Firestore tidak ditemukan (walaupun user terautentikasi)
        return {
          'name': 'Pengguna Baru', 
          'email': user.email ?? 'Tidak Ada Email', 
          'birthDate': 'N/A', 
          'address': 'N/A'
        };
      }
    } catch (e) {
      print("Error fetching user data: $e");
      // Kasus error umum (mis. CONFIGURATION_NOT_FOUND jika Firebase tidak benar)
      return {
        'name': 'Error', 
        'email': user.email ?? 'Error Email', 
        'birthDate': 'Error', 
        'address': 'Error'
      };
    }
  }


  Future<void> _pickAndUploadImage() async {
    // Tampilkan notifikasi bahwa fitur sedang dikembangkan
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Fitur Upload Foto Profil sedang dikembangkan!"), 
        backgroundColor: Colors.orange
      ),
    );
  }


  // --- 2. Fungsi Logout ---
  Future<void> _logout() async {
    await _auth.signOut();
    if (!mounted) return;
    
    // Navigasi ke halaman onboarding/login dan hapus semua rute sebelumnya
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Onboarding2(name: '')), // Mengarah ke Onboarding2
      (route) => false,
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
        title: const Text(
          "My Profile",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: MainColors.secondaryColor,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(17.0),
          child: SizedBox.shrink(),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            // Jika data kosong, mungkin pengguna belum login atau terjadi error
            return Center(child: Text("Gagal memuat data: ${snapshot.error ?? 'Data Kosong'}"));
          }

          final userData = snapshot.data!;
          final name = userData['name'] ?? 'Nama Tidak Ditemukan';
          final email = userData['email'] ?? 'Email Tidak Ditemukan';
          final birthDate = userData['birthDate'] ?? 'Tanggal Lahir N/A';
          final address = userData['address'] ?? 'Alamat N/A';
          // Mengambil URL foto dari state atau data Firestore
          final currentProfileImageUrl = _profileImageUrl ?? userData['profileImageUrl'] as String?;


          return ListView(
            padding: const EdgeInsets.only(top: 25, right: 25, left: 25),
            children: [
              // Bagian Header Profil (Data Dinamis)
              Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: SizedBox(
                          height: 160,
                          width: double.infinity,
                          child: Image.asset(
                            'assets/images/bg-profile.png', // Background cover
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      
                      // Foto Profil Dinamis/Default
                      Positioned(
                        top: 80,
                        child: GestureDetector(
                          onTap: _pickAndUploadImage,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.grey.shade200, // Background untuk icon
                              // Cek apakah ada URL foto, jika ada gunakan NetworkImage
                              backgroundImage: currentProfileImageUrl != null
                                  ? NetworkImage(currentProfileImageUrl) as ImageProvider
                                  : null,
                              child: currentProfileImageUrl == null
                                  ? Icon(
                                      Icons.person,
                                      size: 70,
                                      color: MainColors.secondaryColor,
                                    ) // Icon default jika foto kosong
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      
                      // Tombol Edit/Tambahkan Foto
                      Positioned(
                        top: 150,
                        right: MediaQuery.of(context).size.width / 2 - 90, // Menyesuaikan posisi di kanan bawah foto
                        child: GestureDetector(
                          onTap: _pickAndUploadImage,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: MainColors.secondaryColor,
                            child: const Icon(Icons.edit, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 55),
                  Text(
                    name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    birthDate,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Bagian Detail Akun (Data Dinamis)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Account Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  // Menggunakan data dari Firestore
                  buildAccountField("Email", email),
                  const SizedBox(height: 15),
                  buildAccountField("Name", name),
                  const SizedBox(height: 15),
                  buildAccountField("Date of Birth", birthDate),
                  const SizedBox(height: 15),
                  buildAccountField("Address", address),
                  const SizedBox(height: 30),
                  
                  // Bagian Last Order (Statik)
                  const Text(
                    "Last Order",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 240,
                    child: ListView(
                      clipBehavior: Clip.none,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: const [
                        CardFood(
                          title: "Honey Line Combo",
                          price: "Rp 2.000",
                          imagePath: 'assets/images/combo1.png',
                        ),
                        SizedBox(width: 10),
                        CardFood(
                          title: "Bery Line Combo",
                          price: "Rp 8.000",
                          imagePath: 'assets/images/combo2.png',
                        ),
                        SizedBox(width: 10),
                        CardFood(
                          title: "Quinoa Fruit Salad",
                          price: "Rp 10.000",
                          imagePath: 'assets/images/hotest1.png',
                        ),
                        SizedBox(width: 10),
                        CardFood(
                          title: "Tropical Fruit Salad",
                          price: "Rp 10.000",
                          imagePath: 'assets/images/hotest2.png',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- Tombol Logout ---
                  OutlinedButton(
                    onPressed: _logout,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: Colors.red, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

// --- CardFood Widget (Disertakan agar kode dapat berjalan) ---

class CardFood extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final String price;
  final String imagePath;
  final Color backgroundColor;

  const CardFood({
    super.key,
    this.width = 180,
    this.height = 240,
    required this.title,
    required this.price,
    required this.imagePath,
    this.backgroundColor = Colors.white,
  });

  @override
  State<CardFood> createState() => _CardFoodState();
}

class _CardFoodState extends State<CardFood> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: widget.backgroundColor,
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    widget.imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 4),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 30,

                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      elevation: 0,
                      backgroundColor: MainColors.secondaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Nilai", style: TextStyle(fontSize: 10)),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  height: 30,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MainScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: MainColors.secondaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      side: BorderSide(color: MainColors.secondaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Beli Lagi", style: TextStyle(fontSize: 10)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- buildAccountField Widget (Disertakan agar kode dapat berjalan) ---

Widget buildAccountField(String label, String value) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade400),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Expanded(
          // Menggunakan Text bukan TextFormField karena ini halaman profil, bukan edit.
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}