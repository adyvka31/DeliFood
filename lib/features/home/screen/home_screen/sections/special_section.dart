part of '../home_screen.dart';

class SpecialSection extends StatefulWidget {
  const SpecialSection({super.key});

  @override
  State<SpecialSection> createState() => _SpecialSectionState();
}

class _SpecialSectionState extends State<SpecialSection> {

  bool _isClaimed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30, left: 25, right: 25),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Special For You",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "See All",
                    style: TextStyle(
                      color: MainColors.secondaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        SpecialWidget(
          imagePath: 'assets/images/special1.png',
          discount: '40%',
          isClaimed: _isClaimed,
          onClaim: () {
            setState(() {
              _isClaimed = true;
            });
            showSuccessDialog(context);
          },
        ),
      ],
    );
  }
}
