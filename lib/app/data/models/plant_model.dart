import 'package:equatable/equatable.dart';

class PlantModel extends Equatable {
  const PlantModel({
    required this.id,
    required this.fieldId,
    required this.plantName,
    required this.plantType,
    required this.createdAt,
  });

  final int id;
  final int fieldId;
  final String plantName;
  final String plantType;
  final DateTime? createdAt;

  PlantModel copyWith({
    int? id,
    int? fieldId,
    String? plantName,
    String? plantType,
    DateTime? createdAt,
  }) {
    return PlantModel(
      id: id ?? this.id,
      fieldId: fieldId ?? this.fieldId,
      plantName: plantName ?? this.plantName,
      plantType: plantType ?? this.plantType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id: json["id"] ?? 0,
      fieldId: json["field_id"] ?? 0,
      plantName: json["plant_name"] ?? "",
      plantType: json["plant_type"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }

  @override
  String toString() {
    return "$id, $fieldId, $plantName, $plantType, $createdAt, ";
  }

  @override
  List<Object?> get props => [
        id,
        fieldId,
        plantName,
        plantType,
        createdAt,
      ];
}
