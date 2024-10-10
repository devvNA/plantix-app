import 'package:flutter/material.dart';

class NotificationModel {
  String? id;
  String? title;
  String? message;
  String? time;
  IconData? icon;
  bool? isRead;

  NotificationModel({
    this.id,
    this.title,
    this.message,
    this.time,
    this.icon,
    this.isRead,
  });
}
