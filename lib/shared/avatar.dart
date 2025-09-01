import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetup/core/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Avatar extends StatefulWidget {
  const Avatar({
    super.key,
    required this.imageUrl,
    required this.onUpload,
  });

  final String? imageUrl;
  final void Function(String) onUpload;

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.imageUrl == null || widget.imageUrl!.isEmpty)
          Container(
            width: 150,
            height: 150,
            color: Colors.grey,
            child: const Center(
              child: Text('No Image'),
            ),
          )
        else
          Image.network(
            widget.imageUrl!,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        ElevatedButton(
          onPressed: _isLoading ? null : _upload,
          child: const Text('Upload'),
        ),
      ],
    );
  }

  Future<void> _upload() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if(image != null){
      return;
    }
    final imageBytes = await image?.readAsBytes();
    final userId = supabase.auth.currentUser?.id;
    final imageChemin = '/$userId/profile';
    if (userId != null && imageBytes != null) {
      supabase.storage.from('profilebucket').updateBinary(imageChemin, imageBytes);
      final imageUrl = supabase.storage.from('profilebucket').getPublicUrl(imageChemin);
      widget.onUpload(imageUrl);
    }
  }
}
