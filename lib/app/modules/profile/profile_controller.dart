// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/snackbar_ext.dart';
import 'package:plantix_app/app/core/services/upload_image_service.dart.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  // final storage = LocalStorageService();
  // final hasStore = false.obs;
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> updateProfilePicture() async {
    isLoading = true;
    Get.back();
    update();
    final imageUrl = await uploadImage(
      bucketName: 'avatars',
      folderPath: 'profiles',
    );
    if (imageUrl != null) {
      await _onUpload(imageUrl);
    }
    isLoading = false;
  }

  /// Called when image has been uploaded to Supabase storage from within Avatar widget
  Future<void> _onUpload(String imageUrl) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      await supabase.from('users').upsert({
        'id': userId,
        'avatar_url': imageUrl,
      });
      await user.loadUserData();
      update();

      return Get.overlayContext!.showSnackBar(
        'Berhasil mengubah foto profil',
      );
    } on PostgrestException catch (error) {
      return snackbarError(message: error.message);
    } catch (error) {
      return snackbarError(message: error.toString());
    }
  }

  @override
  void onReady() {
    super.onReady();
    update();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
