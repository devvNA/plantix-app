import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'notification_controller.dart';

class NotificationPage extends GetView<NotificationController> {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        centerTitle: true,
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return Dismissible(
                key: Key(notification.id ?? ''),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => controller.removeNotification(index),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: notification.isRead ?? false
                        ? Colors.grey
                        : Colors.blue,
                    child: Icon(notification.icon, color: Colors.white),
                  ),
                  title: Text(notification.title ?? ''),
                  subtitle: Text(notification.message ?? ''),
                  trailing: Text(notification.time ?? ''),
                  onTap: () => controller.markAsRead(index),
                ),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addRandomNotification,
        child: const Icon(Icons.add),
      ),
    );
  }
}
