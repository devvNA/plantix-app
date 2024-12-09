import 'package:equatable/equatable.dart';

class PlantModel extends Equatable {
  final int id;
  final int fieldId;
  final String plantName;
  final String plantType;

  const PlantModel({
    required this.id,
    required this.fieldId,
    required this.plantName,
    required this.plantType,
  });

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id: json["id"] ?? 0,
      fieldId: json["field_id"] ?? 0,
      plantName: json["plant_name"] ?? "",
      plantType: json["plant_type"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "field_id": fieldId,
        "plant_name": plantName,
        "plant_type": plantType,
      };

  @override
  String toString() {
    return "$id, $fieldId, $plantName, $plantType, ";
  }

  @override
  List<Object?> get props => [
        id,
        fieldId,
        plantName,
        plantType,
      ];
}
