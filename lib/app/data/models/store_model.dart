import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:plantix_app/app/data/models/product_model.dart';

class StoreModel extends Equatable {
  final String name;
  final String address;
  final String imageUrl;
  final double balance;
  final Map<String, int> salesStatus;
  final List<Product> products;

  const StoreModel({
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.balance,
    required this.salesStatus,
    required this.products,
  });

  StoreModel copyWith({
    String? name,
    String? address,
    String? imageUrl,
    double? balance,
    Map<String, int>? salesStatus,
    List<Product>? products,
  }) {
    return StoreModel(
      name: name ?? this.name,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      balance: balance ?? this.balance,
      salesStatus: salesStatus ?? this.salesStatus,
      products: products ?? this.products,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'imageUrl': imageUrl,
      'balance': balance,
      'salesStatus': salesStatus,
      'products': products.map((x) => x.toMap()).toList(),
    };
  }

  factory StoreModel.fromMap(Map<String, dynamic> map) {
    return StoreModel(
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      balance: map['balance']?.toDouble() ?? 0.0,
      salesStatus: Map<String, int>.from(map['salesStatus']),
      products:
          List<Product>.from(map['products']?.map((x) => Product.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreModel.fromJson(String source) =>
      StoreModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StoreModel(name: $name, address: $address, imageUrl: $imageUrl, balance: $balance, salesStatus: $salesStatus, products: $products)';
  }

  @override
  List<Object> get props {
    return [
      name,
      address,
      imageUrl,
      balance,
      salesStatus,
      products,
    ];
  }
}
