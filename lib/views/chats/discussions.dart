import 'package:flutter/material.dart';
import 'package:meetup/core/theme.dart';
import 'package:meetup/shared/bottom_navigation_bar.dart';
import 'package:meetup/shared/custom_app_bar.dart';

class MessagesPage extends StatelessWidget {
  final int selectedIndex;
  const MessagesPage({super.key, this.selectedIndex = 2}); // 2 = Messages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: LoveAppBar(title: "Messages", showLogoutButton: false),
      body: Padding(
        padding: const EdgeInsets.only(top: 0, left: 16, right: 16),
        child: Column(
          children: [
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: "Rechercher",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: AppTheme.primaryColor,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  MessageItem(
                    name: "Sophie",
                    text: "Salut, comment vas-tu ?",
                    image: "https://randomuser.me/api/portraits/women/44.jpg",
                  ),
                  MessageItem(
                    name: "Alexandre",
                    text: "On se voit demain ?",
                    image: "https://randomuser.me/api/portraits/men/32.jpg",
                  ),
                  MessageItem(
                    name: "Camille",
                    text: "J’adore notre rendez-vous !",
                    image: "https://randomuser.me/api/portraits/women/65.jpg",
                  ),
                  MessageItem(
                    name: "Lucas",
                    text: "Tu es magnifique",
                    image: "https://randomuser.me/api/portraits/men/47.jpg",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageItem extends StatelessWidget {
  final String name;
  final String text;
  final String image;

  const MessageItem({
    super.key,
    required this.name,
    required this.text,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(image), radius: 22),
      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(text, style: TextStyle(color: AppTheme.primaryColor)),
      contentPadding: EdgeInsets.symmetric(vertical: 4),
      onTap: () {
        // Action lors du clic sur une conversation
      },
    );
  }
}
