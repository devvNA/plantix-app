// ignore_for_file: unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/data/models/notification_model.dart';

class NotificationController extends GetxController {
  final notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Menambahkan beberapa notifikasi contoh
    addRandomNotification();
    addRandomNotification();
    addRandomNotification();
  }

  void addRandomNotification() {
    final icons = [Icons.message, Icons.notification_important, Icons.event];
    notifications.add(NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Notifikasi Baru ${notifications.length + 1}',
      message: 'Ini adalah pesan notifikasi ${notifications.length + 1}',
      time: '${DateTime.now().hour}:${DateTime.now().minute}',
      icon: icons[notifications.length % icons.length],
    ));
  }

  void removeNotification(int index) {
    notifications.removeAt(index);
  }

  void markAsRead(int index) {
    notifications[index].isRead = true;
    notifications.refresh();
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
