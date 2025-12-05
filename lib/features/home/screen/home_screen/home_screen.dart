import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce_mobile/features/home/model/item_modal.dart';
import 'package:ecommerce_mobile/features/home/screen/detail_screen/detail_screen.dart';
import 'package:ecommerce_mobile/prefrences/color.dart';
import 'package:ecommerce_mobile/service/database_service.dart';
import 'package:flutter/material.dart';
import 'dart:math'; // Import untuk random waktu (opsional)

part 'sections/header_section.dart';
part 'sections/special_section.dart';
part 'sections/recomended_section.dart';
part 'sections/filtered_item_section.dart';

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(32),
          height: 500,
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
                  child: const Icon(Icons.check, color: Colors.white, size: 50),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Congratulations!!!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1E222B),
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                "Your coupon has been successfully claimed, let's use it immediately to get an attractive offer.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xff878787), fontSize: 16),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MainColors.secondaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    "Use my coupon",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 7),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text(
                    "See other offers",
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

class HomeScreen extends StatefulWidget {
  final String name;

  const HomeScreen({super.key, required this.name});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = "";
  final List<String> category = [
    "Hottest",
    "Popular",
    "New Combo",
    "Top",
    "Most Like",
    "Recently",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- DRAWER NOTIFIKASI DINAMIS ---
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            // Header Drawer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 75, left: 20, bottom: 30),
              decoration: const BoxDecoration(color: MainColors.secondaryColor),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notifications',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Update terbaru dari produk kami',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // List Notifikasi dari Firebase
            Expanded(
              child: StreamBuilder<List<ItemFoodModel>>(
                // Mengambil semua produk sebagai sumber notifikasi
                stream: DatabaseService().getProducts(""),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Gagal memuat notifikasi"));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final products = snapshot.data!;

                  if (products.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 50,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Belum ada notifikasi",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.only(top: 15),
                    itemCount: products.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 10,
                      indent: 70,
                      color: Color.fromARGB(255, 228, 227, 227),
                    ),
                    itemBuilder: (context, index) {
                      final item = products[index];

                      // Simulasi data notifikasi berdasarkan produk
                      final bool isNew =
                          index < 0; // 2 item teratas dianggap baru/unread

                      return GestureDetector(
                        onTap: () {
                          // Tutup drawer lalu buka detail produk
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(model: item),
                            ),
                          );
                        },
                        child: NotificationItem(
                          logoAsset: item.imagepath, // Gambar produk
                          title: "Promo Spesial: ${item.title}",
                          subtitle:
                              "Dapatkan penawaran menarik untuk ${item.title}. Stok terbatas!",
                          time:
                              "${Random().nextInt(12) + 1} jam yang lalu", // Simulasi waktu
                          isUnread: isNew,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Builder(
        builder: (context) {
          return Column(
            children: [
              // 1. HEADER SECTION
              HeaderSection(
                onNotificationTap: () {
                  Scaffold.of(context).openEndDrawer();
                },
                onSearchChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),

              // 2. DYNAMIC BODY
              Expanded(
                child: _searchQuery.isEmpty
                    // A. NORMAL VIEW (No Search)
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            const SpecialSection(),
                            const SizedBox(height: 20),
                            const RecomendedSection(),
                            const SizedBox(height: 40),
                            FilteredItemSection(category: category),
                            const SizedBox(height: 100),
                          ],
                        ),
                      )
                    // B. SEARCH RESULTS VIEW
                    : StreamBuilder<List<ItemFoodModel>>(
                        stream: DatabaseService().getProducts(_searchQuery),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(child: Text("Error"));
                          }
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final products = snapshot.data!;
                          if (products.isEmpty) {
                            return const Center(
                              child: Text("Product not found"),
                            );
                          }

                          return GridView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: products.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 15,
                                  childAspectRatio: 0.75,
                                ),
                            itemBuilder: (context, index) {
                              final item = products[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailPage(model: item),
                                    ),
                                  );
                                },
                                child: CardFood(
                                  title: item.title,
                                  price: item.formattedPrice,
                                  imagePath: item.imagepath,
                                  model: item,
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// --- WIDGET NOTIFICATION ITEM (DIPERBARUI) ---
class NotificationItem extends StatelessWidget {
  final String logoAsset;
  final String title;
  final String subtitle;
  final String time;
  final bool isUnread;

  const NotificationItem({
    super.key,
    required this.logoAsset,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    // Cek apakah gambar dari internet atau aset lokal
    final bool isNetworkImage = logoAsset.startsWith('http');

    return Container(
      color: isUnread
          ? const Color(0xFFF5F9FA)
          : Colors.white, // Highlight unread
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Bulat
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              image: DecorationImage(
                image: isNetworkImage
                    ? NetworkImage(logoAsset)
                    : AssetImage(logoAsset) as ImageProvider,
                fit: BoxFit.cover,
                // Handle error jika gambar rusak
                onError: (exception, stackTrace) {},
              ),
            ),
            child: isNetworkImage
                ? null
                : null, // Placeholder bisa ditambahkan jika perlu
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: isUnread
                              ? FontWeight.w700
                              : FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isUnread)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: MainColors.secondaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isUnread ? Colors.black54 : Colors.grey[500],
                    fontSize: 13,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey[400], fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SpecialWidget extends StatelessWidget {
  final String imagePath;
  final String discount;
  final VoidCallback onClaim;
  final bool isClaimed;

  const SpecialWidget({
    super.key,
    required this.imagePath,
    required this.discount,
    required this.onClaim,
    required this.isClaimed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.05),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Limited time!",
                              style: TextStyle(
                                color: MainColors.secondaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Get Special Offer",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Up to ",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                discount,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Text(
                            "All Services Available | T&C Applied",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: isClaimed ? null : onClaim,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MainColors.secondaryColor,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey.shade400,
                            disabledForegroundColor: Colors.white.withOpacity(
                              0.8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                          ),
                          child: Text(
                            isClaimed ? "Already Claimed" : "Claim",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
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

class CardFood extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final String price;
  final String imagePath;
  final Color backgroundColor;
  final List<BoxShadow> boxShadow;
  final ItemFoodModel? model;

  const CardFood({
    super.key,
    this.width = 190,
    this.height = 200,
    required this.title,
    required this.price,
    required this.imagePath,
    this.backgroundColor = Colors.white,
    this.boxShadow = const [
      BoxShadow(
        color: Color(0x0D202020),
        spreadRadius: 0,
        blurRadius: 30,
        offset: Offset(0, 3),
      ),
    ],
    this.model,
  });

  @override
  State<CardFood> createState() => _CardFoodState();
}

class _CardFoodState extends State<CardFood> {
  @override
  Widget build(BuildContext context) {
    final bool isNetworkImage = widget.imagePath.startsWith('http');

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: widget.backgroundColor,
        boxShadow: widget.boxShadow,
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
                  padding: const EdgeInsets.only(top: 16, bottom: 4),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      widget.price,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey[200]?.withOpacity(0.5),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: MainColors.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: widget.model != null
                ? StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .collection('wishlist')
                        .where('title', isEqualTo: widget.model!.title)
                        .snapshots(),
                    builder: (context, snapshot) {
                      final isFavorited =
                          snapshot.hasData && snapshot.data!.docs.isNotEmpty;

                      return GestureDetector(
                        onTap: () async {
                          String message = isFavorited
                              ? "Removed from Wishlist"
                              : "Added to Wishlist";

                          await DatabaseService().toggleWhislist(widget.model!);

                          if (context.mounted) {
                            ScaffoldMessenger.of(
                              context,
                            ).clearSnackBars(); // Hapus snackbar lama biar ga numpuk
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                                duration: const Duration(seconds: 1),
                                backgroundColor: isFavorited
                                    ? Colors
                                          .redAccent // Merah jika dihapus
                                    : MainColors
                                          .secondaryColor, // Hijau jika ditambah
                              ),
                            );
                          }
                        },
                        child: Icon(
                          isFavorited
                              ? Icons.favorite
                              : Icons.favorite_border_rounded,
                          color: const Color(0xff047884),
                          size: 24,
                        ),
                      );
                    },
                  )
                : const Icon(
                    // Fallback icon jika tidak ada model (misal di ProfileScreen)
                    Icons.favorite_border_rounded,
                    color: Color(0xff047884),
                    size: 24,
                  ),
          ),
        ],
      ),
    );
  }
}
