// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/date_time_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';
import 'package:plantix_app/app/modules/artikel/artikel_all/widgets/artikel_item_widget.dart';
import 'package:plantix_app/app/modules/home/home_controller.dart';
import 'package:plantix_app/app/routes/analisa_usaha_tani_routes.dart';
import 'package:plantix_app/app/routes/artikel_routes.dart';
import 'package:plantix_app/app/routes/calendar_routes.dart';
import 'package:plantix_app/app/routes/kalkulasi_tanam_routes.dart';
import 'package:plantix_app/app/routes/lahan_tanam_routes.dart';
import 'package:plantix_app/app/routes/notification_routes.dart';
import 'package:plantix_app/main.dart';

class BuildHomePage extends GetView<HomeController> {
  const BuildHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Header gradient background
          Container(
            height: MediaQuery.of(context).size.height * 0.28,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary,
                  AppColors.secondary.withOpacity(0.8),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          // Main content
          Column(
            children: [
              // Profile header
              buildUserProfileHeader(context, controller),

              // Scrollable content
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    controller.refreshHome();
                  },
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Banner carousel
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: buildBanner(controller),
                          ),

                          // Menu section
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Ayo Mulai!", style: TStyle.head4),
                                const SizedBox(height: 8.0),
                                buildMenuGrid(context),
                              ],
                            ),
                          ),

                          // Article section
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Artikel Pertanian",
                                      style: TStyle.head4,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(ArtikelRoutes.artikelAll);
                                      },
                                      borderRadius: BorderRadius.circular(16),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          "Lihat Semua",
                                          style: TStyle.bodyText2.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12.0),
                                buildArticleList(),
                              ],
                            ),
                          ),

                          // Bottom padding
                          const SizedBox(height: 24.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildArticleList() {
    return SizedBox(
      height: 245, // Fixed height for better scrolling performance
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: ArticleItem(
              authorImage: "https://i.pravatar.cc/300",
              onTap: () {
                Get.toNamed(ArtikelRoutes.artikel);
              },
              title: 'Hari Tani Nasional',
              author: 'admin01',
              date: DateTime.now().toFormattedDateWithDay(),
              imageUrl:
                  "https://mitrabertani.com/img/img_artikel/WEB_DESAIN_ARTIKEL_DWI.jpg",
            ),
          );
        },
      ),
    );
  }

  Builder buildBanner(HomeController controller) {
    return Builder(
      builder: (context) {
        List images = [
          "https://stockistnasa.com/wp-content/uploads/2015/04/produk-nasa-pertanian.jpg",
          "https://biopsagrotekno.co.id/wp-content/uploads/2021/09/Harga-Produk-Pertanian-Tidak-Stabil-Ini-Alasannya.jpg",
          "https://portal.sukoharjokab.go.id/wp-content/uploads/2021/11/259488491_1078707562878980_8521623073405566500_n.jpg",
          "https://img.freepik.com/free-vector/hand-drawn-agriculture-company-sale-banner_23-2149696779.jpg",
        ];

        return Column(
          children: [
            CarouselSlider(
              carouselController: controller.carouselSliderController,
              options: CarouselOptions(
                height: 170.0,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                onPageChanged: (index, reason) {
                  controller.currentIndex.value = index;
                },
              ),
              items:
                  images.map((imageUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          clipBehavior: Clip.antiAlias,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26.withOpacity(0.15),
                                offset: const Offset(0, 4),
                                blurRadius: 10,
                                spreadRadius: 0.5,
                              ),
                            ],
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Image
                              Image.network(
                                filterQuality: FilterQuality.medium,
                                imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (
                                  BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return const Center(child: LoadingWidget());
                                },
                                errorBuilder: (
                                  BuildContext context,
                                  Object exception,
                                  StackTrace? stackTrace,
                                ) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.error, color: Colors.red),
                                        SizedBox(height: 8.0),
                                        Text(
                                          "Gagal memuat gambar",
                                          style: TextStyle(fontSize: 12.0),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              // Gradient overlay for text readability
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.4),
                                    ],
                                    stops: const [0.7, 1.0],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  images.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap:
                          () => controller.carouselSliderController
                              .animateToPage(entry.key),
                      child: Obx(() {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width:
                              controller.currentIndex.value == entry.key
                                  ? 16.0
                                  : 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(horizontal: 3.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color:
                                controller.currentIndex.value == entry.key
                                    ? AppColors.primary
                                    : Colors.grey.withOpacity(0.3),
                          ),
                        );
                      }),
                    );
                  }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget buildUserProfileHeader(
    BuildContext context,
    HomeController controller,
  ) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).viewPadding.top + 16,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hai, ${user.currentUser?.name.trimLeft().split(' ').first ?? ''} 👋',
                  style: TStyle.head4.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Selamat datang di Plantix',
                  style: TStyle.bodyText2.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildActionButton(
                icon: Icons.notifications_none_rounded,
                count: controller.getNotificationLength(),
                onTap: () => Get.toNamed(NotificationRoutes.notification),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required int count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            if (count > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Center(
                    child: Text(
                      count.toString(),
                      style: TStyle.bodyText5.copyWith(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Widget buildMenuGrid(BuildContext context) {
  final menuItems = [
    {
      'title': 'Lahan Tanam',
      'route': LahanTanamRoutes.lahanTanam,
      'icon': Icons.grass_outlined,
      'color': AppColors.primary,
    },
    {
      'title': 'Kalkulasi Tanam',
      'route': KalkulasiTanamRoutes.kalkulasiTanam,
      'icon': Icons.calculate_outlined,
      'color': AppColors.secondary,
    },
    {
      'title': 'Analisa Usahatani',
      'route': AnalisaUsahaTaniRoutes.analisaUsahaTani,
      'icon': Icons.analytics_outlined,
      'color': Colors.orange,
    },
    {
      'title': 'Kalender',
      'route': CalendarRoutes.calendar,
      'icon': Icons.calendar_month_outlined,
      'color': Colors.blueAccent,
    },
  ];

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return InkWell(
          onTap: () => Get.toNamed(item['route'] as String),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: (item['color'] as Color).withOpacity(0.1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (item['color'] as Color).withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: item['color'] as Color,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item['title'] as String,
                  style: TStyle.bodyText2.copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
