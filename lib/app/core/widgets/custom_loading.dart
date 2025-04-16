import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';

class LoadingWidget extends StatelessWidget {
  final double? size;
  final Color leftDotColor;
  final Color rightDotColor;

  const LoadingWidget({
    super.key,
    this.size = 25.0,
    this.leftDotColor = AppColors.primary,
    this.rightDotColor = const Color(0xFF1A1A3F),
  });

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.twistingDots(
      leftDotColor: leftDotColor,
      rightDotColor: rightDotColor,
      size: size!,
    );
  }
}

class LoadingWidgetBG extends StatelessWidget {
  const LoadingWidgetBG({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.black12,
        alignment: Alignment.center,
        child: LoadingWidget(size: 28),
      ),
    );
  }
}
