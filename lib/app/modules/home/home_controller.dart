// ignore_for_file: unnecessary_overrides

import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/modules/notification/notification_controller.dart';
import 'package:plantix_app/app/modules/seed_products/seed_products_controller.dart';

class HomeController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final RxList<String> weatherInfo = <String>[].obs;
  final RxInt currentIndex = 0.obs;
  final CarouselSliderController carouselSliderController =
      CarouselSliderController();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    Get.lazyPut<SeedProductsController>(() => SeedProductsController());
    fetchWeatherInfo();
    getNotificationLength();
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  Future<void> fetchWeatherInfo() async {
    // Simulasi fetch data cuaca
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1100));

    // weatherInfo.assignAll(['Cerah', '28°C', 'Kelembaban: 70%']);
    isLoading.value = false;
  }

  int getNotificationLength() {
    Get.lazyPut(() => NotificationController());
    return Get.find<NotificationController>().notifications.length;
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
