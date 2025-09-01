import 'package:flutter/material.dart';
import 'package:meetup/shared/custom_app_bar.dart';
import 'package:meetup/shared/main_page.dart';
import 'package:meetup/views/discover/profile.dart';

class SettingsPage extends StatelessWidget {
  final int selectedIndex;
  const SettingsPage({super.key, this.selectedIndex = 4});

  @override
  Widget build(BuildContext context) {
    const sectionTitleStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.black87,
    );

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: LoveAppBar(
        title: "Paramètres",
        showLogoutButton: false,
        showBackButton: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          const Text('Préférences', style: sectionTitleStyle),
          const SizedBox(height: 12),

          // Groupe Préférences dans une Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                _buildCardListTile('Découverte', Icons.explore, () {}),
                _buildCardListTile('Notifications', Icons.notifications, () {}),
                _buildCardListTileWithTrailingText('Langue', Icons.language, 'Français', () {}),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text('Informations', style: sectionTitleStyle),
          const SizedBox(height: 12),

          // Groupe Informations dans une Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                _buildCardListTile('Mon compte', Icons.person, (){Navigator.push(context,MaterialPageRoute(builder: (context) => MainPage()));}),
                _buildCardListTile('Aide et assistance', Icons.help_outline, () {}),
                _buildCardListTile('Politique de confidentialité', Icons.privacy_tip, () {}),
                _buildCardListTile('Conditions d\'utilisation', Icons.description, () {}),
                _buildCardListTileWithTrailingText('Version de l’application', Icons.info_outline, '1.2.3', () {}),
              ],
            ),
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.blueGrey.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Action déconnexion
              },
              child: const Text(
                'Se déconnecter',
                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardListTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade100,
        child: Icon(icon, color: Colors.blue.shade700),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      onTap: onTap,
      shape: const Border(bottom: BorderSide(color: Colors.grey, width: 0.15)),
    );
  }

  Widget _buildCardListTileWithTrailingText(String title, IconData icon, String trailingText, VoidCallback onTap) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade100,
        child: Icon(icon, color: Colors.blue.shade700),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Text(trailingText, style: const TextStyle(fontWeight: FontWeight.w600)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      onTap: onTap,
      shape: const Border(bottom: BorderSide(color: Colors.grey, width: 0.15)),
    );
  }
}
