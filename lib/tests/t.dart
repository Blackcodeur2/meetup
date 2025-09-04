import 'package:flutter/material.dart';
import 'package:meetup/controllers/AuthController.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final AuthController _authController = AuthController();
  List<Map<String, dynamic>> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await _authController.getAllUsersExceptCurrent();
    setState(() {
      _users = users;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tous les utilisateurs")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: (user['profile_url'] != null &&
                            user['profile_url'].toString().isNotEmpty)
                        ? NetworkImage(user['profile_url'])
                        : const AssetImage('images/avatar.jpg') as ImageProvider,
                  ),
                  title: Text("${user['prenom']} ${user['nom']}"),
                  subtitle: Text(user['email'] ?? ''),
                );
              },
            ),
    );
  }
}
