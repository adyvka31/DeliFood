import 'package:ecommerce_mobile/features/cart/screens/cart_screen.dart';
import 'package:ecommerce_mobile/features/cart/screens/input_adress_screen.dart';
import 'package:ecommerce_mobile/features/home/model/item_modal.dart';
import 'package:ecommerce_mobile/prefrences/color.dart';
import 'package:ecommerce_mobile/service/database_service.dart';
import 'package:flutter/material.dart';

part 'sections/body_section.dart';
part 'sections/footer_section.dart';

class DetailPage extends StatefulWidget {
  final ItemFoodModel model;

  const DetailPage({super.key, required this.model});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColors.secondaryColor,
      body: Column(
        children: [
          // --- HEADER (Custom Back Button & Title) ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  Text(
                    "Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // FAVORITE BUTTON (Real Logic)
                  IconButton(
                    onPressed: () {
                      DatabaseService().toggleWhislist(widget.model);
                      setState(() => isFavorite = !isFavorite);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Wishlist updated!")),
                      );
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- BODY (Image & Info) ---
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(widget.model.imagepath, height: 200),
                    ), // Use Network Image
                    SizedBox(height: 20),
                    Text(
                      widget.model.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.model.formattedPrice,
                      style: TextStyle(
                        fontSize: 20,
                        color: MainColors.secondaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Delicious food specifically made for you with high-quality ingredients.",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Spacer(),

                    // --- ADD TO CART BUTTON (Real Logic) ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await DatabaseService().addToCart(widget.model);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: MainColors.secondaryColor,
                                content: Text("Added to Basket!"),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MainColors.secondaryColor,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "Add to Cart",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
