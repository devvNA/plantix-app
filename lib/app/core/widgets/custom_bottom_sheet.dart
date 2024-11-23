import 'package:flutter/material.dart';

void showCustomBottomSheet(BuildContext context, {Widget? content}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allows the bottom sheet to take full height
    backgroundColor: Colors.transparent, // To see the rounded corners effect
    builder: (context) => CustomBottomSheet(content: content),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  );
}

class CustomBottomSheet extends StatelessWidget {
  Widget? content;

  CustomBottomSheet({super.key, this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          content ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
