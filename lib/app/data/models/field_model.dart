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
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FieldModel copyWith({
    int? id,
    String? userId,
    String? fieldName,
    double? size,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FieldModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fieldName: fieldName ?? this.fieldName,
      size: size ?? this.size,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory FieldModel.fromJson(Map<String, dynamic> json) {
    return FieldModel(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? "",
      fieldName: json["field_name"] ?? "",
      size: json["size"] ?? 0.0,
      address: json["address"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

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
