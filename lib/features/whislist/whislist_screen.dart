import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_mobile/components/app_back_button.dart';
import 'package:ecommerce_mobile/features/home/screen/detail_screen/detail_screen.dart';
import 'package:ecommerce_mobile/prefrences/color.dart';
import 'package:ecommerce_mobile/service/database_service.dart';
import 'package:ecommerce_mobile/features/home/model/item_modal.dart';
import 'package:flutter/material.dart';

class WhislistScreen extends StatelessWidget {
  const WhislistScreen({super.key});

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
          "Wishlist",
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
        stream: DatabaseService().getWishlist(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("Error"));
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text("Wishlist is empty"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(25),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 0.70,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final item = ItemFoodModel.fromSnapshot(docs[index]);

              // --- LOGIKA CEK GAMBAR (ASET LOKAL vs INTERNET) ---
              final isNetworkImage = item.imagepath.startsWith('http');

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(model: item),
                    ),
                  );
                },
                // MENGGUNAKAN LAYOUT BARU (COLUMN)
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. BAGIAN GAMBAR & LOVE (STACK)
                    // 1. BAGIAN GAMBAR & LOVE (STACK)
                    Expanded(
                      child: Stack(
                        children: [
                          // Container Background Abu-abu
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            padding:
                                EdgeInsets.zero, // Pastikan padding 0 (Nol)
                            decoration: BoxDecoration(
                              color: const Color(0xffF3F4F9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Hero(
                                tag: item.imagepath,
                                child: Transform.scale(
                                  scale: 1.3,
                                  child: isNetworkImage
                                      ? Image.network(
                                          item.imagepath,
                                          fit: BoxFit.contain,
                                          errorBuilder: (ctx, err, stack) =>
                                              _buildErrorIcon(),
                                        )
                                      : Image.asset(
                                          item.imagepath,
                                          fit: BoxFit.contain,
                                          errorBuilder: (ctx, err, stack) =>
                                              _buildErrorIcon(),
                                        ),
                                ),
                                // ------------------------------------
                              ),
                            ),
                          ),

                          // Tombol Favorite
                          Positioned(
                            top: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () {
                                DatabaseService().toggleWhislist(item);
                              },
                              child: const Icon(
                                Icons.favorite,
                                color: MainColors.secondaryColor,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 2. JUDUL PRODUK
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // 3. RATING & BADGE HEALTH
                    Row(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${item.rating}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "|",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            "Health",
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    // 4. HARGA
                    Text(
                      item.formattedPrice,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: MainColors.secondaryColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Widget Helper jika gambar gagal dimuat
  Widget _buildErrorIcon() {
    return Icon(Icons.fastfood, size: 60, color: Colors.grey[400]);
  }
}
