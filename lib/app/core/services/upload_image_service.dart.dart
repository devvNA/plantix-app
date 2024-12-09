import 'package:image_picker/image_picker.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<String?> uploadImage({
  required String bucketName,
  String? folderPath,
  double? maxResolution = 800,
  int expiryDuration = 157680000,
}) async {
  final picker = ImagePicker();
  final imageFile = await picker.pickImage(
    maxHeight: maxResolution,
    maxWidth: maxResolution,
    source: ImageSource.gallery,
    imageQuality: 80,
  );

  if (imageFile == null) return null;

  try {
    final bytes = await imageFile.readAsBytes();
    final fileExt = imageFile.path.split('.').last;
    final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
    final filePath = folderPath != null ? '$folderPath/$fileName' : fileName;

    await supabase.storage.from(bucketName).uploadBinary(
          filePath,
          bytes,
          fileOptions: FileOptions(contentType: imageFile.mimeType),
        );

    final imageUrl = await supabase.storage
        .from(bucketName)
        .createSignedUrl(filePath, expiryDuration);

    return imageUrl;
  } on StorageException catch (error) {
    snackbarError(message: error.message);
    return null;
  } catch (error) {
    snackbarError(message: error.toString());
    return null;
  }
}

Future<List<String>?> uploadMultipleImage({
  required String bucketName,
  String? folderPath,
  double? maxResolution = 800,
  int expiryDuration = 157680000,
}) async {
  final picker = ImagePicker();
  final imageFiles = await picker.pickMultiImage(
    maxHeight: maxResolution,
    maxWidth: maxResolution,
    imageQuality: 80,
  );

  if (imageFiles.isEmpty) return null;

  try {
    List<String> uploadedUrls = [];

    for (var imageFile in imageFiles) {
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName =
          '${DateTime.now().toIso8601String()}_${uploadedUrls.length}.$fileExt';
      final filePath = folderPath != null ? '$folderPath/$fileName' : fileName;

      await supabase.storage.from(bucketName).uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(contentType: imageFile.mimeType),
          );

      final imageUrl = await supabase.storage
          .from(bucketName)
          .createSignedUrl(filePath, expiryDuration);

      uploadedUrls.add(imageUrl);
    }

    return uploadedUrls;
  } on StorageException catch (error) {
    snackbarError(message: error.message);
    return null;
  } catch (error) {
    snackbarError(message: error.toString());
    return null;
  }
}
