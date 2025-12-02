part of '../home_screen.dart';

class FilteredItemSection extends StatefulWidget {
  const FilteredItemSection({super.key, required this.category});

  final List<String> category;

  @override
  State<FilteredItemSection> createState() => _FilteredItemSectionState();
}

class _FilteredItemSectionState extends State<FilteredItemSection> {
  // State untuk kategori yang dipilih, default 'Hottest'
  String selectedCategory = "Hottest";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. DAFTAR KATEGORI (HORIZONTAL)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SizedBox(
            height: 30,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.category.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final catName = widget.category[index];
                final isSelected = selectedCategory == catName;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = catName;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: isSelected
                        ? BoxDecoration(
                            color: MainColors.secondaryColor,
                            borderRadius: BorderRadius.circular(15),
                          )
                        : null,
                    child: Text(
                      catName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 2. DAFTAR PRODUK SESUAI KATEGORI (REAL DATA)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SizedBox(
            height: 195,
            child: StreamBuilder<List<ItemFoodModel>>(
              // Panggil fungsi getProducts dengan parameter category yang dipilih
              stream: DatabaseService().getProducts(
                "",
                category: selectedCategory,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading data"));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final products = snapshot.data!;

                if (products.isEmpty) {
                  return Center(
                    child: Text(
                      "No items in $selectedCategory",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final item = products[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // Mengirim model asli ke halaman detail
                            builder: (context) => DetailPage(model: item),
                          ),
                        );
                      },
                      child: CardFood(
                        width: 180,
                        height: 185,
                        title: item.title,
                        // Menggunakan formattedPrice agar sesuai format Rupiah
                        price: item.formattedPrice,
                        imagePath: item.imagepath,
                        // Logika warna background selang-seling tetap dipertahankan
                        backgroundColor: index % 2 == 0
                            ? const Color.fromARGB(255, 235, 255, 250)
                            : const Color(0xffF1EFF6),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
