import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetup/controllers/AuthController.dart';
import 'package:meetup/shared/custom_app_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'edit_profile.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Uint8List? _profileImage;
  final ImagePicker picker = ImagePicker();
  bool _showCameraIcon = true;

  Map<String, dynamic>? _userProfile;
  bool _loading = true;

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final authController = AuthController();
    final profile = await authController.getCurrentUserProfile();

    if (mounted) {
      setState(() {
        _userProfile = profile;
        _loading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final imageBytes = await image.readAsBytes();
      final currentUserId = supabase.auth.currentUser!.id;

      final imageName =
          'profile_images/${currentUserId}_${DateTime.now().millisecondsSinceEpoch}.png';

      try {
        await supabase.storage
            .from('profilebucket')
            .uploadBinary(imageName, imageBytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true));

        final publicUrl =
        supabase.storage.from('profilebucket').getPublicUrl(imageName);

        await supabase
            .from('profile')
            .update({'profile_url': publicUrl})
            .eq('user_id', currentUserId);

        setState(() {
          _profileImage = imageBytes;
          _showCameraIcon = false;
          if (_userProfile != null) {
            _userProfile!['profile_url'] = publicUrl;
          }
        });
      } catch (e) {
        print('Erreur upload image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const LoveAppBar(title: 'Profil', showLogoutButton: true),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _userProfile == null
          ? const Center(child: Text("Aucun profil trouvé"))
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Photo + bouton édition
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _profileImage != null
                        ? MemoryImage(_profileImage!)
                        : (_userProfile!['profile_url'] != null &&
                        _userProfile!['profile_url'].toString().isNotEmpty)
                        ? NetworkImage(_userProfile!['profile_url'])
                        : const AssetImage('images/avatar.jpg') as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: InkWell(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.pink,
                        child: const Icon(Icons.edit, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "${_userProfile!['prenom'] ?? ''} ${_userProfile!['nom'] ?? ''}",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Membre depuis 2022", // ⚡ Tu peux dynamiquement calculer ici
              style: TextStyle(color: Colors.grey[600]),
            ),

            const SizedBox(height: 24),

            // Informations personnelles
            _buildSectionTitle("Informations personnelles"),
            _buildInfoCard(Icons.email, "Email", _userProfile!['email'] ?? ''),
            _buildInfoCard(Icons.phone, "Téléphone", _userProfile!['telephone'] ?? ''),
            _buildInfoCard(Icons.cake, "Date de naissance",
                _userProfile!['dateNaissance'] ?? ''),
            _buildInfoCard(Icons.person, "Sexe", _userProfile!['sexe'] ?? ''),
            _buildInfoCard(Icons.favorite, "Préférence", _userProfile!['preference'] ?? ''),
            _buildInfoCard(Icons.location_on, "Pays", _userProfile!['pays'] ?? ''),
            _buildInfoCard(Icons.location_city, "Ville", _userProfile!['ville'] ?? ''),

            const SizedBox(height: 24),

            // Paramètres
            _buildSectionTitle("Paramètres"),
            SwitchListTile(
              value: true,
              onChanged: (val) {},
              title: const Text("Notifications"),
              secondary: const Icon(Icons.notifications_active, color: Colors.pink),
            ),
            SwitchListTile(
              value: false,
              onChanged: (val) {},
              title: const Text("Mode sombre"),
              secondary: const Icon(Icons.dark_mode, color: Colors.pink),
            ),
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.pink),
              title: const Text("Confidentialité"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white
              ),
              onPressed: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(userProfile: _userProfile!),
                  ),
                );
                if (updated == true) {
                  _loadProfile(); // recharge les infos après édition
                }
              },
              icon: const Icon(Icons.edit),
              label: const Text("Modifier le profil"),
            ),

          ],
        ),
      )
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, top: 12.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.pink),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(value),
      ),
    );
  }
}
