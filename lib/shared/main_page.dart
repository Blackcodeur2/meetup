import 'package:flutter/material.dart';
import 'package:meetup/shared/bottom_navigation_bar.dart';
import 'package:meetup/tests/t.dart';
import 'package:meetup/views/chats/chat.dart';
import 'package:meetup/views/chats/discussions.dart';
import 'package:meetup/views/discover/discover.dart';
import 'package:meetup/views/home/home.dart';
import 'package:meetup/views/matches/matches.dart';
import 'package:meetup/views/discover/profile.dart';
import 'package:meetup/views/settings/profile_utilisateur.dart';
import 'package:meetup/views/settings/settings.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    UsersPage(),
    DiscoverPage(),
    MatchesPage(),
    MessagesPage(),
    SettingsPage(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onPageChanged,
      ),
    );
  }
}
