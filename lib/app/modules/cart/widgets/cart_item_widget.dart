// Widget untuk Card Toko
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/currency_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/data/models/cart_model.dart';
import 'package:plantix_app/app/modules/cart/cart_controller.dart';

class StoreCartCard extends StatelessWidget {
  final String storeName;
  final List<CartModel> storeItems;

  const StoreCartCard({
    super.key,
    required this.storeName,
    required this.storeItems,
  });

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
          _buildStoreTotal(),
        ],
      ),
    );
  }

  Widget _buildStoreHeader() {
    final controller = Get.find<CartController>();

    return Row(
      children: [
        Obx(
          () => Checkbox(
            activeColor: AppColors.primary,
            value: controller.isStoreSelected(storeName),
            onChanged: (value) => controller.toggleStoreSelection(storeName),
          ),
        ),
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
        return ProductCartItem(item: item);
      },
    );
  }

  Widget _buildStoreTotal() {
    // Hitung total belanja untuk toko ini
    double storeTotal = storeItems.fold(0.0, (sum, item) {
      return sum + (item.price * (item.quantity ?? 1));
    });

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total Belanja:', style: TStyle.bodyText2),
          Text(
            storeTotal.toDouble().currencyFormatRp,
            style: TStyle.head5.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

// Widget untuk Item Produk
class ProductCartItem extends StatelessWidget {
  final CartModel item;
  final controller = Get.find<CartController>();

  ProductCartItem({super.key, required this.item});

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
              Expanded(child: _buildProductDetails()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return Obx(
      () => Checkbox(
        activeColor: AppColors.primary,
        value: controller.isItemSelected(item.productId),
        onChanged: (value) => controller.toggleItemSelection(item.productId),
      ),
    );
  }

  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        item.imageUrl.isNotEmpty ? item.imageUrl[0] : '',
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) => Container(
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
          item.productName,
          style: TStyle.bodyText2.copyWith(fontWeight: FontWeight.w500),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          item.price.currencyFormatRp,
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
              onPressed: () {
                controller.decrementQuantity(item.productId);
              },
              icon: const Icon(Icons.remove_circle_outline),
              iconSize: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('${item.quantity}', style: TStyle.bodyText2),
            ),
            IconButton(
              splashRadius: 16,
              onPressed: () {
                controller.incrementQuantity(item.productId);
              },
              icon: const Icon(Icons.add_circle_outline),
              iconSize: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const Spacer(),
            IconButton(
              splashRadius: 16,
              onPressed: () {
                controller.deleteProduct(item);
              },
              icon: const Icon(Icons.delete_forever, color: AppColors.error),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ],
    );
  }
}
