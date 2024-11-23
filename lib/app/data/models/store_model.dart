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

// =================================================================================================== //

class MyStoreModel extends Equatable {
  const MyStoreModel({
    required this.id,
    required this.userId,
    required this.storeName,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.storeImageUrl,
  });

  final int id;
  final String userId;
  final String storeName;
  final String address;
  final String createdAt;
  final String updatedAt;
  final String storeImageUrl;

  factory MyStoreModel.fromJson(Map<String, dynamic> json) {
    return MyStoreModel(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? "",
      storeName: json["store_name"] ?? "",
      address: json["address"] ?? "",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      storeImageUrl: json["store_image_url"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "store_name": storeName,
        "address": address,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "store_image_url": storeImageUrl,
      };

  @override
  String toString() {
    return "$id, $userId, $storeName, $address, $createdAt, $updatedAt, $storeImageUrl, ";
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        storeName,
        address,
        createdAt,
        updatedAt,
        storeImageUrl,
      ];
}
