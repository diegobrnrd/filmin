import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:filmin/services/auth_service.dart';

class SupabaseStorageService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String bucketName = 'images';
  final AuthService _authService = AuthService();

  Future<String?> uploadImage(XFile imageFile) async {
    try {
      final currentProfilePictureUrl = await _authService.getProfilePictureUrl();
      if (currentProfilePictureUrl != null && currentProfilePictureUrl.isNotEmpty) {
        final deleteResult = await deleteImage(currentProfilePictureUrl);
        if (!deleteResult) {
          print('Erro ao deletar a imagem existente');
        }
      }

      final fileBytes = await imageFile.readAsBytes();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';

      await _supabase.storage.from(bucketName).uploadBinary(fileName, fileBytes);
      final imageUrl = getImageUrl(fileName);

      final error = await _authService.updateProfilePictureUrl(imageUrl);
      if (error != null) {
        print('Erro ao atualizar a URL da foto de perfil: $error');
        return null;
      }

      return imageUrl;
    } catch (e) {
      print('Erro ao fazer upload da imagem: $e');
      return null;
    }
  }

  String getImageUrl(String fileName) {
    return _supabase.storage.from(bucketName).getPublicUrl(fileName);
  }

  Future<bool> deleteImage(String imageUrl) async {
    try {
      final Uri uri = Uri.parse(imageUrl);
      final String fileName = uri.pathSegments.last;

      await _supabase.storage.from(bucketName).remove([fileName]);

      final error = await _authService.updateProfilePictureUrl('');
      if (error != null) {
        print('Erro ao atualizar a URL da foto de perfil: $error');
      }

      return true;
    } catch (e) {
      print('Erro ao deletar a imagem: $e');
      return false;
    }
  }

  Future<XFile?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery);
  }
}
