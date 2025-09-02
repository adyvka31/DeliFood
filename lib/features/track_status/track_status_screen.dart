import 'package:ecommerce_mobile/components/app_back_button.dart';
import 'package:ecommerce_mobile/prefrences/color.dart';
import 'package:flutter/material.dart';

class TrackStatusScreen extends StatelessWidget {
  const TrackStatusScreen({super.key});

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
          "Delivery Status",
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
      body: ListView(
        padding: EdgeInsets.only(top: 25, left: 25, right: 25),
        children: [
          SizedBox(
            height: 135,
            child: ListView(
              clipBehavior: Clip.none,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                  width: 380,
                  child: OderItem(
                    "Quinoa Fruit Salad",
                    "2 Packs | 2 Kg | Normal",
                    "Rp 20.000",
                    'assets/images/detail-food.png',
                  ),
                ),
                SizedBox(width: 25),
                SizedBox(
                  width: 380,
                  child: OderItem(
                    "Melon Fruit Salad",
                    "1 Packs | 1 Kg | Normal",
                    "Rp 15.000",
                    'assets/images/combo1.png',
                  ),
                ),
                SizedBox(width: 25),
                SizedBox(
                  width: 380,
                  child: OderItem(
                    "Tropical Fruit Salad",
                    "1 Packs | 1 Kg | Normal",
                    "Rp 10.000",
                    'assets/images/combo2.png',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.payments_outlined,
                      size: 30,
                      color: MainColors.secondaryColor,
                    ),
                    SizedBox(height: 13),
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: MainColors.secondaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check, color: Colors.white, size: 13),
                    ),
                  ],
                ),
                SizedBox(
                  width: 70,
                  child: Divider(
                    color: MainColors.secondaryColor.withOpacity(0.4),
                    thickness: 2,
                  ),
                ),
                Column(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 30,
                      color: MainColors.secondaryColor,
                    ),
                    SizedBox(height: 13),
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: MainColors.secondaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check, color: Colors.white, size: 13),
                    ),
                  ],
                ),
                SizedBox(
                  width: 70,
                  child: Divider(
                    color: Colors.grey[300]?.withOpacity(0.4),
                    thickness: 2,
                  ),
                ),
                Column(
                  children: [
                    Icon(
                      Icons.local_shipping_outlined,
                      size: 30,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 13),
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check, color: Colors.white, size: 13),
                    ),
                  ],
                ),
                SizedBox(
                  width: 70,
                  child: Divider(
                    color: Colors.grey[300]?.withOpacity(0.4),
                    thickness: 2,
                  ),
                ),
                Column(
                  children: [
                    Icon(
                      Icons.person_outlined,
                      size: 30,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 13),
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check, color: Colors.white, size: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Order Status Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 30),
              OrderStatus(
                "Order Has Arrived - May 21",
                "Has arrived at the destination",
                "04:30 PM",
              ),
              OrderStatus(
                "Order In Transit - May 20",
                "Orders are sorted in Depok City",
                "05:00 AM",
              ),
              OrderStatus(
                "Order Customs - May 20",
                "Pesanan disortir di Kota Depok",
                "02:00 AM",
              ),
              OrderStatus(
                "Order Shipped - May 20",
                "Courier assigned to pick up",
                "11:15 PM",
              ),

              OrderStatus(
                "Order Is Packing - May 19",
                "Order Made",
                "09:00 PM",
              ),

              OrderStatus(
                "Verified Payments - May 19",
                "Payment Completed",
                "07:30 PM",
                isLast: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OderItem extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String image;

  const OderItem(
    this.title,
    this.description,
    this.price,
    this.image, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D202020),
            spreadRadius: -5,
            blurRadius: 30,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[200]?.withOpacity(0.5),
            ),
            child: Image.asset(image, width: 90, height: 90),
          ),
          SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 3),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[400],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  price,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderStatus extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final bool isLast;

  const OrderStatus(
    this.title,
    this.description,
    this.time, {
    super.key,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: MainColors.secondaryColor.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: MainColors.secondaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            if (!isLast)
              SizedBox(
                height: 45,
                child: VerticalDivider(
                  color: MainColors.secondaryColor.withOpacity(0.5),
                  thickness: 1.5,
                ),
              ),
          ],
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  Text(
                    time,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
