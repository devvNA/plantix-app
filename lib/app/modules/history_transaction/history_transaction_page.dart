import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';
import 'package:plantix_app/app/core/widgets/error_state.dart';
import 'package:plantix_app/app/modules/history_transaction/widgets/history_item.dart';
import 'package:plantix_app/app/routes/detail_history_routes.dart';

import 'history_transaction_controller.dart';

class HistoryTransactionPage extends GetView<HistoryTransactionController> {
  const HistoryTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histori Transaksi'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: DefaultTabController(
              length: controller.tabs.length,
              initialIndex: controller.selectedIndex.value,
              child: Column(
                children: [
                  TabBar(
                    onTap: (value) {
                      controller.selectedIndex.value = value;
                      log("tab : ${value + 1}");
                    },
                    labelStyle: context.theme.textTheme.displayLarge?.copyWith(
                      fontSize: 14,
                    ),
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2.5,
                      ),
                    ),
                    labelColor: AppColors.primary,
                    labelPadding: const EdgeInsets.all(16),
                    unselectedLabelColor: const Color(0xFFA3A3A3),
                    tabs: controller.tabs,
                  ),
                  const SizedBox(height: 5.0),
                  Expanded(
                    child: TabBarView(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        // TAB 1
                        Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(child: LoadingWidget());
                          }
                          if (controller.listHistoriPending.isEmpty) {
                            return Center(
                              child: RefreshIndicator(
                                color: AppColors.primary,
                                onRefresh: () async {
                                  return controller.refreshHistoryData();
                                },
                                child: ListView(
                                  children: const [
                                    SizedBox(height: 150),
                                    ErrorStateWidget(
                                      message:
                                          "Belum ada histori transaksi yang diproses",
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return RefreshIndicator(
                            color: AppColors.primary,
                            onRefresh: () async {
                              return controller.refreshHistoryData();
                            },
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  height: 3,
                                  color: Colors.black45,
                                ).animate().fade().slideY(
                                  duration: const Duration(milliseconds: 300),
                                  begin: 2,
                                  curve: Curves.easeInSine,
                                );
                              },
                              itemCount: controller.listHistoriPending.length,
                              itemBuilder: (context, index) {
                                final historiPemesanan =
                                    controller.listHistoriPending[index];
                                return HistoryItem(
                                  historiData: historiPemesanan,
                                  onTap: () {
                                    Get.toNamed(
                                      DetailHistoryRoutes.detailHistory,
                                      arguments: historiPemesanan,
                                    );
                                  },
                                ).animate().fade().slideY(
                                  duration: const Duration(milliseconds: 300),
                                  begin: 1,
                                  curve: Curves.easeInSine,
                                );
                              },
                            ),
                          );
                        }),

                        // TAB 2
                        Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(child: LoadingWidget());
                          }
                          if (controller.listHistoriSuccess.isEmpty) {
                            return Center(
                              child: RefreshIndicator(
                                color: AppColors.primary,
                                onRefresh: () async {
                                  return controller.refreshHistoryData();
                                },
                                child: ListView(
                                  children: const [
                                    SizedBox(height: 150),
                                    ErrorStateWidget(
                                      message:
                                          "Belum ada histori transaksi yang selesai",
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return RefreshIndicator(
                            color: AppColors.primary,
                            onRefresh: () async {
                              return controller.refreshHistoryData();
                            },
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  height: 3,
                                  color: Colors.black45,
                                ).animate().fade().slideY(
                                  duration: const Duration(milliseconds: 300),
                                  begin: 2,
                                  curve: Curves.easeInSine,
                                );
                              },
                              itemCount: controller.listHistoriSuccess.length,
                              itemBuilder: (context, index) {
                                final historiPemesanan =
                                    controller.listHistoriSuccess[index];
                                return HistoryItem(
                                  historiData: historiPemesanan,
                                  onTap: () {
                                    Get.toNamed(
                                      DetailHistoryRoutes.detailHistory,
                                      arguments: historiPemesanan,
                                    );
                                  },
                                ).animate().fade().slideY(
                                  duration: const Duration(milliseconds: 300),
                                  begin: 1,
                                  curve: Curves.easeInSine,
                                );
                              },
                            ),
                          );
                        }),

                        // TAB 3
                        Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(child: LoadingWidget());
                          }
                          if (controller.listHistoriCancel.isEmpty) {
                            return Center(
                              child: RefreshIndicator(
                                color: AppColors.primary,
                                onRefresh: () async {
                                  return controller.refreshHistoryData();
                                },
                                child: ListView(
                                  children: const [
                                    SizedBox(height: 150),
                                    ErrorStateWidget(
                                      message:
                                          "Belum ada histori transaksi yang dibatalkan",
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return RefreshIndicator(
                            color: AppColors.primary,
                            onRefresh: () async {
                              return controller.refreshHistoryData();
                            },
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  height: 3,
                                  color: Colors.black45,
                                ).animate().fade().slideY(
                                  duration: const Duration(milliseconds: 300),
                                  begin: 2,
                                  curve: Curves.easeInSine,
                                );
                              },
                              itemCount: controller.listHistoriCancel.length,
                              itemBuilder: (context, index) {
                                final historiPemesanan =
                                    controller.listHistoriCancel[index];
                                return HistoryItem(
                                  historiData: historiPemesanan,
                                  onTap: () {
                                    Get.toNamed(
                                      DetailHistoryRoutes.detailHistory,
                                      arguments: historiPemesanan,
                                    );
                                  },
                                ).animate().fade().slideY(
                                  duration: const Duration(milliseconds: 300),
                                  begin: 1,
                                  curve: Curves.easeInSine,
                                );
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
