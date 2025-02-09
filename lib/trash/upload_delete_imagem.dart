/*
/// Faz o upload da imagem para o Firebase Storage
Future<String?> uploadProfileImage() async {
  try {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;

    File file = File(pickedFile.path);
    String userId = FirebaseAuth.instance.currentUser!.uid;
    Reference ref = _storage.ref().child('profile_images/$userId.jpg');

    await ref.putFile(file);
    return await ref.getDownloadURL();
  } catch (e) {
    print("Erro ao fazer upload: $e");
    return null;
  }
}

/// Deleta a imagem do perfil do Firebase Storage
Future<void> deleteProfileImage() async {
  try {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    Reference ref = _storage.ref().child('profile_images/$userId.jpg');

    await ref.delete();
  } catch (e) {
    print("Erro ao deletar imagem: $e");
  }
}
*/