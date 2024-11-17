import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/modules/my_products/widgets/products_sell_items.dart';

import 'my_products_controller.dart';

class MyProductsPage extends GetView<MyProductsController> {
  const MyProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        onPressed: () {
          // controller.createProduct(
          //   name: 'Kentang',
          //   description: 'Deskripsi Produk A',
          //   stock: 10,
          //   category: 'Buah',
          //   price: 100000.0,
          //   images: [
          //     "https://sesa.id/cdn/shop/files/ORGANIK-KENTANG-500GR-_1-removebg-preview_1ec2df6a-21c8-4f07-849f-945e37046afd.png?v=1684127848",
          //     "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
          //     "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg",
          //   ],
          // );

          showModalBottomSheet(
            useSafeArea: true,
            isScrollControlled: true,
            clipBehavior: Clip.hardEdge,
            elevation: 3,
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.0),
              ),
            ),
            builder: (BuildContext context) {
              return DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.5,
                minChildSize: 0.3,
                maxChildSize: 1.0,
                builder: (context, scrollController) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(12.0),
                            height: 5.0,
                            width: 60.0,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.all(
                                Radius.circular(32.0),
                              ),
                            ),
                          ),
                          Container(
                            height: 300.0,
                            color: Colors.brown,
                          ),
                          Container(
                            height: 300.0,
                            color: Colors.yellow,
                          ),
                          Container(
                            height: 300.0,
                            color: Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('MyProductsPage'),
        centerTitle: true,
      ),
      body: Obx(() {
        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            mainAxisSpacing: 6,
            crossAxisSpacing: 8,
          ),
          itemCount: controller.listMyProducts.length,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return ProductSellItems(
              onTap: () {},
              product: controller.listMyProducts[index],
            );
          },
        );
      }),
    );
  }
}
