// Model produk
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class Product extends Equatable {
  final int id;
  final String? name;
  final String? description;
  final double? price;
  final int? stock;
  final List<String>? images;
  final String? category;
  final DateTime? harvestDate;
  final bool? isAvailable;
  final String? storeName;
  final String? storeAddress;

  const Product({
    required this.id,
    this.name,
    this.description,
    this.price,
    this.stock,
    this.images,
    this.category,
    this.harvestDate,
    this.isAvailable,
    this.storeName,
    this.storeAddress,
  });

  Product copyWith({
    int? id,
    ValueGetter<String?>? name,
    ValueGetter<String?>? description,
    ValueGetter<double?>? price,
    ValueGetter<int?>? stock,
    ValueGetter<List<String>?>? images,
    ValueGetter<String?>? category,
    ValueGetter<DateTime?>? harvestDate,
    ValueGetter<bool?>? isAvailable,
    ValueGetter<String?>? storeName,
    ValueGetter<String?>? storeAddress,
  }) {
    return Product(
      id: id ?? this.id,
      name: name != null ? name() : this.name,
      description: description != null ? description() : this.description,
      price: price != null ? price() : this.price,
      stock: stock != null ? stock() : this.stock,
      images: images != null ? images() : this.images,
      category: category != null ? category() : this.category,
      harvestDate: harvestDate != null ? harvestDate() : this.harvestDate,
      isAvailable: isAvailable != null ? isAvailable() : this.isAvailable,
      storeName: storeName != null ? storeName() : this.storeName,
      storeAddress: storeAddress != null ? storeAddress() : this.storeAddress,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'images': images,
      'category': category,
      'harvestDate': harvestDate?.millisecondsSinceEpoch,
      'isAvailable': isAvailable,
      'storeName': storeName,
      'storeAddress': storeAddress,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id']?.toInt() ?? 0,
      name: map['name'],
      description: map['description'],
      price: map['price']?.toDouble(),
      stock: map['stock']?.toInt(),
      images: List<String>.from(map['images']),
      category: map['category'],
      harvestDate: map['harvestDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['harvestDate'])
          : null,
      isAvailable: map['isAvailable'],
      storeName: map['storeName'],
      storeAddress: map['storeAddress'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, price: $price, stock: $stock, images: $images, category: $category, harvestDate: $harvestDate, isAvailable: $isAvailable, storeName: $storeName, storeAddress: $storeAddress)';
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      description,
      price,
      stock,
      images,
      category,
      harvestDate,
      isAvailable,
      storeName,
      storeAddress,
    ];
  }
}

class ProductsModel extends Equatable {
  final int id;
  final String name;
  final String description;
  final num price;
  final int stock;
  final String category;
  final double rating;
  final List<String> imageUrl;
  final String storeName;
  final String address;

  const ProductsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.rating,
    required this.imageUrl,
    required this.storeName,
    required this.address,
  });

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      price: json["price"] ?? 0,
      stock: json["stock"] ?? 0,
      category: json["category"] ?? "",
      rating: json["rating"] ?? 0.0,
      imageUrl: json["image_url"] == null
          ? []
          : List<String>.from(json["image_url"]!.map((x) => x)),
      storeName: json["store_name"] ?? "",
      address: json["address"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "stock": stock,
        "category": category,
        "rating": rating,
        "image_url": imageUrl.map((x) => x).toList(),
        "store_name": storeName,
        "address": address,
      };

  @override
  String toString() {
    return "$id, $name, $description, $price, $stock, $category, $rating, $imageUrl, $storeName, $address, ";
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        stock,
        category,
        rating,
        imageUrl,
        storeName,
        address,
      ];
}
