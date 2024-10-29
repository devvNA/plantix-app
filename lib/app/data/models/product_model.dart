// Model produk
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final List<String> images;
  final String category;
  final DateTime harvestDate;
  final bool isAvailable;
  final String storeName;
  final String storeAddress;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.images,
    required this.category,
    required this.harvestDate,
    required this.isAvailable,
    required this.storeName,
    required this.storeAddress,
  });

  Product copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    int? stock,
    List<String>? images,
    String? category,
    DateTime? harvestDate,
    bool? isAvailable,
    String? storeName,
    String? storeAddress,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      images: images ?? this.images,
      category: category ?? this.category,
      harvestDate: harvestDate ?? this.harvestDate,
      isAvailable: isAvailable ?? this.isAvailable,
      storeName: storeName ?? this.storeName,
      storeAddress: storeAddress ?? this.storeAddress,
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
      'harvestDate': harvestDate.millisecondsSinceEpoch,
      'isAvailable': isAvailable,
      'storeName': storeName,
      'storeAddress': storeAddress,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      stock: map['stock']?.toInt() ?? 0,
      images: List<String>.from(map['images']),
      category: map['category'] ?? '',
      harvestDate: DateTime.fromMillisecondsSinceEpoch(map['harvestDate']),
      isAvailable: map['isAvailable'] ?? false,
      storeName: map['storeName'] ?? '',
      storeAddress: map['storeAddress'] ?? '',
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
  List<Object> get props {
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
