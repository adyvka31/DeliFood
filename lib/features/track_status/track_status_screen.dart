import 'package:ecommerce_mobile/components/app_back_button.dart';
import 'package:ecommerce_mobile/features/home/model/order_model.dart';
import 'package:ecommerce_mobile/prefrences/color.dart';
import 'package:ecommerce_mobile/service/database_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrackStatusScreen extends StatefulWidget {
  const TrackStatusScreen({super.key});

  @override
  State<TrackStatusScreen> createState() => _TrackStatusScreenState();
}

class _TrackStatusScreenState extends State<TrackStatusScreen> {
  int _currentIndex = 0;
  late PageController _pageController;
  late Stream<OrderModel?> _orderStream;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller
    _pageController = PageController(viewportFraction: 0.8);
    _orderStream = DatabaseService().getLatestOrder();
  }

  @override
  void dispose() {
    // Hapus controller saat halaman ditutup agar hemat memori
    _pageController.dispose();
    super.dispose();
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
      // Menggunakan StreamBuilder untuk data Realtime
      body: StreamBuilder<OrderModel?>(
        stream: _orderStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Belum ada pesanan aktif"));
          }

          final order = snapshot.data!;

          // Logika untuk menentukan progress bar aktif
          int currentStep = 1;
          if (order.status == 'Preparing') currentStep = 2;
          if (order.status == 'Shipped') currentStep = 3;
          if (order.status == 'Delivered') currentStep = 4;

          return ListView(
            padding: const EdgeInsets.only(top: 25, left: 25, right: 0),
            children: [
              // List Produk Horizontal Dinamis
              if (order.items.length == 1)
                Padding(
                  padding: const EdgeInsets.only(
                    right: 25,
                  ), // Tambah padding kanan agar simetris (kiri sudah 25 dari ListView)
                  child: Builder(
                    builder: (context) {
                      final item = order.items[0];
                      int totalItemPrice =
                          (item['price'] as int) * (item['quantity'] as int);
                      final price = NumberFormat.currency(
                        locale: 'id',
                        symbol: 'Rp ',
                        decimalDigits: 0,
                      ).format(totalItemPrice);

                      return OderItem(
                        item['title'] ?? 'Item',
                        "${item['quantity']} Packs | Normal",
                        price,
                        item['imagepath'] ?? '',
                      );
                    },
                  ),
                )
              else
                // JIKA ITEM > 1, GUNAKAN PAGEVIEW SEPERTI BIASA
                SizedBox(
                  height: 135,
                  child: PageView.builder(
                    padEnds: false,
                    controller: _pageController,
                    itemCount: order.items.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final item = order.items[index];
                      int totalItemPrice =
                          (item['price'] as int) * (item['quantity'] as int);
                      final price = NumberFormat.currency(
                        locale: 'id',
                        symbol: 'Rp ',
                        decimalDigits: 0,
                      ).format(totalItemPrice);

                      return Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: OderItem(
                          item['title'] ?? 'Item',
                          "${item['quantity']} Packs | Normal",
                          price,
                          item['imagepath'] ?? '',
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 15),

              if (order.items.length > 1) // Hanya muncul jika item > 1
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(order.items.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 6,
                      // Jika aktif lebar 20 (panjang), jika tidak lebar 8 (bulat)
                      width: _currentIndex == index ? 15 : 6,
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? MainColors.secondaryColor
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Step 1: Placed
                    _buildStep(Icons.payments_outlined, 1, currentStep),
                    _buildLine(1, currentStep),
                    // Step 2: Preparing
                    _buildStep(Icons.inventory_2_outlined, 2, currentStep),
                    _buildLine(2, currentStep),
                    // Step 3: Shipped
                    _buildStep(Icons.local_shipping_outlined, 3, currentStep),
                    _buildLine(3, currentStep),
                    // Step 4: Delivered
                    _buildStep(Icons.person_outlined, 4, currentStep),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // [PERUBAHAN 4] Timeline List Dinamis
              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Order Status Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Mengambil data timeline dari Firebase (dibalik agar terbaru di atas)
                    ...order.timeline.reversed.map((log) {
                      final bool isLast = order.timeline.first == log;
                      return OrderStatus(
                        "${log['title']} - ${log['date']}",
                        log['description'],
                        log['time'],
                        isLast: isLast,
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- Helper Widgets untuk menjaga Layout tetap sama tapi logic warnanya dinamis ---
  Widget _buildStep(IconData icon, int index, int currentStep) {
    // Jika step ini sudah dilewati, warnanya Hijau, jika belum Abu-abu
    bool isActive = currentStep >= index;
    Color color = isActive
        ? MainColors.secondaryColor
        : const Color(0xFFE0E0E0); // Grey[300]

    return Column(
      children: [
        Icon(icon, size: 30, color: color),
        const SizedBox(height: 13),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: const Icon(Icons.check, color: Colors.white, size: 13),
        ),
      ],
    );
  }

  Widget _buildLine(int index, int currentStep) {
    // Garis penghubung
    bool isActive = currentStep > index;
    Color color = isActive
        ? MainColors.secondaryColor.withOpacity(0.4)
        : const Color(0xFFE0E0E0).withOpacity(0.4);

    return SizedBox(width: 70, child: Divider(color: color, thickness: 2));
  }
}

// --- WIDGET ODERITEM & ORDERSTATUS (TIDAK ADA PERUBAHAN LAYOUT) ---

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
    final bool isNetworkImage = image.startsWith('http');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[200]?.withOpacity(0.5),
            ),
            child: isNetworkImage
                ? Image.network(
                    image,
                    width: 90,
                    height: 90,
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    image,
                    width: 90,
                    height: 90,
                    fit: BoxFit.contain,
                  ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: MainColors.secondaryColor.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
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
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
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
              const SizedBox(height: 5),
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
