// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';

class ProfileController extends GetxController {
  // final storage = LocalStorageService();
  final hasStore = false.obs;
  // final user = UserManager().currentUser;

  @override
  void onInit() {
    super.onInit();
  }

  // Future<void> getUser() async {
  //   try {
  //     final userId = supabase.auth.currentSession!.user.id;
  //     final data =
  //         await supabase.from('users').select().eq('id', userId).single();
  //     name.value = data['name'];
  //     email.value = data['email'];
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
