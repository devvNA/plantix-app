import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';

class CustomSnackBar {
  //SNACKBAR SUCCESS
  static showCustomSuccessSnackBar({
    required String title,
    required String message,
    Duration? duration,
    bool? isDismissible,
    Color? color,
  }) {
    Get.closeAllSnackbars(); // Menutup semua snackbar yang aktif
    Get.snackbar(
      title,
      message,
      borderColor: AppColors.success,
      borderWidth: 1,
      borderRadius: 0,
      backgroundColor: Color(0xFFEEEEEC),
      leftBarIndicatorColor: color ?? AppColors.success,
      duration: duration ?? const Duration(seconds: 2),
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      colorText: Colors.black,
      icon: Icon(
        Icons.check_circle,
        color: color ?? AppColors.success,
      ),
      isDismissible: isDismissible ?? true,
    );
  }

  //SNACKBAR ERROR
  static showCustomErrorSnackBar({
    required String title,
    required String message,
    bool? isDismissible,
    Color? color,
    Duration? duration,
  }) {
    Get.closeAllSnackbars(); // Menutup semua snackbar yang aktif
    Get.snackbar(
      title,
      message,
      borderColor: AppColors.error,
      borderWidth: 1,
      borderRadius: 0,
      backgroundColor: AppColors.background,
      leftBarIndicatorColor: color ?? AppColors.error,
      duration: duration ?? const Duration(seconds: 2),
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      colorText: Colors.black,
      icon: Icon(
        Icons.check_circle,
        color: color ?? AppColors.error,
      ),
      isDismissible: isDismissible ?? true,
    );
  }

  //SNACKBAR TOAST Success
  static showCustomToastSuccess({
    String? title,
    required String message,
    Color? color,
    bool? isDismissible,
    Duration? duration,
  }) {
    Get.closeAllSnackbars();
    Get.rawSnackbar(
        title: title,
        duration: duration ?? const Duration(seconds: 2),
        snackStyle: SnackStyle.GROUNDED,
        backgroundColor: color ?? Colors.green,
        onTap: (snack) {
          Get.closeAllSnackbars();
        },
        //overlayBlur: 0.8,
        message: message,
        isDismissible: isDismissible ?? true);
  }

  //SNACKBAR TOAST ERROR
  static showCustomErrorToast({
    String? title,
    String? message,
    bool? isDismissible,
    Color? color,
    Duration? duration,
  }) {
    Get.closeAllSnackbars();
    Get.rawSnackbar(
        // title: title ?? "Error",
        duration: duration ?? const Duration(milliseconds: 1500),
        snackStyle: SnackStyle.FLOATING,
        backgroundColor: color ?? const Color.fromARGB(242, 225, 31, 18),
        onTap: (snack) {
          Get.closeAllSnackbars();
        },
        //overlayBlur: 0.8,
        message: message ?? "masih dalam pengembangan",
        isDismissible: isDismissible ?? true);
  }

  static void showMaterialSnackbar({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
      duration: duration,
      backgroundColor: backgroundColor,
      action: action,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class AlertMessage extends StatelessWidget {
  const AlertMessage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert Message Example'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'This is an alert message',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'You can define alert body here',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
