import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Pour choisir une image
import 'package:meetup/controllers/AuthController.dart';
import 'package:meetup/controllers/UserController.dart'; // Controller User avec createPost etc
import 'package:meetup/core/const.dart';
import 'package:meetup/shared/custom_app_bar.dart';
import 'package:meetup/types/post.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authcontroller = AuthController();
  final userController = UserController();

  final TextEditingController _textController = TextEditingController();
  File? _pickedImage;

  final ImagePicker _picker = ImagePicker();

  List<Map<String, String>> adminUpdates = [
    {
      'title': 'Annonce 1',
      'content': 'Bienvenue à notre nouvelle fonctionnalité de posts avec images.'
    },
    {
      'title': 'Mise à jour',
      'content': 'Maintenance programmée le 10 septembre à partir de 22h.'
    },
  ];

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitPost() async {
    String text = _textController.text.trim();

    String? imageUrl;
    if (_pickedImage != null) {
      // TODO: uploader image sur stockage (Firebase, Supabase...)
      // Simulé ici : utiliser _pickedImage.path pour upload et récupérer url
      imageUrl = 'https://exemple.com/uploads/${_pickedImage!.path.split('/').last}';
    }

    if (text.isEmpty && imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez saisir un texte ou choisir une image.')),
      );
      return;
    }

    final Post post = Post(
      userId: userController.userId,
      content: text,
      imageUrl: imageUrl ?? '',
    );

    bool success = await userController.createPost(
      post: post,
    );

    if (success) {
      _textController.clear();
      setState(() {
        _pickedImage = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post créé avec succès !')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la création du post.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = authcontroller.getCurrentUserEmail();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: LoveAppBar(title: userEmail.toString(), showLogoutButton: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section création post
            Text('Créer un post', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Écrivez quelque chose...',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              minLines: 3,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.image),
                  label: Text('Choisir une image'),
                ),
                SizedBox(width: 12),
                if (_pickedImage != null)
                  Image.file(
                    _pickedImage!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
              ],
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _submitPost,
              child: Text('Publier'),
            ),

            Divider(height: 32),

            // Section mises à jour admin
            Text('Mises à jour administratives', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            ...adminUpdates.map((upd) => Card(
              child: ListTile(
                title: Text(upd['title'] ?? ''),
                subtitle: Text(upd['content'] ?? ''),
                leading: Icon(Icons.announcement),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
