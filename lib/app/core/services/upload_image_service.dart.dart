// ignore_for_file: unintended_html_in_doc_comment

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service untuk menangani operasi terkait upload image ke Supabase
class UploadImageService {
  final ImagePicker _picker;

  UploadImageService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  /// Memilih gambar tunggal dari galeri
  /// Return XFile jika berhasil, null jika dibatalkan
  Future<XFile?> pickSingleImage({
    double? maxResolution = 800,
    int quality = 80,
  }) async {
    return await _picker.pickImage(
      maxHeight: maxResolution,
      maxWidth: maxResolution,
      source: ImageSource.gallery,
      imageQuality: quality,
    );
  }

  /// Memilih beberapa gambar dari galeri
  /// Return List<XFile> jika berhasil, empty list jika dibatalkan
  Future<List<XFile>> pickMultipleImages({
    double? maxResolution = 800,
    int quality = 80,
  }) async {
    return await _picker.pickMultiImage(
      maxHeight: maxResolution,
      maxWidth: maxResolution,
      imageQuality: quality,
    );
  }

  /// Upload gambar tunggal ke Supabase storage
  /// Return Either dengan URL gambar jika berhasil atau error message jika gagal
  Future<Either<String, String>> uploadSingleFile({
    required XFile file,
    required String bucketName,
    String? folderPath,
    int expiryDuration = 157680000,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final fileExt = file.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = folderPath != null ? '$folderPath/$fileName' : fileName;

      await supabase.storage
          .from(bucketName)
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(contentType: file.mimeType),
          );

      final imageUrl = await supabase.storage
          .from(bucketName)
          .createSignedUrl(filePath, expiryDuration);

      return Right(imageUrl);
    } on StorageException catch (error) {
      snackbarError(message: error.message);
      return Left(error.message);
    } catch (error) {
      snackbarError(message: error.toString());
      return Left(error.toString());
    }
  }

  /// Upload beberapa gambar ke Supabase storage
  /// Return Either dengan List URL gambar jika berhasil atau error message jika gagal
  Future<Either<String, List<String>>> uploadMultipleFiles({
    required List<XFile> files,
    required String bucketName,
    String? folderPath,
    int expiryDuration = 157680000,
  }) async {
    try {
      List<String> uploadedUrls = [];

      for (var i = 0; i < files.length; i++) {
        final file = files[i];
        final bytes = await file.readAsBytes();
        final fileExt = file.path.split('.').last;
        final fileName = '${DateTime.now().toIso8601String()}_$i.$fileExt';
        final filePath =
            folderPath != null ? '$folderPath/$fileName' : fileName;

        await supabase.storage
            .from(bucketName)
            .uploadBinary(
              filePath,
              bytes,
              fileOptions: FileOptions(contentType: file.mimeType),
            );

        final imageUrl = await supabase.storage
            .from(bucketName)
            .createSignedUrl(filePath, expiryDuration);

        uploadedUrls.add(imageUrl);
      }

      return Right(uploadedUrls);
    } on StorageException catch (error) {
      snackbarError(message: error.message);
      return Left(error.message);
    } catch (error) {
      snackbarError(message: error.toString());
      return Left(error.toString());
    }
  }
}

// Helper function untuk backward compatibility
Future<String?> uploadImage({
  required String bucketName,
  String? folderPath,
  double? maxResolution = 800,
  int expiryDuration = 157680000,
}) async {
  final service = UploadImageService();
  final imageFile = await service.pickSingleImage(maxResolution: maxResolution);

  if (imageFile == null) return null;

  final result = await service.uploadSingleFile(
    file: imageFile,
    bucketName: bucketName,
    folderPath: folderPath,
    expiryDuration: expiryDuration,
  );

  return result.fold((error) => null, (url) => url);
}

// Helper function untuk backward compatibility
Future<List<String>?> uploadMultipleImage({
  required String bucketName,
  String? folderPath,
  double? maxResolution = 800,
  int expiryDuration = 157680000,
}) async {
  final service = UploadImageService();
  final imageFiles = await service.pickMultipleImages(
    maxResolution: maxResolution,
  );

  if (imageFiles.isEmpty) return null;

  final result = await service.uploadMultipleFiles(
    files: imageFiles,
    bucketName: bucketName,
    folderPath: folderPath,
    expiryDuration: expiryDuration,
  );

  return result.fold((error) => null, (urls) => urls);
}
