import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';

import 'splash_screen_controller.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SplashScreenController>(builder: (value) {
        return Center(
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              Positioned(
                top: MediaQuery.of(context).size.width * 0.7,
                child: Image.asset(
                  width: 160,
                  'assets/images/p-logo.png',
                ).animate().fade().slideY(
                      duration: const Duration(milliseconds: 400),
                      begin: 2,
                      curve: Curves.easeInSine,
                    ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Plantix',
                    style: TStyle.head2,
                  ).animate().fade().slideY(
                      duration: const Duration(milliseconds: 400),
                      begin: 5,
                      curve: Curves.easeInSine),
                  const SizedBox(
                    height: 50.0,
                  ),
                  const LoadingWidget(size: 36),
                ],
              ).paddingOnly(bottom: 170),
            ],
          ),
        );
      }),
    );
  }
}
