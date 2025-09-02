import 'package:ecommerce_mobile/components/app_back_button.dart';
import 'package:ecommerce_mobile/features/features.dart';
import 'package:ecommerce_mobile/prefrences/color.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          "My Profile",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: MainColors.secondaryColor,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(17.0),
          child: Container(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 25, right: 25, left: 25),
        children: [
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
                        'assets/images/bg-profile.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 80,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: AssetImage(
                          'assets/images/pp-profile.png',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 55),
              Text(
                "Adyvka Pratama",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "31 July 2009",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Account",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              buildAccountField("Email", "rafifdyvka07@gmail.com"),
              SizedBox(height: 15),
              buildAccountField("Name", "Adyvka Pratama"),
              SizedBox(height: 15),
              buildAccountField("Date of Birth", "31 July 2009"),
              SizedBox(height: 15),
              buildAccountField("Adress", "West Java, Indonesia"),
              SizedBox(height: 30),
              Text(
                "Last Order",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 240,
                child: ListView(
                  clipBehavior: Clip.none,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
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
            ],
          ),
        ],
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
            padding: EdgeInsets.all(20),
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
                  padding: EdgeInsets.only(top: 12, bottom: 4),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 30,

                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 0),
                      elevation: 0,
                      backgroundColor: MainColors.secondaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text("Nilai", style: TextStyle(fontSize: 10)),
                  ),
                ),
                SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  height: 30,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: MainColors.secondaryColor,
                      padding: EdgeInsets.symmetric(vertical: 0),
                      side: BorderSide(color: MainColors.secondaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text("Beli Lagi", style: TextStyle(fontSize: 10)),
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

Widget buildAccountField(String label, String hintText) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade400),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: TextFormField(
            textAlign: TextAlign.end,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 15,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
