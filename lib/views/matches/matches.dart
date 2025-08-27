import 'package:flutter/material.dart';
import 'package:meetup/shared/custom_app_bar.dart';
import 'package:meetup/views/chats/user_profile.dart';

// Page Matches
class MatchesPage extends StatelessWidget {
  const MatchesPage({super.key});

  final List<Map<String, dynamic>> matches = const [
  {
    'name': 'Sophie',
    'age': '28',
    'gender': 'Femme',
    'location': 'Paris, France',
    'message': 'Salut, comment vas-tu ?',
    'imageUrl': 'https://picsum.photos/id/1011/100/100',
    'bio': 'Amoureuse de la nature, passionnée de randonnées et de photographie.',
    'job': 'Graphiste',
    'education': 'Master en Design Graphic',
    'interests': ['Randonnée', 'Photographie', 'Voyages', 'Cuisine'],
    'languages': ['Français', 'Anglais'],
    'socialLinks': {
      'instagram': 'https://instagram.com/sophie.photographie',
      'facebook': 'https://facebook.com/sophie.dupont'
    }
  },
  {
    'name': 'Alexandre',
    'age': '30',
    'gender': 'Homme',
    'location': 'Lyon, France',
    'message': 'On se voit demain ?',
    'imageUrl': 'https://picsum.photos/id/1012/100/100',
    'bio': 'Entrepreneur passionné, amateur de vin et de jazz.',
    'job': 'Fondateur startup tech',
    'education': 'MBA',
    'interests': ['Vin', 'Jazz', 'Cyclisme'],
    'languages': ['Français', 'Anglais', 'Espagnol'],
    'socialLinks': {
      'linkedin': 'https://linkedin.com/in/alexandre123'
    }
  },
  {
    'name': 'Camille',
    'age': '26',
    'gender': 'Femme',
    'location': 'Marseille, France',
    'message': 'J\'ai adoré notre rendez-vous !',
    'imageUrl': 'https://picsum.photos/id/1013/100/100',
    'bio': 'Amateur de théâtre et de musique classique, toujours prête pour une nouvelle aventure.',
    'job': 'Professeur de musique',
    'education': 'Licence musique',
    'interests': ['Théâtre', 'Musique classique', 'Lecture'],
    'languages': ['Français'],
    'socialLinks': {}
  },
  {
    'name': 'Lucas',
    'age': '29',
    'gender': 'Homme',
    'location': 'Toulouse, France',
    'message': 'Tu es magnifique',
    'imageUrl': 'https://picsum.photos/id/1014/100/100',
    'bio': 'Fan de football, amateur de cuisine italienne et explorateur urbain.',
    'job': 'Chef cuisinier',
    'education': 'Diplôme en gastronomie',
    'interests': ['Football', 'Cuisine', 'Voyages'],
    'languages': ['Français', 'Italien'],
    'socialLinks': {
      'instagram': 'https://instagram.com/lucas_foodie'
    }
  },
];


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
              child: ListView.separated(
                itemCount: matches.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final match = matches[index];
                  return Card(
                    shadowColor: Colors.black26,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(match['imageUrl']!),
                        radius: 30,
                      ),
                      title: Text(
                        match['name']!,
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
                          match['message']!,
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
                              icon: const Icon(Icons.person_outline, color: Colors.blue),
                              tooltip: 'Voir profil',
                              onPressed: () {
                                // Ouvre une page profil (à créer)
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserProfilePage(userData: match),
                                  ),
                                );
                              },
                            ),
                            // Bouton discuter (ouvre le chat)
                            IconButton(
                              icon: const Icon(Icons.chat_bubble_outline, color: Colors.green),
                              tooltip: 'Commencer discussion',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChatPage(userName: match['name']!, userImage: match['imageUrl']!),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        // Par exemple ouvrir profil au tap sur la carte
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfilePage(userData: match),
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

class ChatPage extends StatefulWidget {
  final String userName;
  final String userImage;

  const ChatPage({super.key, required this.userName, required this.userImage});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<_ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.insert(0, _ChatMessage(text: text, isMe: true));
    });
    _controller.clear();

    // Simulation réponse auto
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.insert(0, _ChatMessage(text: "Merci pour votre message !", isMe: false));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                const SizedBox(width: 16),
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.userImage),
                  radius: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.userName,
                  style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      gradient: msg.isMe
                          ? const LinearGradient(colors: [Color(0xFFE91E63), Color(0xFF9C27B0)])
                          : const LinearGradient(colors: [Colors.grey, Colors.blueGrey]),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(msg.isMe ? 16 : 0),
                        bottomRight: Radius.circular(msg.isMe ? 0 : 16),
                      ),
                    ),
                    child: Text(
                      msg.text,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Tapez votre message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE91E63),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isMe;

  _ChatMessage({required this.text, required this.isMe});
}

