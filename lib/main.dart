import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetup/core/constants.dart';
import 'package:meetup/core/theme.dart';
import 'package:meetup/shared/splash_page.dart';
import 'package:meetup/shared/welcome.dart';
import 'package:meetup/views/auth/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: ThemeData(colorScheme: ColorScheme.light(primary: Colors.black)),
      home: const LoginPage(),
    );
  }
}
