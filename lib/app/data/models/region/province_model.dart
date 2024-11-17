import 'package:equatable/equatable.dart';

class ProvinceModel extends Equatable {
  const ProvinceModel({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  ProvinceModel copyWith({
    String? id,
    String? name,
  }) {
    return ProvinceModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
