// ignore_for_file: unnecessary_overrides

import 'package:carousel_slider/carousel_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/data/repositories/auth_repository.dart';
import 'package:plantix_app/app/modules/auth/login/login_controller.dart';
import 'package:plantix_app/app/modules/notification/notification_controller.dart';
import 'package:plantix_app/app/modules/profile/profile_controller.dart';
import 'package:plantix_app/app/modules/sales/sales_controller.dart';

class HomeController extends GetxController {
  DateTime timeBackPressed = DateTime.now();
  final RxInt selectedIndex = 0.obs;
  final RxList<String> weatherInfo = <String>[].obs;
  final RxInt currentIndex = 0.obs;
  final CarouselSliderController carouselSliderController =
      CarouselSliderController();
  final isLoading = false.obs;
  // final user = UserManager().currentUser;

  @override
  void onInit() async {
    super.onInit();

    getNotificationLength();
    Get.lazyPut(() => LoginController());
    Get.find<LoginController>().getUser();
    Get.put<SalesController>(SalesController());
    Get.put<ProfileController>(ProfileController());
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  Future<void> refreshHome() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 100));
    isLoading.value = false;
  }

  // Future<void> fetchWeatherInfo() async {
  //   // Simulasi fetch data cuaca
  //   isLoading.value = true;
  //   await Future.delayed(const Duration(seconds: 1));

  //   // weatherInfo.assignAll(['Cerah', '28°C', 'Kelembaban: 70%']);
  //   isLoading.value = false;
  // }

  int getNotificationLength() {
    Get.lazyPut(() => NotificationController());
    return Get.find<NotificationController>().notifications.length;
  }

  onBack() {
    final difference = DateTime.now().difference(timeBackPressed);
    final isExitWarning = difference >= const Duration(milliseconds: 1300);
    timeBackPressed = DateTime.now();
    if (isExitWarning) {
      const message = "Tekan kembali lagi untuk keluar";
      Fluttertoast.showToast(msg: message, fontSize: 12);
      return false;
    } else {
      Fluttertoast.cancel();
      return true;
    }
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
