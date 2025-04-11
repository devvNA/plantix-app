// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/currency_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';
import 'package:plantix_app/app/modules/detail_product/widgets/bottom_sheet_cart.dart';

import 'detail_product_controller.dart';

class DetailProductPage extends GetView<DetailProductController> {
  const DetailProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  Widget _buildBody(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Product Image Hero Section
        _buildProductImageSection(context),

        // Product Information
        SliverToBoxAdapter(child: _buildProductInformation(context)),
      ],
    );
  }

  SliverAppBar _buildProductImageSection(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.sizeOf(context).height * 0.45,
      backgroundColor: Colors.white,
      elevation: 0,
      pinned: true,
      stretch: true,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: _buildProductImageCarousel(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: _buildCircularButton(child: BackButton(color: Colors.black)),
      actions: [
        Obx(() {
          return _buildCircularButton(
            child: IconButton(
              icon: Icon(
                controller.isFavorite.value
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: controller.isFavorite.value ? Colors.red : Colors.black,
              ),
              onPressed: () => controller.toggleFavorite(),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCircularButton({required Widget child}) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildProductImageCarousel() {
    return PageView.builder(
      itemCount: controller.product.imageUrl.length,
      itemBuilder: (context, index) {
        return Hero(
          tag: 'product-${controller.product.id}-$index',
          child: GestureDetector(
            onTap: () => _showFullScreenImage(context, index),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildProductImage(controller.product.imageUrl[index]),
                _buildGradientOverlay(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductImage(String imageUrl) {
    return Image.network(
      imageUrl,
      filterQuality: FilterQuality.medium,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(child: LoadingWidget(size: 22));
      },
      errorBuilder: (context, exception, stackTrace) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 32),
              const SizedBox(height: 8),
              const Text("Gagal memuat gambar", style: TStyle.bodyText3),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.5), Colors.transparent],
          ),
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, int index) {
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 3.0,
              child: Center(
                child: Image.network(
                  controller.product.imageUrl[index],
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInformation(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductHeader(),
          _buildDivider(),
          _buildStoreInfo(),
          _buildProductDetails(),
          _buildDescriptionSection(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildProductHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          Text(
            controller.product.name,
            style: TStyle.head3.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [_buildPriceTag(), const Spacer(), _buildRatingDisplay()],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        (controller.product.price).currencyFormatRp,
        style: TStyle.head4.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRatingDisplay() {
    return Row(
      children: [
        ...List.generate(5, (index) {
          return Icon(
            Icons.star,
            color: index < 4 ? Colors.amber : Colors.grey.shade300,
            size: 18,
          );
        }),
        const SizedBox(width: 6),
        Text(
          '(${controller.product.id} Ulasan)',
          style: TStyle.bodyText3.copyWith(color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 8, color: Colors.grey[100]);
  }

  Widget _buildStoreInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Informasi Toko', style: TStyle.head5),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStoreLogo(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.product.storeName,
                      style: TStyle.bodyText2.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.product.address,
                      style: TStyle.bodyText3.copyWith(
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoreLogo() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
        image: const DecorationImage(
          image: NetworkImage(
            "https://res.cloudinary.com/dotz74j1p/raw/upload/v1716044962/tje4vyigverxlotuhvpb.png",
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade100),
          bottom: BorderSide(color: Colors.grey.shade100),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Detail Produk', style: TStyle.head5),
          const SizedBox(height: 12),
          _buildDetailItem('Stok', controller.product.stock.toString()),
          const SizedBox(height: 8),
          _buildDetailItem('Kategori', controller.product.category),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TStyle.bodyText3.copyWith(color: Colors.grey.shade700),
        ),
        const SizedBox(width: 8),
        Text(': ', style: TStyle.bodyText3),
        Expanded(
          child: Text(
            value,
            style: TStyle.bodyText3.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDivider(),
          const SizedBox(height: 12),
          const Text('Deskripsi Produk', style: TStyle.head5),
          const SizedBox(height: 12),
          Text(
            controller.product.description,
            style: TStyle.bodyText2.copyWith(
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: _showAddToCartBottomSheet,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_cart),
              const SizedBox(width: 8),
              Text(
                'Tambah ke Keranjang',
                style: TStyle.head5.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddToCartBottomSheet() {
    if (Get.isBottomSheetOpen == null || !Get.isBottomSheetOpen!) {
      controller.quantity.value = 1;
    }

    Get.bottomSheet(
      Obx(
        () => BottomSheetCart(
          quantity: controller.quantity.value,
          onPressed: () => controller.addToCart(),
          onIncrease: () => controller.quantity.value++,
          onDecrease:
              () =>
                  controller.quantity.value > 1
                      ? controller.quantity.value--
                      : null,
        ),
      ),
      elevation: 0,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
    );
  }
}
