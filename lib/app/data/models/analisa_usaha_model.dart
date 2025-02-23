import 'package:equatable/equatable.dart';

class FarmingProductionAnalysisModel extends Equatable {
  const FarmingProductionAnalysisModel({
    required this.id,
    required this.fieldId,
    required this.fieldName,
    required this.plantType,
    required this.plantingDate,
    required this.harvestDate,
    required this.harvestQuantity,
    required this.netIncome,
    required this.expenses,
  });

  final int id;
  final int fieldId;
  final String fieldName;
  final String plantType;
  final DateTime? plantingDate;
  final DateTime? harvestDate;
  final int harvestQuantity;
  final int netIncome;
  final int expenses;

  FarmingProductionAnalysisModel copyWith({
    int? id,
    int? fieldId,
    String? fieldName,
    String? plantType,
    DateTime? plantingDate,
    DateTime? harvestDate,
    int? harvestQuantity,
    int? netIncome,
    int? expenses,
  }) {
    return FarmingProductionAnalysisModel(
      id: id ?? this.id,
      fieldId: fieldId ?? this.fieldId,
      fieldName: fieldName ?? this.fieldName,
      plantType: plantType ?? this.plantType,
      plantingDate: plantingDate ?? this.plantingDate,
      harvestDate: harvestDate ?? this.harvestDate,
      harvestQuantity: harvestQuantity ?? this.harvestQuantity,
      netIncome: netIncome ?? this.netIncome,
      expenses: expenses ?? this.expenses,
    );
  }

  factory FarmingProductionAnalysisModel.fromJson(Map<String, dynamic> json) {
    return FarmingProductionAnalysisModel(
      id: json["id"] ?? 0,
      fieldId: json["field_id"] ?? 0,
      fieldName: json["field_name"] ?? "",
      plantType: json["plant_type"] ?? "",
      plantingDate: DateTime.tryParse(json["planting_date"] ?? ""),
      harvestDate: DateTime.tryParse(json["harvest_date"] ?? ""),
      harvestQuantity: json["harvest_quantity"] ?? 0,
      netIncome: json["net_income"] ?? 0,
      expenses: json["expenses"] ?? 0,
    );
  }

  @override
  String toString() {
    return "$id, $fieldId, $fieldName, $plantType, $plantingDate, $harvestDate, $harvestQuantity, $netIncome, $expenses, ";
  }

  @override
  List<Object?> get props => [
        id,
        fieldId,
        fieldName,
        plantType,
        plantingDate,
        harvestDate,
        harvestQuantity,
        netIncome,
        expenses,
      ];
}

class Pengeluaran {
  final String namaPengeluaran;
  final int jumlah;

  Pengeluaran(this.namaPengeluaran, this.jumlah);
}