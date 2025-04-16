import 'package:equatable/equatable.dart';

class HistoryModel extends Equatable {
  const HistoryModel({
    required this.orderId,
    required this.productId,
    required this.totalPrice,
    required this.products,
    required this.paymentProofs,
    required this.paymentMethod,
    required this.orderStatus,
    required this.shippingAddress,
    required this.createdAt,
  });

  final int orderId;
  final int productId;
  final int totalPrice;
  final List<ProductData> products;
  final List<String> paymentProofs;
  final String paymentMethod;
  final String orderStatus;
  final String shippingAddress;
  final DateTime? createdAt;

  HistoryModel copyWith({
    int? orderId,
    int? productId,
    int? totalPrice,
    List<ProductData>? products,
    List<String>? paymentProofs,
    String? paymentMethod,
    String? orderStatus,
    String? shippingAddress,
    DateTime? createdAt,
  }) {
    return HistoryModel(
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      totalPrice: totalPrice ?? this.totalPrice,
      products: products ?? this.products,
      paymentProofs: paymentProofs ?? this.paymentProofs,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      orderStatus: orderStatus ?? this.orderStatus,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      orderId: json["order_id"] ?? 0,
      productId: json["product_id"] ?? 0,
      totalPrice: json["total_price"] ?? 0,
      products:
          json["products"] == null
              ? []
              : List<ProductData>.from(
                json["products"]!.map((x) => ProductData.fromJson(x)),
              ),
      paymentProofs:
          json["payment_proofs"] == null
              ? []
              : List<String>.from(json["payment_proofs"]!.map((x) => x)),
      paymentMethod: json["payment_method"] ?? "",
      orderStatus: json["order_status"] ?? "",
      shippingAddress: json["shipping_address"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "product_id": productId,
    "total_price": totalPrice,
    "products": products.map((x) => x.toJson()).toList(),
    "payment_proofs": paymentProofs.map((x) => x).toList(),
    "payment_method": paymentMethod,
    "order_status": orderStatus,
    "shipping_address": shippingAddress,
    "created_at": createdAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    orderId,
    productId,
    totalPrice,
    products,
    paymentProofs,
    paymentMethod,
    orderStatus,
    shippingAddress,
    createdAt,
  ];
}

class ProductData extends Equatable {
  const ProductData({
    required this.name,
    required this.price,
    required this.category,
    required this.quantity,
    required this.imageUrl,
    required this.productId,
  });

  final String name;
  final int price;
  final String category;
  final int quantity;
  final List<String> imageUrl;
  final int productId;

  ProductData copyWith({
    String? name,
    int? price,
    String? category,
    int? quantity,
    List<String>? imageUrl,
    int? productId,
  }) {
    return ProductData(
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      productId: productId ?? this.productId,
    );
  }

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      name: json["name"] ?? "",
      price: json["price"] ?? 0,
      category: json["category"] ?? "",
      quantity: json["quantity"] ?? 0,
      imageUrl:
          json["image_url"] == null
              ? []
              : List<String>.from(json["image_url"]!.map((x) => x)),
      productId: json["product_id"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "price": price,
    "category": category,
    "quantity": quantity,
    "image_url": imageUrl.map((x) => x).toList(),
    "product_id": productId,
  };

  @override
  List<Object?> get props => [
    name,
    price,
    category,
    quantity,
    imageUrl,
    productId,
  ];
}
