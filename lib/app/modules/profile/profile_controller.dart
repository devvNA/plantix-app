// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/snackbar_ext.dart';
import 'package:plantix_app/app/core/services/upload_image_service.dart.dart';
import 'package:plantix_app/app/data/repositories/my_store_repository.dart';
import 'package:plantix_app/app/data/repositories/profile_repository.dart';
import 'package:plantix_app/main.dart';

class ProfileController extends GetxController {
  // final storage = LocalStorageService();
  // final hasStore = false.obs;
  bool isLoading = false;
  final profileRepository = ProfileRepository();
  final myStoreRepo = MyStoreRepository();

  @override
  void onInit() {
    super.onInit();
    // getStoreId();
    refreshStoreStatus();
  }

  /// Memperbarui status toko dengan mengambil data terbaru
  Future<void> refreshStoreStatus() async {
    await user.loadUserData();
    if (user.hasStore) {
      await myStore.loadStoreData();
    }
    update();
  }

  Future<void> updateProfilePicture() async {
    isLoading = true;
    Get.back();
    update();
    final imageUrl = await uploadImage(bucketName: 'avatars');
    if (imageUrl != null) {
      final data = await profileRepository.onUploadAvatar(imageUrl);
      data.fold(
        (failure) => Get.overlayContext!.showSnackBar(
          message: failure.message,
          isError: true,
        ),
        (success) =>
            Get.overlayContext!.showSnackBar(message: success, isError: false),
      );
      await refreshStoreStatus();
    }
    isLoading = false;
  }
}
