// Model keranjang
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:plantix_app/app/data/models/product_model.dart';

class CartItem extends Equatable {
  List<Product>? product;
  int? quantity;
  double? price;

  CartItem({
    this.product,
    this.quantity,
    this.price,
  });

  CartItem copyWith({
    ValueGetter<List<Product>?>? product,
    ValueGetter<int?>? quantity,
    ValueGetter<double?>? price,
  }) {
    return CartItem(
      product: product != null ? product() : this.product,
      quantity: quantity != null ? quantity() : this.quantity,
      price: price != null ? price() : this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product?.map((x) => x.toJson()).toList(),
      'quantity': quantity,
      'price': price,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: map['product'] != null
          ? List<Product>.from(map['product']?.map((x) => Product.fromJson(x)))
          : null,
      quantity: map['quantity']?.toInt(),
      price: map['price']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) =>
      CartItem.fromMap(json.decode(source));

  @override
  String toString() =>
      'CartItem(product: $product, quantity: $quantity, price: $price)';

  @override
  List<Object?> get props => [product, quantity, price];
}