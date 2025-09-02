import 'package:ecommerce_mobile/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/prefrences/color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.light(),
        fontFamily: 'Open Sauce',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14),
            backgroundColor: Colors.white,
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14),
            side: BorderSide(color: MainColors.secondaryColor),
            foregroundColor: MainColors.secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: Color(0xffF3F1F1),
          filled: true,
          hintStyle: TextStyle(color: Color(0xffC2BDBD)),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: MainColors.secondaryColor,
          toolbarHeight: 60,
          surfaceTintColor: MainColors.secondaryColor,
          actionsPadding: EdgeInsets.only(right: 25),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
