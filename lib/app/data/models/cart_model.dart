import 'package:equatable/equatable.dart';

class CartModel extends Equatable {
  CartModel({
    required this.cartId,
    required this.productId,
    required this.userId,
    required this.productName,
    required this.stock,
    required this.quantity,
    required this.price,
    required this.category,
    required this.storeName,
    required this.imageUrl,
    required this.addedAt,
  });

  final int cartId;
  final int productId;
  final String userId;
  final String productName;
  final int stock;
  int quantity;
  final int price;
  final String category;
  final String storeName;
  final List<String> imageUrl;
  final DateTime? addedAt;

  CartModel copyWith({
    int? cartId,
    int? productId,
    String? userId,
    String? productName,
    int? stock,
    int? quantity,
    int? price,
    String? category,
    String? storeName,
    List<String>? imageUrl,
    DateTime? addedAt,
  }) {
    return CartModel(
      cartId: cartId ?? this.cartId,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      productName: productName ?? this.productName,
      stock: stock ?? this.stock,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      category: category ?? this.category,
      storeName: storeName ?? this.storeName,
      imageUrl: imageUrl ?? this.imageUrl,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      cartId: json["cart_id"] ?? 0,
      productId: json["product_id"] ?? 0,
      userId: json["user_id"] ?? "",
      productName: json["product_name"] ?? "",
      stock: json["stock"] ?? 0,
      quantity: json["quantity"] ?? 0,
      price: json["price"] ?? 0,
      category: json["category"] ?? "",
      storeName: json["store_name"] ?? "",
      imageUrl:
          json["image_url"] == null
              ? []
              : List<String>.from(json["image_url"]!.map((x) => x)),
      addedAt: DateTime.tryParse(json["added_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "cart_id": cartId,
    "product_id": productId,
    "user_id": userId,
    "product_name": productName,
    "stock": stock,
    "quantity": quantity,
    "price": price,
    "category": category,
    "store_name": storeName,
    "image_url": imageUrl.map((x) => x).toList(),
    "added_at": addedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    cartId,
    productId,
    userId,
    productName,
    stock,
    quantity,
    price,
    category,
    storeName,
    imageUrl,
    addedAt,
  ];
}
