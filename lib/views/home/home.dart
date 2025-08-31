import 'package:flutter/material.dart';
import 'package:meetup/controllers/AuthController.dart';
import 'package:meetup/core/const.dart';
import 'package:meetup/shared/custom_app_bar.dart';
class HomePage extends StatefulWidget {
   HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  
}

class _HomePageState extends State<HomePage> {
  final authcontroller = AuthController();
  @override
  Widget build(BuildContext context) {
    
    final userEmail = authcontroller.getCurrentUserEmail();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: LoveAppBar(title: userEmail.toString(), showLogoutButton: true),
      body: const Center(
        child: Text('Home'),
      ),
    );
  }
}