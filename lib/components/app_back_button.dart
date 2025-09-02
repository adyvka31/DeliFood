import 'package:ecommerce_mobile/features/home/screen/main_screen/main_screen.dart';
import 'package:ecommerce_mobile/prefrences/color.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;

  const AppBackButton({
    super.key,
    this.backgroundColor = Colors.white,
    this.iconColor = MainColors.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
            (route) => false,
          );
        },
        child: Icon(Icons.arrow_back, color: iconColor, size: 25),
      ),
    );
  }
}

class AppDeleteButton extends StatelessWidget {
  const AppDeleteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.delete, color: Colors.white, size: 25),
      ),
    );
  }
}
