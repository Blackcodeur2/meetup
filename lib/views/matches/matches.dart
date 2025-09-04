import 'package:flutter/material.dart';
import 'package:meetup/controllers/AuthController.dart';
import 'package:meetup/shared/custom_app_bar.dart';
import 'package:meetup/views/chats/chat.dart';
import 'package:meetup/views/chats/user_profile.dart'; // <-- importe ton AuthController

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  final AuthController _authController = AuthController();
  List<Map<String, dynamic>> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await _authController.getAllUsersExceptCurrent();
      setState(() {
        _users = users;
        _loading = false;
      });
    } catch (e) {
      print("Erreur chargement users: $e");
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: const LoveAppBar(title: 'Matches', showLogoutButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barre de recherche
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Rechercher',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Liste des correspondances
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _users.isEmpty
                      ? const Center(child: Text("Aucun utilisateur trouvé"))
                      : ListView.separated(
                          itemCount: _users.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final user = _users[index];
                            return Card(
                              shadowColor: Colors.black26,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                leading: CircleAvatar(
                                  backgroundImage: (user['profile_url'] != null &&
                                          user['profile_url'].toString().isNotEmpty)
                                      ? NetworkImage(user['profile_url'])
                                      : const AssetImage('images/avatar.jpg') as ImageProvider,
                                  radius: 30,
                                ),
                                title: Text(
                                  user['prenom'] ?? 'Utilisateur',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black87,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    user['email'] ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Bouton voir profil
                                      IconButton(
                                        icon: const Icon(Icons.person_outline,
                                            color: Colors.blue),
                                        tooltip: 'Voir profil',
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserProfilePage(userData: user),
                                            ),
                                          );
                                        },
                                      ),
                                      // Bouton discuter
                                      IconButton(
                                        icon: const Icon(Icons.chat_bubble_outline,
                                            color: Colors.green),
                                        tooltip: 'Commencer discussion',
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ChatPage(
                                                userName: user['prenom'] ?? 'Utilisateur',
                                                userImage: user['profile_url'] ?? '',
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserProfilePage(userData: user),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
