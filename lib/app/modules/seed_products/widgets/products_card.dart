import 'package:flutter/material.dart';
import 'package:plantix_app/app/core/extensions/int_ext.dart';
import 'package:plantix_app/app/core/theme/typography.dart';

class SeedProductsCard extends StatelessWidget {
  final VoidCallback onTap;

  const SeedProductsCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    "https://images.tokopedia.net/img/cache/500-square/product-1/2018/7/4/27298008/27298008_dd20875d-361b-4613-aeed-36c1235a425f_1024_1366.jpg.webp?ect=4g",
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nama Bibit',
                      style: TStyle.head5,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      26000.currencyFormatRp,
                      style: TStyle.bodyText2,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
