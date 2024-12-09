import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';

import 'notification_controller.dart';

class NotificationPage extends GetView<NotificationController> {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () => controller.clearAllNotifications(),
            tooltip: 'Hapus Semua',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada notifikasi',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => controller.refreshNotifications(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: controller.notifications.length,
              itemBuilder: (context, index) {
                final notification = controller.notifications[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    elevation: notification.isRead ?? false ? 1 : 3,
                    child: Dismissible(
                      key: Key(notification.id ?? ''),
                      background: Container(
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => controller.removeNotification(index),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: notification.isRead ?? false
                                ? Colors.grey[300]
                                : AppColors.primary.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            notification.icon,
                            color: notification.isRead ?? false
                                ? Colors.grey[600]
                                : AppColors.primary,
                            size: 24,
                          ),
                        ),
                        title: Text(
                          notification.title ?? '',
                          style: TextStyle(
                            fontWeight: notification.isRead ?? false
                                ? FontWeight.normal
                                : FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              notification.message ?? '',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notification.time ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        onTap: () => controller.markAsRead(index),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: controller.addRandomNotification,
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
