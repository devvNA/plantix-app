// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/currency_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_alert_dialog.dart';
import 'package:plantix_app/app/core/widgets/custom_text_form.dart';
import 'package:plantix_app/app/modules/checkout/checkout_controller.dart';
import 'package:plantix_app/app/modules/checkout/widgets/checkout_dart.dart';
import 'package:plantix_app/app/routes/list_transaction_routes.dart';

class CheckoutPage extends GetView<CheckoutController> {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<CheckoutController>(builder: (_) {
      return SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Text(
                "Checkout",
                style: TStyle.head2,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  controller.checkData();
                },
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 25.0,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        const Text(
                          "Alamat Pengiriman",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    _addressCard(context),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.list_alt,
                          size: 25.0,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        const Text(
                          "Detail Pemesanan",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Column(
                      children:
                          List.generate(controller.cartList.length, (index) {
                        final dataKeranjang = controller.cartList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: CheckoutProduct(
                            quantity: dataKeranjang.quantity ?? 5,
                            totalPayment: controller.totalOrderItem(index),
                            imgUrl: controller.getImgUrl(index),
                            title: dataKeranjang.product!.name ?? "Sayur",
                            description:
                                "Harga satuan:\n${dataKeranjang.product!.price?.currencyFormatRp ?? "0".currencyFormatRp}",
                            category: controller.getCategory(index),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            _bottomMenu(context, controller),
          ],
        ),
      );
    }));
  }

  Container _bottomMenu(BuildContext context, CheckoutController controller) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Color.fromARGB(27, 0, 0, 0),
              offset: Offset(1, -1),
              blurRadius: 10),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          DropdownButton(
              padding: const EdgeInsets.all(8.0),
              style: context.theme.textTheme.bodyMedium
                  ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
              elevation: 2,
              hint: Text(
                "pilih jenis pembayaran",
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                ),
              ),
              isExpanded: true,
              value: controller.paymentMethod,
              onChanged: (value) {
                controller.onSelectedPayment(value!);
              },
              items: controller.paymentDropDownItems),
          SizedBox(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total Pembayaran",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        controller.totalPayment().currencyFormatRp,
                        style:
                            TStyle.head3.copyWith(color: AppColors.secondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      disabledForegroundColor:
                          AppColors.primary.withOpacity(0.38),
                      disabledBackgroundColor:
                          AppColors.primary.withOpacity(0.12),
                    ),
                    onPressed: controller.isButtonActive.value
                        ? () async {
                            CustomAlertDialog.customAlertDialog(
                                yes: controller.isLoading.value
                                    ? "Loading..."
                                    : "Ya",
                                context: context,
                                title: "Konfirmasi",
                                description: "Apakah pesanan sudah sesuai?",
                                onPressYes: () {
                                  controller.purchaseOrder().then((value) {
                                    Get.back();
                                    _successCheckoutDialog(
                                      Get.context!,
                                      controller,
                                    );
                                    Future.delayed(1000.ms, () {
                                      Get.back();
                                      Get.toNamed(HistoryTransactionRoutes
                                          .historyTransaction);
                                    });
                                  });
                                },
                                onPressNo: () {
                                  Get.back();
                                });
                          }
                        : null,
                    child: const Text(
                      "Pesan",
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _addressCard(context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                controller.alamatController.text,
                softWrap: true,
                style: TStyle.bodyText2.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                await showDialog<void>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Alamat Pengiriman"),
                      content: SingleChildScrollView(
                        child: CustomTextForm(
                          maxLines: 5,
                          hintText: "Masukkan alamat pengiriman",
                          controller: controller.alamatController,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            side: BorderSide(
                              color: AppColors.primary,
                            ),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            "Batal",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: AppColors.primary,
                            ),
                          ),
                          onPressed: () {
                            Get.back();
                            controller.update();
                          },
                          child: Text(
                            "Simpan",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.edit_location_alt,
                size: 15.0,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_successCheckoutDialog(
  BuildContext context,
  CheckoutController controller,
) {
  Get.dialog(
    barrierDismissible: true,
    AlertDialog(
      alignment: Alignment.center,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            "assets/images/icon/success-checkout.svg",
            width: 140,
            height: 100,
          ).animate().scale(),
          const SizedBox(
            height: 12.0,
          ),
          Text(
            "Pesanan Berhasil",
            style: TStyle.head3,
          ).animate().fadeIn(),
        ],
      ),
    ),
  );
  // Future.delayed(const Duration(milliseconds: 1500), () {
  //   controller.redirectHistory();
  // });
}
