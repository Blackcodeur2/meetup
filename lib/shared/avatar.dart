import 'package:flutter/material.dart';
import 'package:meetup/shared/bottom_navigation_bar.dart';
import 'package:meetup/views/chats/discussions.dart';
import 'package:meetup/views/discover/discover.dart';
import 'package:meetup/views/matches/matches.dart';
import 'package:meetup/views/chats/chat.dart';
import 'package:meetup/views/settings/settings.dart';
import 'package:meetup/views/settings/profile_utilisateur.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  late Future<Map<String, dynamic>?> _userProfileFuture;

  @override
  void initState() {
    super.initState();
    _userProfileFuture = _fetchUserProfile();
  }

  Future<Map<String, dynamic>?> _fetchUserProfile() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Utilisateur non connecté');
    }

    try {
      return await supabase
          .from('profile')
          .select()
          .eq('user_id', user.id)
          .maybeSingle() as Map<String,dynamic>;
    } catch (e) {
      print('Erreur inconnue: $e');
      throw Exception('Erreur inattendue, veuillez réessayer.');
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> otherPages = [
      const DiscoverPage(),
      const MatchesPage(),
      const MessagesPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      body: _currentIndex == 0
          ? FutureBuilder<Map<String, dynamic>?>(
              future: _userProfileFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Erreur: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('Aucun profil trouvé.'));
                }
                final profile = snapshot.data!;
                return UserProfilePage(
                  nom: profile['nom'] ?? '',
                  prenom: profile['prenom'] ?? '',
                  dateNaissance: profile['dateNaissance'] ?? '',
                  sexe: profile['sexe'] ?? '',
                  preference: profile['preference'] ?? '',
                  email: profile['email'] ?? '',
                  profession: profile['profession'] ?? '',
                  pays: profile['pays'] ?? '',
                  ville: profile['ville'] ?? '',
                  bio: profile['bio'] ?? '',
                );
              },
            )
          : otherPages[_currentIndex - 1],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onPageChanged,
      ),
    );
  }
}
