// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';
import 'package:plantix_app/app/core/helpers/db_services.dart';

class ProfileController extends GetxController {
  final storage = LocalStorageService();
  final user = UserManager().currentUser;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
