import 'package:ecommerce_mobile/components/app_back_button.dart';
import 'package:ecommerce_mobile/prefrences/color.dart';
import 'package:flutter/material.dart';

class WhislistScreen extends StatelessWidget {
  WhislistScreen({super.key});

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
        title: Text(
          "Whislist",
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: Colors.white, size: 25),
            style: IconButton.styleFrom(
              padding: EdgeInsets.all(9),
              backgroundColor: Colors.white.withOpacity(0.3),
              highlightColor: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 25, right: 25, left: 25),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WhislistProduct(
                "Honey Limo Combo",
                "4.5",
                "Rp 2.000",
                'assets/images/detail-food.png',
              ),
              WhislistProduct(
                "Bery Limo Combo",
                "4.8",
                "Rp 8.000",
                'assets/images/detail-food.png',
              ),
            ],
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WhislistProduct(
                "Quinoa Fruit Salad",
                "3.9",
                "Rp 10.000",
                'assets/images/detail-food.png',
              ),
              WhislistProduct(
                "Tropical Fruit Salad",
                "4.3",
                "Rp 10.000",
                'assets/images/detail-food.png',
              ),
            ],
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WhislistProduct(
                "Melon Fruit Salad",
                "4.9",
                "Rp 12.000",
                'assets/images/detail-food.png',
              ),
              WhislistProduct(
                "Honey Limo Combo",
                "4.5",
                "Rp 2.000",
                'assets/images/detail-food.png',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WhislistProduct extends StatefulWidget {
  final String title;
  final String rating;
  final String price;
  final String image;

  const WhislistProduct(
    this.title,
    this.rating,
    this.price,
    this.image, {
    super.key,
  });

  @override
  State<WhislistProduct> createState() => _WhislistProductState();
}

class _WhislistProductState extends State<WhislistProduct> {
  bool _isFavorited = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Image.asset(widget.image, width: 122),
            ),
            Positioned(
              top: 15,
              right: 15,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isFavorited = !_isFavorited;
                  });
                },
                child: Icon(
                  _isFavorited ? Icons.favorite_border_rounded : Icons.favorite,
                  color: _isFavorited ? Color(0xff047884) : Color(0xff047884),
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          widget.title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                SizedBox(width: 4),
                Text(
                  widget.rating,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Text("|", style: TextStyle(color: Colors.grey)),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Text("Health", style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
        SizedBox(height: 5),
        Text(
          widget.price,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: MainColors.secondaryColor,
          ),
        ),
      ],
    );
  }
}
