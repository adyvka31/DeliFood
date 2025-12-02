import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_mobile/components/app_back_button.dart';
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
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text("Wishlist is empty"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(25),
            itemCount: docs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              // Convert data Firestore ke Model
              final item = ItemFoodModel.fromSnapshot(docs[index]);

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // GAMBAR
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item.imagepath,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) =>
                            Icon(Icons.fastfood, size: 80, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 15),

                    // INFO
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item.formattedPrice,
                            style: const TextStyle(
                              color: MainColors.secondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ACTIONS (DELETE & ADD TO CART)
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () {
                            DatabaseService().toggleWhislist(item);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.shopping_cart,
                            color: MainColors.secondaryColor,
                          ),
                          onPressed: () {
                            DatabaseService().addToCart(item);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Added to Cart!")),
                            );
                          },
                        ),
                      ],
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
}
