import 'package:equatable/equatable.dart';

class VillageModel extends Equatable {
  VillageModel({
    required this.id,
    required this.districtId,
    required this.name,
  });

  final String id;
  final String districtId;
  final String name;

  VillageModel copyWith({
    String? id,
    String? districtId,
    String? name,
  }) {
    return VillageModel(
      id: id ?? this.id,
      districtId: districtId ?? this.districtId,
      name: name ?? this.name,
    );
  }

  factory VillageModel.fromJson(Map<String, dynamic> json) {
    return VillageModel(
      id: json["id"] ?? "",
      districtId: json["district_id"] ?? "",
      name: json["name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "district_id": districtId,
        "name": name,
      };

  @override
  List<Object?> get props => [
        id,
        districtId,
        name,
      ];
}
