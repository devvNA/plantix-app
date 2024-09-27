import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackBar {
  //SNACKBAR SUCCESS
  static showCustomSuccessSnackBar(
      {required String title,
      required String message,
      Duration? duration,
      bool? isDismissible,
      Color? color}) {
    Get.closeAllSnackbars(); // Menutup semua snackbar yang aktif
    Get.snackbar(
      title,
      message,
      duration: duration ?? const Duration(seconds: 2),
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      backgroundColor:
          color ?? const Color(0xFF4CAF50), // Hijau yang lebih cerah
      colorText: Colors.white,
      icon: const Icon(
        Icons.check_circle,
        color: Colors.white,
      ),
      isDismissible: isDismissible ?? true,
    );
  }

  //SNACKBAR ERROR
  static showCustomErrorSnackBar(
      {required String title,
      required String message,
      bool? isDismissible,
      Color? color,
      Duration? duration}) {
    Get.closeAllSnackbars(); // Menutup semua snackbar yang aktif
    Get.snackbar(title, message,
        duration: duration ?? const Duration(milliseconds: 1500),
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        colorText: Colors.white,
        backgroundColor: color ??
            const Color.fromARGB(255, 229, 73, 73), // Merah yang lebih lembut
        icon: const Icon(
          Icons.error,
          color: Colors.white,
        ),
        isDismissible: isDismissible ?? true);
  }

  //SNACKBAR TOAST Success
  static showCustomToastSuccess(
      {String? title,
      required String message,
      Color? color,
      bool? isDismissible,
      Duration? duration}) {
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
