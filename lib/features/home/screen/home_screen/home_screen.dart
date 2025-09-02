import 'package:ecommerce_mobile/features/home/screen/detail_screen/detail_screen.dart';
import 'package:ecommerce_mobile/prefrences/color.dart';
import 'package:flutter/material.dart';
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
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: MainColors.secondaryColor.withOpacity(0.5),
                    width: 3,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: MainColors.secondaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 50),
                ),
              ),
              SizedBox(height: 40),
              Text(
                "Congratulations!!!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1E222B),
                ),
              ),
              SizedBox(height: 7),
              Text(
                "Your coupon has been successfully claimed, let's use it immediately to get an attractive offer.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xff878787), fontSize: 16),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MainColors.secondaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                  child: Text(
                    "Use my coupon",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 7),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },

                  child: Text(
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

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, required this.name});

  final String name;

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
      endDrawer: Drawer(
        child: Column(
          children: [
            // Header Kustom
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 75, left: 20, bottom: 50),
              decoration: const BoxDecoration(color: MainColors.secondaryColor),
              child: const Text(
                'Notifications',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  NotificationItem(
                    logoAsset: 'assets/images/pizzahut.png',
                    title: 'Promo Spesial Pizza Hut!',
                    subtitle:
                        'Nikmati diskon 50% untuk pembelian kedua menu Large Pizza. Jangan sampai ketinggalan!',
                    time: '5 menit yang lalu',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Divider(height: 1, indent: 70),
                  ),
                  NotificationItem(
                    logoAsset: 'assets/images/sturbucks.png',
                    title: 'Starbucks: Minuman Favoritmu Menanti',
                    subtitle:
                        'Tukarkan 100 poin-mu dan dapatkan minuman gratis ukuran Tall. Berlaku hingga akhir bulan.',
                    time: '2 jam yang lalu',
                    isUnread: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Divider(height: 1, indent: 70),
                  ),
                  NotificationItem(
                    logoAsset: 'assets/images/kfc.png',
                    title: 'Pesananmu dari KFC Selesai',
                    subtitle:
                        'Pesanan #12345 dengan menu Super Besar 2 telah berhasil diselesaikan. Beri rating sekarang!',
                    time: 'Kemarin',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Divider(height: 1, indent: 70),
                  ),
                  NotificationItem(
                    logoAsset: 'assets/images/jco.png',
                    title: 'Pesanan J.CO sedang diantar',
                    subtitle:
                        'Pesanan #67890 dengan 1 lusin donat sedang dalam perjalanan menuju lokasimu.',
                    time: '1 jam yang lalu',
                    isUnread: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Divider(height: 1, indent: 70),
                  ),
                  NotificationItem(
                    logoAsset:
                        'assets/images/cfc.png', // Ganti dengan path logo Anda
                    title: 'CFC Kembali!',
                    subtitle:
                        'Rasakan kembali sensasi pedas favoritmu. Tersedia untuk waktu terbatas di seluruh gerai.',
                    time: '28 Agu 2025',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              children: [
                HeaderSection(
                  onNotificationTap: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
                SpecialSection(),
                SizedBox(height: 20),
                RecomendedSection(),
                SizedBox(height: 40),
                FilteredItemSection(category: category),
              ],
            ),
          );
        },
      ),
    );
  }
}

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 24, backgroundImage: AssetImage(logoAsset)),
          SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          if (isUnread)
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
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
  });

  @override
  State<CardFood> createState() => _CardFoodState();
}

class _CardFoodState extends State<CardFood> {
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
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
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isFavorited = !_isFavorited;
                });
              },
              child: Icon(
                _isFavorited ? Icons.favorite : Icons.favorite_border_rounded,
                color: _isFavorited
                    ? const Color(0xff047884)
                    : Color(0xff047884),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
