class Post {
  final String? userId;
  final String content; // contenu texte du post, peut être vide si post image
  final String imageUrl; // URL de l'image, vide si post texte

  Post({
    required this.userId,
    this.content = '',
    this.imageUrl = '',
  });

  // Méthode pour créer une instance Post à partir d'un Map (par ex. JSON)
  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      userId: map['userId'],
      content: map['content'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  // Méthode pour convertir une instance Post en Map (par ex. pour envoi API)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'content': content,
      'imageUrl': imageUrl,
    };
  }
}
