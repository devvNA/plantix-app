import 'package:equatable/equatable.dart';

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
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String storeImageUrl;

  MyStoreModel copyWith({
    int? id,
    String? userId,
    String? storeName,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? storeImageUrl,
  }) {
    return MyStoreModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      storeName: storeName ?? this.storeName,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      storeImageUrl: storeImageUrl ?? this.storeImageUrl,
    );
  }

  factory MyStoreModel.fromJson(Map<String, dynamic> json) {
    return MyStoreModel(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? "",
      storeName: json["store_name"] ?? "",
      address: json["address"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      storeImageUrl: json["store_image_url"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "store_name": storeName,
    "address": address,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "store_image_url": storeImageUrl,
  };

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
