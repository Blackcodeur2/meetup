import 'package:flutter/material.dart';
import 'package:meetup/shared/custom_app_bar.dart';

class UserProfilePage extends StatelessWidget {
  final Map<String, dynamic> userData;
  const UserProfilePage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LoveAppBar(title: userData['name'] ?? 'Profil', showLogoutButton: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(userData['imageUrl'] ?? ''),
            ),
            const SizedBox(height: 12),
            Text(
              userData['name'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
            Text(
              '${userData['age']} ans, ${userData['location']}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildInfoCard('Biographie', userData['bio'] ?? 'Pas encore renseigné'),
            _buildInfoCard('Profession', userData['job'] ?? 'Pas encore renseigné'),
            _buildInfoCard('Formation', userData['education'] ?? 'Pas encore renseigné'),
            _buildListCard('Centres d’intérêt', userData['interests'] ?? []),
            _buildListCard('Langues', userData['languages'] ?? []),
            _buildSocialLinksCard('Réseaux sociaux', userData['socialLinks'] ?? {}),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
      ),
    );
  }

  Widget _buildListCard(String title, List<dynamic> items) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: items.isEmpty
            ? [const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Pas encore renseigné'),
              )]
            : items.map((item) => ListTile(title: Text(item.toString()))).toList(),
      ),
    );
  }

  Widget _buildSocialLinksCard(String title, Map<String, dynamic> links) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: links.isEmpty
            ? [const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Pas encore renseigné'),
              )]
            : links.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  subtitle: Text(entry.value),
                  onTap: () {
                    // Action d’ouvrir le lien (à compléter avec url_launcher par ex.)
                  },
                  trailing: const Icon(Icons.open_in_new),
                );
              }).toList(),
      ),
    );
  }
}
