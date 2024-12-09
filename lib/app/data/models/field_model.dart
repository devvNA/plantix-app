import 'package:equatable/equatable.dart';

class FieldModel extends Equatable {
  const FieldModel({
    required this.id,
    required this.userId,
    required this.fieldName,
    required this.size,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String userId;
  final String fieldName;
  final double size;
  final String address;
  final String createdAt;
  final String updatedAt;

  factory FieldModel.fromJson(Map<String, dynamic> json) {
    return FieldModel(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? "",
      fieldName: json["field_name"] ?? "",
      size: json["size"] ?? "",
      address: json["address"] ?? "",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "field_name": fieldName,
        "size": size,
        "address": address,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

  @override
  String toString() {
    return "$id, $userId, $fieldName, $size, $address, $createdAt, $updatedAt, ";
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        fieldName,
        size,
        address,
        createdAt,
        updatedAt,
      ];
}
