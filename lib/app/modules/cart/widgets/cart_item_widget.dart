// Widget untuk Card Toko
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/int_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/data/models/keranjang_model.dart';
import 'package:plantix_app/app/modules/cart/cart_controller.dart';

class StoreCartCard extends StatelessWidget {
  final String storeName;
  final List<CartItem> storeItems;
  final CartController controller;

  const StoreCartCard({
    Key? key,
    required this.storeName,
    required this.storeItems,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStoreHeader(),
          _buildProductList(),
          const SizedBox(height: 8),
          // _buildStoreTotal(),
        ],
      ),
    );
  }

  Widget _buildStoreHeader() {
    return Row(
      children: [
        Obx(() => Checkbox(
              activeColor: AppColors.primary,
              value: controller.isStoreSelected(storeName),
              onChanged: (value) => controller.toggleStoreSelection(storeName),
            )),
        const Icon(Icons.store, size: 20),
        const SizedBox(width: 8),
        Text(storeName, style: TStyle.head5),
      ],
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: storeItems.length,
      itemBuilder: (context, idx) {
        final item = storeItems[idx];
        return ProductCartItem(
          item: item,
          controller: controller,
        );
      },
    );
  }

  Widget _buildStoreTotal() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total Belanja:', style: TStyle.bodyText2),
          Text(
            controller.calculateStoreTotal(storeItems).currencyFormatRp,
            style: TStyle.head5.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

// Widget untuk Item Produk
class ProductCartItem extends StatelessWidget {
  final CartItem item;
  final CartController controller;

  const ProductCartItem({
    Key? key,
    required this.item,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              _buildCheckbox(),
              _buildProductImage(),
              const SizedBox(width: 12),
              Expanded(
                child: _buildProductDetails(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return Obx(() => Checkbox(
          activeColor: AppColors.primary,
          value: controller.isItemSelected(item.product![0].id),
          onChanged: (value) =>
              controller.toggleItemSelection(item.product![0].id),
        ));
  }

  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        item.product![0].images[0],
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 80,
          height: 80,
          color: Colors.grey[200],
          child: const Icon(Icons.image),
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.product![0].name,
          style: TStyle.bodyText2.copyWith(
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          item.product![0].price.currencyFormatRp,
          style: TStyle.bodyText2.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            IconButton(
              splashRadius: 16,
              onPressed: () =>
                  controller.decrementQuantity(item.product![0].id),
              icon: const Icon(Icons.remove_circle_outline),
              iconSize: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '${item.quantity}',
                style: TStyle.bodyText2,
              ),
            ),
            IconButton(
              splashRadius: 16,
              onPressed: () =>
                  controller.incrementQuantity(item.product![0].id),
              icon: const Icon(Icons.add_circle_outline),
              iconSize: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            Spacer(),
            IconButton(
              splashRadius: 16,
              onPressed: () => controller.deleteProduct(item),
              icon: const Icon(
                Icons.delete_forever,
                color: AppColors.error,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ],
    );
  }
}
