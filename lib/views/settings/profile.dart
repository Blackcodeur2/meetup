import 'package:flutter/material.dart';
import 'package:meetup/shared/custom_app_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: const LoveAppBar(title: 'Profil', showLogoutButton: false),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 70),
            child: SizedBox(
              width: screenSize.width,
              height:
                  screenSize.height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top,
              child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 90, 24, 24),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: const [
                              Text(
                                'Sophie, 28',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Paris, France',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 24),
                            ],
                          ),
                        ),
                        _buildProfileSection('Mon profil', [
                          _buildSubSection('Bio', 'Ajouter des informations'),
                          _buildSubSection(
                            'Emploi',
                            'Ajouter des informations',
                          ),
                          _buildSubSection(
                            'Formation',
                            'Ajouter des informations',
                          ),
                          _buildSubSection(
                            'Mes centres d\'intérêt',
                            'Ajouter des informations',
                          ),
                          _buildSubSection(
                            'Mes langues',
                            'Ajouter des informations',
                          ),
                          _buildSubSection(
                            'Mes réseaux sociaux',
                            'Ajouter des informations',
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          CircleAvatar(
            radius: 70,
            backgroundColor: Colors.transparent,
            backgroundImage: const NetworkImage('https://picsum.photos/200'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildSubSection(String title, String subtitle) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
