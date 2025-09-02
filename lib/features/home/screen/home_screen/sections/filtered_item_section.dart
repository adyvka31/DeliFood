part of '../home_screen.dart';

class FilteredItemSection extends StatelessWidget {
  const FilteredItemSection({super.key, required this.category});

  final List<String> category;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SizedBox(
            height: 24,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Text(
                  category[index],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(width: 16);
              },
              itemCount: category.length,
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SizedBox(
            height: 185,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailPage()),
                    );
                  },
                  child: CardFood(
                    width: 180,
                    height: 185,
                    title: 'Quinoa fruit salad',
                    price: 'Rp 10.000',
                    imagePath: 'assets/images/hotest1.png',
                    backgroundColor: Color.fromARGB(255, 235, 255, 250),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0D202020),
                        spreadRadius: 0,
                        blurRadius: 0,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailPage()),
                    );
                  },
                  child: CardFood(
                    width: 180,
                    height: 185,
                    title: 'Tropical fruit salad',
                    price: 'Rp 10.000',
                    imagePath: 'assets/images/hotest2.png',
                    backgroundColor: Color.fromARGB(255, 240, 247, 254),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0D202020),
                        spreadRadius: 0,
                        blurRadius: 0,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailPage()),
                    );
                  },
                  child: CardFood(
                    width: 180,
                    height: 185,
                    title: 'Melon fruit salad',
                    price: 'Rp 10.000',
                    imagePath: 'assets/images/hotest1.png',
                    backgroundColor: Color(0xffF1EFF6),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0D202020),
                        spreadRadius: 0,
                        blurRadius: 0,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
