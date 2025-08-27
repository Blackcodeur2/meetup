import 'package:flutter/material.dart';
import 'package:meetup/shared/custom_app_bar.dart';

class User {
  final String name;
  final int age;
  final String description;
  final String imageUrl;

  User({
    required this.name,
    required this.age,
    required this.description,
    required this.imageUrl,
  });
}

final List<User> initialUsers = [
  User(
    name: "Sophie",
    age: 24,
    description:
        "Photographe passionnée, j’adore capturer des moments uniques et explorer de nouveaux horizons.",
    imageUrl: 'https://picsum.photos/id/1016/200/200',
  ),
  User(
    name: "John",
    age: 30,
    description: "Développeur passionné par les nouvelles technologies.",
    imageUrl: 'https://picsum.photos/id/1016/200/200',
  ),
  User(
    name: "Alex",
    age: 28,
    description:
        "Musicien et voyageur, toujours prêt à partager de belles aventures.",
    imageUrl: 'https://picsum.photos/id/1015/200/200',
  ),
  // Ajoutez d’autres utilisateurs
];

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  List<User> users = List<User>.from(initialUsers);

  void passUser(int index) {
    setState(() {
      users.removeAt(index);
    });
  }

  void likeUser(int index) {
    final likedUser = users[index];
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Vous aimez ${likedUser.name} !')));
    setState(() {
      users.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: LoveAppBar(title: 'Discover', showLogoutButton: false),
      body: users.isEmpty
          ? Center(child: Text('Aucun autre profil à découvrir'))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          user.imageUrl,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${user.age} ans',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 6),
                            Text(
                              user.description,
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: Colors.grey,
                                  ),
                                  onPressed: () => passUser(index),
                                  child: Text('Passer'),
                                ),
                                SizedBox(width: 16),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.green,
                                  ),
                                  onPressed: () => likeUser(index),
                                  child: Text('J’aime'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
