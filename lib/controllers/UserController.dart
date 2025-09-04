import 'package:meetup/controllers/AuthController.dart';
import 'package:meetup/core/const.dart';
import 'package:meetup/types/post.dart';

class UserController {

  final String? userId = AuthController.getCurrentUserId();
  // Créer un post avec soit du texte, soit une image (URL)
  Future<bool> createPost({required Post post}) async {
    try {
      if ((post.content == null || post.content.isEmpty) &&
          (post.imageUrl == null || post.imageUrl.isEmpty)) {
        print('Le post doit contenir du texte ou une image');
        return false;
      }

       await supabase.from('post').insert(post.toMap());
      print('Post créé avec contenu : ${post.content} et image : ${post.imageUrl}');
      return true;
    } catch (e) {
      print('Erreur création post: $e');
      return false;
    }
  }

  // Récupérer les posts, avec texte ou image
  Future<List<Map<String, dynamic>>> fetchPosts() async {
    // Simulé, à remplacer par backend réel
    return [
      {'content': 'Post texte exemple', 'imageUrl': ''},
      {'content': '', 'imageUrl': 'https://exemple.com/image.png'},
    ];
  }
}
