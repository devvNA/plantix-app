// ignore_for_file: unnecessary_overrides

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/data/models/event_model.dart';
import 'package:plantix_app/app/modules/notification/notification_controller.dart';
import 'package:plantix_app/app/modules/seed_products/seed_products_controller.dart';

class CalendarController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final RxList<String> weatherInfo = <String>[].obs;
  final RxInt currentIndex = 0.obs;
  final CarouselSliderController carouselSliderController =
      CarouselSliderController();
  final isLoading = false.obs;

  // Menambahkan selectedDate dengan Rxn untuk memungkinkan null
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();

  // // Menambahkan Map untuk menyimpan events per tanggal
  // final RxMap<DateTime, List<PlantingEvent>> _events =
  //     <DateTime, List<PlantingEvent>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInfo();
    Get.lazyPut<SeedProductsController>(() => SeedProductsController());
    Get.lazyPut<NotificationController>(() => NotificationController());

    // Inisialisasi selectedDate dengan tanggal saat ini
    selectedDate.value = DateTime.now();
    getEventsForDay(DateTime.now());
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  Future<void> fetchInfo() async {
    // Simulasi fetch data
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1100));
    isLoading.value = false;
  }

  int getNotificationLength() {
    return Get.find<NotificationController>().notifications.length;
  }

  // Memperbarui selectedDate
  updateSelectedDate(DateTime date) {
    selectedDate.value = date;
    getEventsForDay(date);
  }

  // Tambahkan peta events
  final events = <PlantingEvent>{
    PlantingEvent(
      title: 'Tanam',
      fieldName: 'Padi',
      date: DateTime(2024, 10, 7),
      events: [
        Event('Tanam', Colors.red),
        Event('Pupuk Dasar', Colors.amber),
        Event('Perlakuan benih', Colors.purple),
      ],
    ),
    PlantingEvent(
      title: 'Tanam',
      fieldName: 'Padi',
      date: DateTime(2024, 10, 8),
      events: [
        Event('Irigasi', Colors.blue),
        Event('Tanam', Colors.red),
        Event('Pupuk Dasar', Colors.amber),
        Event('Perlakuan benih', Colors.purple),
      ],
    ),
    PlantingEvent(
      title: 'Penyulaman',
      fieldName: 'Padi',
      date: DateTime(2024, 10, 9),
      events: [
        Event('Penyulaman', Colors.green),
        Event('Tanam', Colors.red),
        Event('Pupuk Dasar', Colors.amber),
        Event('Perlakuan benih', Colors.purple),
      ],
    ),
    PlantingEvent(
      title: 'Penyulaman',
      fieldName: 'Padi',
      date: DateTime(2024, 10, 10),
      events: [Event('Penyulaman', Colors.green)],
    ),
    PlantingEvent(
      title: 'Penyulaman',
      fieldName: 'Padi',
      date: DateTime(2024, 10, 11),
      events: [Event('Penyulaman', Colors.green)],
    ),
  };

  // Tambahkan metode untuk mendapatkan events pada hari tertentu
  PlantingEvent getEventsForDay(DateTime day) {
    return events.firstWhere(
      (event) =>
          event.date.year == day.year &&
          event.date.month == day.month &&
          event.date.day == day.day,
      orElse: () => PlantingEvent(
        title: 'No Event',
        fieldName: '',
        date: DateTime(day.year, day.month, day.day),
        events: [],
      ),
    );
  }

  @override
  onReady() {
    super.onReady();
  }

  @override
  onClose() {
    super.onClose();
  }
}
