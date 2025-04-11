import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String address;
  final String phoneNumber;
  final String avatarUrl;
  final bool hasStore;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.avatarUrl,
    required this.hasStore,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] ?? "",
      email: json["email"] ?? "",
      name: json["name"] ?? "",
      address: json["address"] ?? "",
      phoneNumber: json["phone_number"] ?? "",
      avatarUrl: json["avatar_url"] ?? "",
      hasStore: json["has_store"] ?? false,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "name": name,
    "address": address,
    "phone_number": phoneNumber,
    "avatar_url": avatarUrl,
    "has_store": hasStore,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };

  @override
  String toString() {
    return "$id, $email, $name, $address, $phoneNumber, $avatarUrl, $hasStore, $createdAt, $updatedAt, ";
  }

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    address,
    phoneNumber,
    avatarUrl,
    hasStore,
    createdAt,
    updatedAt,
  ];
}
