import 'package:plantix_app/app/data/models/plant_model.dart';

class Lahan {
  final int id;
  final String fieldName;
  final String fieldArea;
  final String fieldAddress;
  final Plant? plants;

  Lahan({
    required this.id,
    required this.fieldName,
    required this.fieldArea,
    required this.fieldAddress,
    this.plants,
  });
}
