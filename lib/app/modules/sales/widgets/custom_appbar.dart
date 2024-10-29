import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/data/models/product_model.dart';
import 'package:plantix_app/app/modules/cart/cart_controller.dart';
import 'package:plantix_app/app/modules/sales/sales_controller.dart';
import 'package:plantix_app/app/modules/sales/widgets/products_card.dart';
import 'package:plantix_app/app/routes/cart_routes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SalesController>();
    final cartController = Get.find<CartController>();
    return AppBar(
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      title: Text(
        "Toko",
        style: TStyle.head3.copyWith(color: Colors.white),
      ),
      actions: [
        IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: ProductSearchDelegate(controller.products),
            );
          },
          icon: Icon(
            Icons.search,
            size: 24.0,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            Get.toNamed(CartRoutes.cart);
          },
          icon: Badge(
            label: Obx(() {
              return Text(
                cartController.cartProductList.length.toString(),
                style: TextStyle(
                  color: Colors.white,
                ),
              );
            }),
            child: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ProductSearchDelegate extends SearchDelegate<String> {
  final List<Product> products;

  ProductSearchDelegate(this.products);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.grey[700],
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return ProductMarketCards(onTap: () {}, product: product);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];
        return ListTile(
          title: Text(product.name),
          onTap: () {
            query = product.name;
            showResults(context);
          },
        );
      },
    );
  }

  @override
  String get searchFieldLabel => 'cari sayuran atau buah-buahan ...';

  @override
  TextStyle? get searchFieldStyle => TextStyle(fontSize: 16);
}
