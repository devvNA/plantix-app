import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';

class CustomToast {
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

class QAlert extends StatelessWidget {
  const QAlert({
    super.key,
    this.color,
    required this.message,
    this.body,
    this.duration = 4,
  });
  final Color? color;
  final String message;
  final String? body;
  final int duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 10.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(4.0),
        ),
        border: Border(
          top: BorderSide(
            width: 1.0,
            color: color ?? AppColors.success,
          ),
          right: BorderSide(
            width: 1.0,
            color: color ?? AppColors.success,
          ),
          bottom: BorderSide(
            width: 1.0,
            color: color ?? AppColors.success,
          ),
          left: BorderSide(
            width: 8.0,
            color: color ?? AppColors.success,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            overflow: TextOverflow.ellipsis,
            // maxLines: 2,
            style: TStyle.bodyText1.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (body != null) ...[
            const SizedBox(
              height: 4.0,
            ),
            Text(
              body!,
              overflow: TextOverflow.ellipsis,
              // maxLines: 2,
              style: TStyle.bodyText1,
            )
          ],
        ],
      ),
    );
  }
}

showCustomSnackbar({
  required String message,
  String? body,
  int duration = 3000,
  Color? color,
  double bottom = 160,
}) {
  var notchHeight = MediaQuery.of(Get.context!).padding.top;
  var maxWidth = MediaQuery.sizeOf(Get.context!).width;
  var yourMaxWidth = 400;
  double marginHorizontal = 20;

  if (maxWidth > 760) {
    marginHorizontal = (maxWidth - yourMaxWidth) / 2;
  }

  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    duration: Duration(milliseconds: duration),
    padding: EdgeInsets.zero,
    backgroundColor: Colors.transparent,
    elevation: 2,
    dismissDirection: DismissDirection.up,
    margin: EdgeInsets.only(
      bottom: MediaQuery.of(Get.context!).size.height - (notchHeight + bottom),
      // bottom: 20,
      left: marginHorizontal,
      right: marginHorizontal,
    ),
    content: QAlert(
      color: color,
      message: message,
      body: body,
      duration: duration,
    ),
  );
  ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
  ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
}

snackbarSuccess({
  required String message,
  String? body,
  int duration = 3000,
  double bottom = 160,
}) {
  showCustomSnackbar(
    message: message,
    body: body,
    duration: duration,
    color: AppColors.success,
    bottom: bottom,
  );
}

snackbarError({
  required String message,
  String? body,
  int duration = 3000,
  double bottom = 160,
}) {
  showCustomSnackbar(
    message: message,
    body: body,
    duration: duration,
    color: AppColors.error,
    bottom: bottom,
  );
}

snackbarInfo({
  required String message,
  String? body,
  int duration = 3000,
  double bottom = 160,
}) {
  showCustomSnackbar(
    message: message,
    body: body,
    duration: duration,
    color: Color(0xFF179DB4),
    bottom: bottom,
  );
}

snackbarWarning({
  required String message,
  String? body,
  int duration = 3000,
  double bottom = 160,
}) {
  showCustomSnackbar(
    message: message,
    body: body,
    duration: duration,
    color: AppColors.warning,
    bottom: bottom,
  );
}
