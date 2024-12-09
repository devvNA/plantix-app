// ignore_for_file: unnecessary_overrides

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/data/models/field_model.dart';
import 'package:plantix_app/app/data/repositories/field_repository.dart';

import '../../data/models/event_model.dart';

class CalendarController extends GetxController {
  final isLoading = false.obs;
  final RxList<Event> events = <Event>[].obs;
  var selectedDay = DateTime.now().obs;
  var focusedDay = DateTime.now().obs;
  var jenisTanaman = "".obs;
  final namaLahanController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final lokasiController = TextEditingController();
  DateTime? tanggalMulai;
  DateTime? tanggalPanen;

  final fieldList = <FieldModel>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  // Events untuk tanggal tertentu
  List<Event> getEventsForDay(DateTime day) {
    return events.where((event) {
      final startDate = DateTime(event.tanggalMulai.year,
          event.tanggalMulai.month, event.tanggalMulai.day);
      final endDate = DateTime(event.tanggalPanen.year,
          event.tanggalPanen.month, event.tanggalPanen.day);
      final currentDate = DateTime(day.year, day.month, day.day);

      return currentDate.isAtSameMomentAs(startDate) ||
          currentDate.isAtSameMomentAs(endDate) ||
          (currentDate.isAfter(startDate) && currentDate.isBefore(endDate));
    }).toList();
  }

  Future<void> getLahan() async {
    isLoading.value = true;
    final data = await FieldRepository().getMyFields();
    data.fold(
      (failure) {
        return snackbarError(
          message: "Gagal",
          body: failure.message,
        );
      },
      (value) {
        fieldList.addAll(value);
        log(fieldList.toString());
      },
    );
    fieldList.refresh();
    isLoading.value = false;
  }

  void addEvent(Event event) {
    events.value = [...events, event];
    update();
  }

  void removeEvent(Event event) {
    events.value = events.where((e) => e != event).toList();
    update();
  }

  @override
  onClose() {
    super.onClose();
  }
}
