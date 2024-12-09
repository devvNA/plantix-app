import 'package:flutter/material.dart';
import 'package:plantix_app/app/core/extensions/currency_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';
import 'package:plantix_app/app/data/models/product_model.dart';

class ProductSellItems extends StatelessWidget {
  final VoidCallback onTap;
  final ProductsModel product;
  // final Product product;

  const ProductSellItems(
      {super.key, required this.onTap, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Image.network(
                  filterQuality: FilterQuality.low,
                  product.imageUrl[0],
                  width: double.infinity,
                  fit: BoxFit.contain,
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
                  Row(
                    children: [
                      Text(
                        product.price.currencyFormatRp,
                        style: TStyle.bodyText2
                            .copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "/kg",
                        style: TStyle.bodyText3.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        "${product.stock} Tersisa",
                        style: TStyle.bodyText4.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.shopping_cart_checkout,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "65",
                              style: TStyle.bodyText4.copyWith(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              "Terjual",
                              style: TStyle.bodyText4
                                  .copyWith(color: Colors.grey[600]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
