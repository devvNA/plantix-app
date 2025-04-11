import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/modules/shop/shop_controller.dart';
import 'package:plantix_app/app/modules/shop/widgets/search_products.dart';
import 'package:plantix_app/app/routes/cart_routes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShopController>();
    // final cartController = Get.find<CartController>();

    return AppBar(
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      title: Text(title, style: TStyle.head3.copyWith(color: Colors.white)),
      actions: [
        IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: ProductSearchDelegate(controller.listProductsSearch),
            );
          },
          icon: Icon(Icons.search, size: 24.0, color: Colors.white),
        ),
        IconButton(
          onPressed: () {
            Get.toNamed(CartRoutes.cart);
          },
          icon: Badge(
            label: Text("50", style: TextStyle(color: Colors.white)),
            // label: Obx(() {
            //   return Text("50", style: TextStyle(color: Colors.white));
            // }),
            child: Icon(Icons.shopping_cart, color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
