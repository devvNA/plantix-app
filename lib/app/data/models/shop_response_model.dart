import 'package:equatable/equatable.dart';

class ShopResponse extends Equatable {
  const ShopResponse({
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

  final int id;
  final String name;
  final String description;
  final int price;
  final int stock;
  final String category;
  final int rating;
  final List<String> imageUrl;
  final String storeName;
  final String address;

  ShopResponse copyWith({
    int? id,
    String? name,
    String? description,
    int? price,
    int? stock,
    String? category,
    int? rating,
    List<String>? imageUrl,
    String? storeName,
    String? address,
  }) {
    return ShopResponse(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      storeName: storeName ?? this.storeName,
      address: address ?? this.address,
    );
  }

  factory ShopResponse.fromJson(Map<String, dynamic> json) {
    return ShopResponse(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      price: json["price"] ?? 0,
      stock: json["stock"] ?? 0,
      category: json["category"] ?? "",
      rating: json["rating"] ?? 0,
      imageUrl:
          json["image_url"] == null
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
