import 'package:equatable/equatable.dart';

class DistrictModel extends Equatable {
  const DistrictModel({
    required this.id,
    required this.regencyId,
    required this.name,
  });

  final String id;
  final String regencyId;
  final String name;

  DistrictModel copyWith({
    String? id,
    String? regencyId,
    String? name,
  }) {
    return DistrictModel(
      id: id ?? this.id,
      regencyId: regencyId ?? this.regencyId,
      name: name ?? this.name,
    );
  }

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json["id"] ?? "",
      regencyId: json["regency_id"] ?? "",
      name: json["name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "regency_id": regencyId,
        "name": name,
      };

  @override
  String toString() {
    return "$id, $regencyId, $name, ";
  }

  @override
  List<Object?> get props => [
        id,
        regencyId,
        name,
      ];
}
