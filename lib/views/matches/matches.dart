import 'package:flutter/material.dart';
import 'package:meetup/controllers/AuthController.dart';
import 'package:meetup/shared/custom_app_bar.dart';
import 'package:meetup/views/chats/chat.dart';
import 'package:meetup/views/chats/user_profile.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  final AuthController _authController = AuthController();
  List<Map<String, dynamic>> _users = [];
  bool _loading = true;

  // Valeurs de filtre
  RangeValues _ageRange = const RangeValues(18, 35);
  String _selectedLocation = "Douala, Cameroun";
  final List<String> _interests = [
    "Voyage",
    "Cuisine",
    "Musique",
    "Sport",
    "Lecture",
    "Cinéma",
    "Art",
    "Danse",
  ];
  final Set<String> _selectedInterests = {};

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

  // Appliquer le filtre (exemple simple)
  List<Map<String, dynamic>> get _filteredUsers {
    return _users.where((user) {
      // Age et intérêts fictifs pour l’exemple
      // Normalement, tu devrais récupérer age / intérêts depuis ta base
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: LoveAppBar(
        title: 'Matches',
        showLogoutButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.pink),
            tooltip: "Filtrer",
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Filtres",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Age
                const Text("Âge"),
                RangeSlider(
                  values: _ageRange,
                  min: 18,
                  max: 60,
                  divisions: 42,
                  labels: RangeLabels(
                    _ageRange.start.round().toString(),
                    _ageRange.end.round().toString(),
                  ),
                  activeColor: Colors.pink,
                  onChanged: (RangeValues values) {
                    setState(() {
                      _ageRange = values;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Localisation
                const Text("Localisation"),
                DropdownButton<String>(
                  value: _selectedLocation,
                  items:
                      [
                            "Douala, Cameroun",
                            "Yaoundé, Cameroun",
                            "Bafoussam, Cameroun",
                          ]
                          .map(
                            (loc) =>
                                DropdownMenuItem(value: loc, child: Text(loc)),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedLocation = value);
                    }
                  },
                ),
                const SizedBox(height: 20),

                // Intérêts
                const Text("Intérêts"),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _interests.map((interest) {
                    final isSelected = _selectedInterests.contains(interest);
                    return ChoiceChip(
                      label: Text(interest),
                      selected: isSelected,
                      selectedColor: Colors.pink,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedInterests.add(interest);
                          } else {
                            _selectedInterests.remove(interest);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const Spacer(),

                // Boutons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _ageRange = const RangeValues(18, 35);
                            _selectedLocation = "Douala, Cameroun";
                            _selectedInterests.clear();
                          });
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.pink),
                        ),
                        child: const Text(
                          "Réinitialiser",
                          style: TextStyle(color: Colors.pink),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                        ),
                        child: const Text("Appliquer"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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

            // Liste filtrée
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredUsers.isEmpty
                  ? const Center(child: Text("Aucun utilisateur trouvé"))
                  : ListView.separated(
                      itemCount: _filteredUsers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final user = _filteredUsers[index];
                        return Card(
                          shadowColor: Colors.black26,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            leading: CircleAvatar(
                              backgroundImage:
                                  (user['profile_url'] != null &&
                                      user['profile_url'].toString().isNotEmpty)
                                  ? NetworkImage(user['profile_url'])
                                  : const AssetImage('images/avatar.jpg')
                                        as ImageProvider,
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
                                  IconButton(
                                    icon: const Icon(
                                      Icons.person_outline,
                                      color: Colors.pink,
                                    ),
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
                                  IconButton(
                                    icon: const Icon(
                                      Icons.chat_bubble_outline,
                                      color: Colors.pink,
                                    ),
                                    tooltip: 'Commencer discussion',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatPage(
                                            userName:
                                                user['prenom'] ?? 'Utilisateur',
                                            userImage:
                                                user['profile_url'] ?? '',
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
