import 'package:image_picker/image_picker.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<String?> uploadImage({
  required String bucketName,
  String? folderPath,
  double? maxWidth = 400,
  double? maxHeight = 400,
  int expiryDuration = 157680000,
}) async {
  final picker = ImagePicker();
  final imageFile = await picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: maxWidth,
    maxHeight: maxHeight,
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
