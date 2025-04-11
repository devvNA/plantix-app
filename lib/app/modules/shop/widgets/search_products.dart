import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/data/models/shop_response_model.dart';
import 'package:plantix_app/app/modules/shop/widgets/products_card.dart';
import 'package:plantix_app/app/routes/detail_product_routes.dart';

class ProductSearchDelegate extends SearchDelegate<String> {
  final List<ShopResponse> products;

  ProductSearchDelegate(this.products);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          // close(context, "");
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.grey[700]),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions =
        products
            .where(
              (product) =>
                  (product.name).toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];
        return InkWell(
          onTap: () {
            query = product.name;
            showResults(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(product.name, style: TStyle.bodyText2),
          ),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results =
        products
            .where(
              (product) =>
                  (product.name).toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hasil pencarian', style: TStyle.head4),
          const SizedBox(height: 8.0),
          Expanded(
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.0,
                crossAxisCount: 2,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
              ),
              itemCount: results.length,

              itemBuilder: (BuildContext context, int index) {
                return ProductMarketCards(
                      onTap: () {
                        Get.toNamed(
                          DetailProductRoutes.detailProduct,
                          arguments: results[index],
                        );
                      },
                      product: results[index],
                    )
                    .animate()
                    .fadeIn(duration: 1000.ms)
                    .move(duration: (index * 500).ms);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  String get searchFieldLabel => 'cari sayuran atau buah-buahan ...';

  @override
  TextStyle? get searchFieldStyle => TextStyle(fontSize: 16);
}
