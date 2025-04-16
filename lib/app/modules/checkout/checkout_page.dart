// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/currency_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_alert_dialog.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';
import 'package:plantix_app/app/core/widgets/custom_text_form.dart';
import 'package:plantix_app/app/data/models/cart_model.dart';
import 'package:plantix_app/app/modules/checkout/checkout_controller.dart';
import 'package:plantix_app/app/modules/checkout/widgets/checkout_dart.dart';
import 'package:plantix_app/app/modules/checkout/widgets/success_dialog.dart';

class CheckoutPage extends GetView<CheckoutController> {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("Checkout", style: TStyle.head4),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: GetBuilder<CheckoutController>(
        builder: (_) {
          if (controller.isLoading.value) {
            return const Center(child: LoadingWidgetBG());
          }
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      _buildDeliverySection(context),
                      const SizedBox(height: 16.0),
                      _buildOrderSectionByStore(context),
                      const SizedBox(height: 16.0),
                      _buildPaymentSection(context),
                      const SizedBox(height: 16.0),
                      _buildSummarySection(context),
                    ],
                  ),
                ),
                _buildBottomBar(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeliverySection(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "Alamat Pengiriman",
                  style: TStyle.bodyText1.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => _showAddressDialog(context),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.edit_location_alt_outlined,
                          color: AppColors.primary,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Ubah",
                          style: TStyle.bodyText3.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.home_outlined, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    controller.alamatController.text,
                    style: TStyle.bodyText2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).moveY(begin: 10, end: 0);
  }

  Widget _buildOrderSectionByStore(BuildContext context) {
    // Mengelompokkan produk berdasarkan toko
    final Map<String, List<CartModel>> groupedByStore = {};

    for (var cartItem in controller.cartList) {
      if (!groupedByStore.containsKey(cartItem.storeName)) {
        groupedByStore[cartItem.storeName] = [];
      }
      groupedByStore[cartItem.storeName]!.add(cartItem);
    }

    return Column(
      children:
          groupedByStore.entries.map((entry) {
            final storeName = entry.key;
            final storeItems = entry.value;

            return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header toko dengan jumlah item
                        Row(
                          children: [
                            const Icon(
                              Icons.store,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                storeName,
                                style: TStyle.bodyText1.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.secondary.withOpacity(0.1),
                              ),
                              child: Text(
                                "${storeItems.length} item",
                                style: TStyle.bodyText3.copyWith(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),

                        // Daftar produk dari toko ini
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: storeItems.length,
                          itemBuilder: (context, index) {
                            final cartItem = storeItems[index];
                            final itemIndex = controller.cartList.indexOf(
                              cartItem,
                            );

                            return CheckoutProduct(
                              quantity: cartItem.quantity,
                              totalPayment: controller.totalOrderItem(
                                itemIndex,
                              ),
                              imgUrl: controller.getImgUrl(itemIndex),
                              title: cartItem.productName,
                              description:
                                  "Harga satuan:\n${cartItem.price.currencyFormatRp}",
                              category: controller.getCategory(itemIndex),
                              addedAt: cartItem.addedAt,
                            ).animate().fadeIn(
                              duration: 300.ms,
                              delay: Duration(milliseconds: 100 * index),
                            );
                          },
                        ),

                        // Total pembelian per toko
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Subtotal",
                                style: TStyle.bodyText2.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                _calculateStoreSubtotal(
                                  storeItems,
                                ).currencyFormatRp,
                                style: TStyle.bodyText1.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .animate()
                .fadeIn(duration: 300.ms, delay: 150.ms)
                .moveY(begin: 10, end: 0);
          }).toList(),
    );
  }

  int _calculateStoreSubtotal(List<CartModel> storeItems) {
    int total = 0;
    for (var item in storeItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  Widget _buildPaymentSection(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.payment, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Metode Pembayaran",
                  style: TStyle.bodyText1.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(
                    "Pilih metode pembayaran",
                    style: TStyle.bodyText2.copyWith(color: Colors.grey),
                  ),
                  value: controller.paymentMethod,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.primary,
                  ),
                  elevation: 2,
                  style: TStyle.bodyText2,
                  onChanged: (value) {
                    controller.onSelectedPayment(value!);
                  },
                  items: [
                    _buildPaymentItem(
                      value: "COD",
                      label: "Bayar saat barang sampai",
                      icon: Icons.money,
                    ),
                    _buildPaymentItem(
                      value: "Transfer Bank",
                      label: "Bayar melalui transfer bank",
                      icon: Icons.account_balance,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms, delay: 200.ms).moveY(begin: 5, end: 0);
  }

  DropdownMenuItem<String> _buildPaymentItem({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return DropdownMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, style: TStyle.bodyText2),
              Text(label, style: TStyle.bodyText3.copyWith(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.receipt_long,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Ringkasan Pembayaran",
                      style: TStyle.bodyText1.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Subtotal produk", style: TStyle.bodyText2),
                    Text(
                      controller.totalPayment().currencyFormatRp,
                      style: TStyle.bodyText2.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Biaya pengiriman", style: TStyle.bodyText2),
                    Text(
                      "Gratis",
                      style: TStyle.bodyText2.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: TStyle.bodyText1.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      controller.totalPayment().currencyFormatRp,
                      style: TStyle.head4.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms, delay: 450.ms)
        .moveY(begin: 10, end: 0);
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -1),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed:
              controller.isButtonActive.value
                  ? () => _showConfirmationDialog()
                  : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledBackgroundColor: Colors.grey.shade300,
            disabledForegroundColor: Colors.grey.shade600,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_cart_checkout),
              const SizedBox(width: 8),
              Text(
                controller.paymentMethod == null
                    ? "Pilih metode pembayaran"
                    : "Selesaikan Pesanan",
                style: TStyle.bodyText1.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddressDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Alamat Pengiriman", style: TStyle.head4),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                    splashRadius: 20,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextForm(
                maxLines: 3,
                hintText: "Masukkan alamat pengiriman",
                controller: controller.alamatController,
                prefixIcon: const Icon(Icons.location_on_outlined),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    controller.update();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Simpan Alamat",
                    style: TStyle.bodyText1.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showConfirmationDialog() {
    CustomAlertDialog.customAlertDialog(
      yes: controller.isLoading.value ? "Loading..." : "Ya, Lanjutkan",
      context: Get.context!,
      title: "Konfirmasi Pesanan",
      description: "Apakah Anda yakin ingin menyelesaikan pesanan ini?",
      onPressYes: () {
        Get.back();
        controller.createOrder().then((value) {
          Future.delayed(const Duration(seconds: 2), () {
            Get.back();
            Get.back();
            showSuccessDialog();
          });
        });
      },
      onPressNo: () {
        Get.back();
      },
    );
  }
}
