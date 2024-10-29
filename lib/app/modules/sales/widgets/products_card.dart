import 'package:flutter/material.dart';
import 'package:plantix_app/app/core/extensions/int_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';
import 'package:plantix_app/app/data/models/product_model.dart';

class ProductMarketCards extends StatelessWidget {
  final VoidCallback onTap;
  final Product product;

  const ProductMarketCards(
      {super.key, required this.onTap, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Image.network(
                  filterQuality: FilterQuality.low,
                  product.images[0],
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: LoadingWidget(size: 20),
                      // CircularProgressIndicator(
                      //   color: AppColors.primary,
                      //   value: loadingProgress.expectedTotalBytes != null
                      //       ? loadingProgress.cumulativeBytesLoaded /
                      //           loadingProgress.expectedTotalBytes!
                      //       : null,
                      // ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const SizedBox(height: 4),
                          const Text(
                            "Gagal memuat gambar",
                            style: TStyle.bodyText5,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TStyle.bodyText2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    product.price.currencyFormatRp,
                    style:
                        TStyle.bodyText2.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        "${product.stock} Tersisa",
                        style: TStyle.bodyText5.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.shopping_bag,
                              size: 12.0,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                product.storeName,
                                style: TStyle.bodyText5.copyWith(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// // Widget Card Produk
// class ProductCard extends GetView<SalesController> {
//   final Product product;

//   const ProductCard({Key? key, required this.product}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(8),
//       child: ListTile(
//         leading: product.images.isNotEmpty
//             ? ClipRRect(
//                 borderRadius: BorderRadius.circular(4),
//                 child: Image.network(
//                   product.images[0],
//                   width: 50,
//                   height: 50,
//                   fit: BoxFit.cover,
//                 ),
//               )
//             : const Icon(Icons.image),
//         title: Text(product.name),
//         subtitle: Text(
//           'Stok: ${product.stock} - Rp ${product.price.toStringAsFixed(0)}',
//         ),
//         trailing: PopupMenuButton(
//           itemBuilder: (context) => [
//             const PopupMenuItem(
//               value: 'edit',
//               child: Text('Edit'),
//             ),
//             const PopupMenuItem(
//               value: 'delete',
//               child: Text('Hapus'),
//             ),
//           ],
//           onSelected: (value) {
//             if (value == 'edit') {
//               // Get.to(() => AddProductPage(product: product));
//             } else if (value == 'delete') {
//               Get.dialog(
//                 AlertDialog(
//                   title: const Text('Konfirmasi'),
//                   content: const Text('Yakin ingin menghapus produk ini?'),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Get.back(),
//                       child: const Text('Batal'),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Get.back();
//                         controller.deleteProduct(product.id);
//                       },
//                       child: const Text('Hapus'),
//                     ),
//                   ],
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
