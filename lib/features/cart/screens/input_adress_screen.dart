import 'package:ecommerce_mobile/features/track_status/track_status_screen.dart';
import 'package:ecommerce_mobile/prefrences/color.dart';
import 'package:flutter/material.dart';

class InputAdress extends StatefulWidget {
  const InputAdress({super.key});

  @override
  State<InputAdress> createState() => _InputAdressState();
}

class _InputAdressState extends State<InputAdress> {
  void showSuccessDialog() {
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
            height: 550,
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
                SizedBox(height: 50),
                Text(
                  "Congratulations!!!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1E222B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Your order have been taken and is being attended to",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xff878787), fontSize: 16),
                ),
                SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrackStatusScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MainColors.secondaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: Text(
                      "Track order",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },

                    child: Text(
                      "Continue shopping",
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

  void showModaPayWithCard() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              children: [
                buildInput("Card Holders Name", "Adyvka Pratama"),
                buildInput("Card Number", "1234 5678 9012 1314"),
                Row(
                  children: [
                    Expanded(child: buildInput("Date", "10/30")),
                    SizedBox(width: 15),
                    Expanded(child: buildInput("CCV", "123")),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();

                          showSuccessDialog();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: MainColors.secondaryColor,
                          elevation: 0,
                        ),
                        child: Text("Complete order"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          buildInput("Delivery address", "10th avenue, Lekki, Lagos State"),
          buildInput("Number we can call", "09090605708"),
          SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    showSuccessDialog();
                  },
                  style: OutlinedButton.styleFrom(),
                  child: Text("Pay on delivery"),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    showModaPayWithCard();
                  },
                  child: Text("Pay with card"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInput(String title, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 16),
          TextFormField(decoration: InputDecoration(hintText: hintText)),
        ],
      ),
    );
  }
}
