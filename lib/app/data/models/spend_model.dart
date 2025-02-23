import 'package:equatable/equatable.dart';

class SpendModel extends Equatable {
  const SpendModel({
    required this.id,
    required this.spendName,
    required this.amount,
    required this.farmAnalysisId,
  });

  final int id;
  final String spendName;
  final int amount;
  final int farmAnalysisId;

  SpendModel copyWith({
    int? id,
    String? spendName,
    int? amount,
    int? farmAnalysisId,
  }) {
    return SpendModel(
      id: id ?? this.id,
      spendName: spendName ?? this.spendName,
      amount: amount ?? this.amount,
      farmAnalysisId: farmAnalysisId ?? this.farmAnalysisId,
    );
  }

  factory SpendModel.fromJson(Map<String, dynamic> json) {
    return SpendModel(
      id: json["id"] ?? 0,
      spendName: json["spend_name"] ?? "",
      amount: json["amount"] ?? 0,
      farmAnalysisId: json["farm_analysis_id"] ?? 0,
    );
  }

  @override
  String toString() {
    return "$id, $spendName, $amount, $farmAnalysisId, ";
  }

  @override
  List<Object?> get props => [
        id,
        spendName,
        amount,
        farmAnalysisId,
      ];
}
