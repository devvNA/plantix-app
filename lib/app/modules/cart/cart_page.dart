import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/int_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/modules/cart/widgets/cart_item_widget.dart';
import 'package:plantix_app/app/routes/checkout_routes.dart';

import 'cart_controller.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Keranjang Belanja'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                controller.checkData();
              },
              icon: const Icon(
                Icons.list_alt_rounded,
                size: 24.0,
              ),
            ),
          ],
        ),
        body: Obx(() => controller.cartProductList.isNotEmpty
            ? _buildCartList()
            : _buildEmptyCart()),
        bottomNavigationBar: Obx(
          () => controller.cartProductList.isNotEmpty
              ? _buildCheckoutSection()
              : const SizedBox(),
        ));
  }

  Widget _buildEmptyCart() {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/icon/empty-cart.svg",
                  width: 200,
                ),
                Text(
                  'Keranjang Belanja Kosong',
                  style: TStyle.bodyText1,
                ),
              ],
            ),
          ),
          Text(
            'Yuk mulai belanja sekarang!',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: Text(
              'Mulai Belanja',
              style: TStyle.head5.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList() {
    return Obx(() {
      final groupedItems = controller.getGroupedCartItems();
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: groupedItems.length,
        itemBuilder: (context, index) {
          final storeName = groupedItems.keys.elementAt(index);
          final storeItems = groupedItems[storeName]!;
          return StoreCartCard(
            storeName: storeName,
            storeItems: storeItems,
            controller: controller,
          );
        },
      );
    });
  }

  Widget _buildCheckoutSection() {
    return Obx(() => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Pembayaran',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        '${controller.selectedProductCount} item dipilih',
                        style: TStyle.bodyText2.copyWith(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    controller.calculateSelectedItemsTotal().currencyFormatRp,
                    style: TStyle.head3.copyWith(color: AppColors.primary),
                  )
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.selectedProductCount > 0
                      ? () {
                          final selectedItems =
                              controller.checkoutSelectedItems();
                          Get.toNamed(CheckoutRoutes.checkout,
                              arguments: selectedItems);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Lanjut ke Pembayaran',
                    style: TStyle.head5.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
