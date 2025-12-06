part of '../home_screen.dart';

class RecomendedSection extends StatelessWidget {
  const RecomendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recomended Combo",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // MENGGANTI DATA DUMMY DENGAN STREAM BUILDER
        SizedBox(
          height: 210, // Tinggi area scroll horizontal
          child: StreamBuilder<List<ItemFoodModel>>(
            // Mengambil produk dengan kategori 'Combo'
            stream: DatabaseService().getProducts(""),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("Error loading data"));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final products = snapshot.data!;

              if (products.isEmpty) {
                return const Center(
                  child: Text(
                    "No Combo available",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final item = products[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            model: item, // Mengirim data asli dari Firebase
                          ),
                        ),
                      );
                    },
                    child: CardFood(
                      width: 182,
                      title: item.title,
                      price: item
                          .formattedPrice, // Menggunakan format harga dari model
                      imagePath: item.imagepath,
                      model: item,
                      backgroundColor: Colors.white,
                      boxShadow: const [],
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
