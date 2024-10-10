import 'package:equatable/equatable.dart';

class CityModel extends Equatable {
    CityModel({
        required this.id,
        required this.provinceId,
        required this.name,
    });

    final String id;
    final String provinceId;
    final String name;

    CityModel copyWith({
        String? id,
        String? provinceId,
        String? name,
    }) {
        return CityModel(
            id: id ?? this.id,
            provinceId: provinceId ?? this.provinceId,
            name: name ?? this.name,
        );
    }

    factory CityModel.fromJson(Map<String, dynamic> json){ 
        return CityModel(
            id: json["id"] ?? "",
            provinceId: json["province_id"] ?? "",
            name: json["name"] ?? "",
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "province_id": provinceId,
        "name": name,
    };

    @override
    List<Object?> get props => [
    id, provinceId, name, ];
}
