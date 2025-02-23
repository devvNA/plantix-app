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
