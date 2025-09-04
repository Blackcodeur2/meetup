import 'package:flutter/material.dart';
import 'package:meetup/shared/custom_app_bar.dart';
import 'package:meetup/views/discover/profile.dart';
import 'package:meetup/views/settings/profile_utilisateur.dart';

class SettingsPage extends StatelessWidget {
  final int selectedIndex;
  const SettingsPage({super.key, this.selectedIndex = 4});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const LoveAppBar(
        title: "Paramètres",
        showLogoutButton: false,
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Préférences", theme),
            const SizedBox(height: 12),
            _buildCard(
              children: [
                _buildCardListTile(
                  "Découverte",
                  Icons.explore,
                      () {},
                ),
                _buildCardListTile(
                  "Notifications",
                  Icons.notifications,
                      () {},
                ),
                _buildCardListTileWithTrailingText(
                  "Langue",
                  Icons.language,
                  "Français",
                      () {},
                ),
              ],
            ),
            const SizedBox(height: 28),
            _sectionTitle("Informations", theme),
            const SizedBox(height: 12),
            _buildCard(
              children: [
                _buildCardListTile(
                  "Mon compte",
                  Icons.person,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserProfilePage(),
                      ),
                    );
                  },
                ),
                _buildCardListTile(
                  "Aide et assistance",
                  Icons.help_outline,
                      () {},
                ),
                _buildCardListTile(
                  "Politique de confidentialité",
                  Icons.privacy_tip,
                      () {},
                ),
                _buildCardListTile(
                  "Conditions d’utilisation",
                  Icons.description,
                      () {},
                ),
                _buildCardListTileWithTrailingText(
                  "Version de l’application",
                  Icons.info_outline,
                  "1.2.3",
                      () {},
                ),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[600],
                  padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  // Action de déconnexion
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "Se déconnecter",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.indigo[700],
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 4,
      shadowColor: Colors.black12,
      child: Column(children: children),
    );
  }

  Widget _buildCardListTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.indigo[100],
        child: Icon(icon, color: Colors.indigo[700]),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      onTap: onTap,
    );
  }

  Widget _buildCardListTileWithTrailingText(
      String title,
      IconData icon,
      String trailingText,
      VoidCallback onTap,
      ) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.indigo[100],
        child: Icon(icon, color: Colors.indigo[700]),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      trailing: Text(
        trailingText,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      onTap: onTap,
    );
  }
}
