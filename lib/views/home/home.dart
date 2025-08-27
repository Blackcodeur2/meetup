import 'package:flutter/material.dart';
import 'package:meetup/shared/custom_app_bar.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: LoveAppBar(title: "Home", showLogoutButton: true),
      body: const Center(
        child: Text('Hello, world!'),
      ),
    );
  }
}