import 'package:ecommerce_mobile/features/onboarding/onboarding2.dart';
import 'package:ecommerce_mobile/prefrences/color.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColors.secondaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Free Delivery",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Reach your destination faster with\nour free delivery service",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 90),
            SizedBox(
              width: 300,
              child: TextFormField(
                controller: _nameController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: "How can we call you?"),
              ),
            ),
            Image.asset(
              "assets/images/onboarding1.png",
              width: 350,
              height: 350,
            ),
            SizedBox(height: 90),
            ElevatedButton(
              onPressed: () {
                String nameController = _nameController.text;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Onboarding2(name: nameController),
                  ),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Let's Started"),
            ),
          ],
        ),
      ),
    );
  }
}
