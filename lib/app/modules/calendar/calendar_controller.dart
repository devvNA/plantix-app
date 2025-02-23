// ignore_for_file: unnecessary_overrides

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/widgets/custom_snackbar.dart';
import 'package:plantix_app/app/data/models/field_model.dart';
import 'package:plantix_app/app/data/repositories/calendar_repository.dart';
import 'package:plantix_app/app/data/repositories/field_repository.dart';

import '../../data/models/event_model.dart';

class CalendarController extends GetxController {
  final isLoading = false.obs;
  final RxList<EventModel> events = <EventModel>[].obs;
  var selectedDay = DateTime.now().obs;
  var focusedDay = DateTime.now().obs;
  var jenisTanaman = "".obs;
  final namaLahanController = TextEditingController();
  final notesController = TextEditingController();
  final alamatController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime? tanggal;
  final fieldList = <FieldModel>[].obs;

  @override
  void onInit() {
    getEvents();
    super.onInit();
  }

  // Events untuk tanggal tertentu
  List<EventModel> getEventsForDay(DateTime day) {
    return events.where((event) {
      final startDate = DateTime(event.eventDate?.year ?? 0,
          event.eventDate?.month ?? 0, event.eventDate?.day ?? 0);
      final endDate = DateTime(event.eventDate?.year ?? 0,
          event.eventDate?.month ?? 0, event.eventDate?.day ?? 0);
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

  Future<void> getEvents() async {
    isLoading.value = true;
    final data = await CalendarRepository().getMyEvents();
    data.fold(
      (failure) {
        return snackbarError(
          message: "Gagal",
          body: failure.message,
        );
      },
      (value) {
        events.addAll(value);
        log(events.toString());
      },
    );
    events.refresh();
    update();
    isLoading.value = false;
  }

  Future<void> createEvent() async {
    isLoading.value = true;
    final data = await CalendarRepository().createEvent(
      fieldName: namaLahanController.text,
      notes: notesController.text,
      address: fieldList
          .firstWhere((field) => field.fieldName == namaLahanController.text)
          .address,
      eventDate: tanggal!.toIso8601String(),
    );

    data.fold(
      (failure) {
        return snackbarError(
          message: "Gagal",
          body: failure.message,
        );
      },
      (value) async {
        await onRefresh();
        snackbarSuccess(
          message: "Sukses",
          body: "Jadwal berhasil ditambahkan",
        );
      },
    );
    isLoading.value = false;
  }

  Future<void> deleteEvent(EventModel event) async {
    isLoading.value = true;
    try {
      await CalendarRepository().deleteEvent(event.id);
      events.value = events.where((e) => e != event).toList();
      snackbarSuccess(
        message: "Sukses",
        body: "Jadwal berhasil dihapus",
      );
      update();
    } catch (e) {
      snackbarError(
        message: "Gagal",
        body: e.toString(),
      );
    }
    isLoading.value = false;
  }

  Future<void> onRefresh() async {
    isLoading.value = true;
    events.clear();
    update();
    await getEvents();
    isLoading.value = false;
  }

  void removeEvent(EventModel event) {
    events.value = events.where((e) => e != event).toList();
    update();
  }

  @override
  onClose() {
    super.onClose();
  }
}
