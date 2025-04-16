// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';

class CustomAlertDialog {
  static customAlertDialog({
    required BuildContext context,
    required String title,
    required String description,
    String? yes,
    String? no,
    required VoidCallback onPressYes,
    required VoidCallback onPressNo,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(children: <Widget>[Text(description)]),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
              ),
              onPressed: onPressNo,
              child: Text(no ?? "Tidak", style: const TextStyle(fontSize: 12)),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: onPressYes,
              child: Text(yes ?? "Ya", style: const TextStyle(fontSize: 12)),
            ),
          ],
        );
      },
    );
  }
}
