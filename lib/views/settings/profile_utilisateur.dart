import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetup/controllers/AuthController.dart';
import 'package:meetup/shared/custom_app_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Uint8List? _profileImage;
  final ImagePicker picker = ImagePicker();
  bool _showCameraIcon = true;

  Map<String, dynamic>? _userProfile; // les infos récupérées
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

        // Mise à jour du profil
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
      appBar: const LoveAppBar(title: 'My Profile', showLogoutButton: true),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _userProfile == null
              ? const Center(child: Text("Aucun profil trouvé"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            if (_showCameraIcon)
                              Positioned(
                                bottom: 0,
                                right: 4,
                                child: InkWell(
                                  onTap: _pickImage,
                                  child: CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Colors.indigo[700],
                                    child: const Icon(Icons.camera_alt,
                                        color: Colors.white, size: 24),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          '${_userProfile!['prenom'] ?? ''} ${_userProfile!['nom'] ?? ''}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Center(
                        child: Text(
                          _userProfile!['profession'] ?? '',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.grey[700],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      _infoRow(Icons.cake, 'Date de naissance',
                          _userProfile!['dateNaissance'] ?? ''),
                      const SizedBox(height: 12),
                      _infoRow(Icons.person, 'Sexe', _userProfile!['sexe'] ?? ''),
                      const SizedBox(height: 12),
                      _infoRow(Icons.favorite, 'Préférence',
                          _userProfile!['preference'] ?? ''),
                      const SizedBox(height: 12),
                      _infoRow(Icons.email, 'Email',
                          _userProfile!['email'] ?? ''),
                      const SizedBox(height: 12),
                      _infoRow(Icons.location_on, 'Pays', _userProfile!['pays'] ?? ''),
                      const SizedBox(height: 12),
                      _infoRow(Icons.location_city, 'Ville',
                          _userProfile!['ville'] ?? ''),
                      const SizedBox(height: 12),
                      Text(
                        'À propos',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _userProfile!['bio'] ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _infoRow(IconData icon, String label, String info) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.indigo[700]),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.indigo[700],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            info,
            style: TextStyle(fontSize: 15, color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }
}
