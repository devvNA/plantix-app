import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/helpers/validator.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/routes/auth_routes.dart';

import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            "assets/images/splash_screen.jpg",
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.9,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Obx(() {
              return Column(
                children: [
                  const Spacer(),
                  // Widget bawah dengan radius circular
                  Container(
                    // height: MediaQuery.sizeOf(context).height * 0.45,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(18),
                      child: Form(
                        key: controller.formField,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Selamat datang di Plantix,",
                              style: TStyle.head3,
                            ).paddingOnly(top: 14),
                            const SizedBox(height: 4),
                            const Text(
                              "Silakan masuk atau daftar di bawah ini.",
                              style: TStyle.bodyText1,
                            ),
                            const SizedBox(height: 16),
                            _emailForm(context),
                            const SizedBox(height: 16),
                            _passwordForm(context),
                            const SizedBox(height: 16),
                            _loginButton(),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  "Belum punya akun ? ",
                                  style: TStyle.bodyText2,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(AuthRoutes.registration);
                                  },
                                  child: const Text(
                                    "Daftar",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().moveY(
                        begin: 100,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  TextFormField _emailForm(context) {
    return TextFormField(
      controller: controller.emailController,
      scrollPadding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height),
      cursorColor: AppColors.primary,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        prefixIconColor: AppColors.primary,
        suffixIconColor: Colors.grey[400],
        fillColor: Colors.grey[200],
        filled: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        hintText: "Email",
        prefixIcon: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
          child: Icon(
            Icons.email_rounded,
          ),
        ),
      ),
      validator: Validator.email,
    );
  }

  TextFormField _passwordForm(context) {
    return TextFormField(
      obscureText: controller.notVisible.value,
      controller: controller.passwordController,
      scrollPadding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height),
      cursorColor: AppColors.primary,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        prefixIconColor: AppColors.primary,
        suffixIconColor: Colors.grey[400],
        fillColor: Colors.grey[200],
        filled: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        hintText: "Password",
        prefixIcon: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
          child: Icon(
            Icons.lock,
          ),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            controller.notVisible.toggle();
            log(controller.notVisible.toString());
          },
          icon: Icon(
            controller.notVisible.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 20.0,
          ),
        ),
      ),
      validator: Validator.password,
    );
  }

  ElevatedButton _loginButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        maximumSize: const Size(double.infinity, 42),
        minimumSize: const Size(double.infinity, 42),
      ),
      onPressed: controller.isLoading.value
          ? null
          : () {
              if (controller.formField.currentState!.validate()) {
                controller.doLogin();
              }
            },
      child: controller.isLoading.value
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                backgroundColor: Colors.white,
                color: AppColors.primary,
              ),
            )
          : Text(
              "Masuk".toUpperCase(),
              style: TStyle.head4.copyWith(
                color: Colors.white,
              ),
            ),
    );
  }
}
