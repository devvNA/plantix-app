import 'dart:convert';

import 'package:equatable/equatable.dart';

class HistoriTransaksi extends Equatable {
  final String id;
  final DateTime tanggal;
  final String tipePayment;
  final String statusPembayaran;
  final String urlBukti;
  final String status;
  final double total;
  final List<DetailTransaksi> detail;

  const HistoriTransaksi({
    required this.id,
    required this.tanggal,
    required this.tipePayment,
    required this.statusPembayaran,
    required this.urlBukti,
    required this.status,
    required this.total,
    required this.detail,
  });

  HistoriTransaksi copyWith({
    String? id,
    DateTime? tanggal,
    String? tipePayment,
    String? statusPembayaran,
    String? urlBukti,
    String? status,
    double? total,
    List<DetailTransaksi>? detail,
  }) {
    return HistoriTransaksi(
      id: id ?? this.id,
      tanggal: tanggal ?? this.tanggal,
      tipePayment: tipePayment ?? this.tipePayment,
      statusPembayaran: statusPembayaran ?? this.statusPembayaran,
      urlBukti: urlBukti ?? this.urlBukti,
      status: status ?? this.status,
      total: total ?? this.total,
      detail: detail ?? this.detail,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tanggal': tanggal.millisecondsSinceEpoch,
      'tipePayment': tipePayment,
      'statusPembayaran': statusPembayaran,
      'urlBukti': urlBukti,
      'status': status,
      'total': total,
      'detail': detail.map((x) => x.toMap()).toList(),
    };
  }

  factory HistoriTransaksi.fromMap(Map<String, dynamic> map) {
    return HistoriTransaksi(
      id: map['id'] ?? '',
      tanggal: DateTime.fromMillisecondsSinceEpoch(map['tanggal']),
      tipePayment: map['tipePayment'] ?? '',
      statusPembayaran: map['statusPembayaran'] ?? '',
      urlBukti: map['urlBukti'] ?? '',
      status: map['status'] ?? '',
      total: map['total']?.toDouble() ?? 0.0,
      detail: List<DetailTransaksi>.from(
          map['detail']?.map((x) => DetailTransaksi.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoriTransaksi.fromJson(String source) =>
      HistoriTransaksi.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HistoriTransaksi(id: $id, tanggal: $tanggal, tipePayment: $tipePayment, statusPembayaran: $statusPembayaran, urlBukti: $urlBukti, status: $status, total: $total, detail: $detail)';
  }

  @override
  List<Object> get props {
    return [
      id,
      tanggal,
      tipePayment,
      statusPembayaran,
      urlBukti,
      status,
      total,
      detail,
    ];
  }
}

class DetailTransaksi extends Equatable {
  final int productId;
  final String productName;
  final int quantity;
  final double harga;

  const DetailTransaksi({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.harga,
  });

  DetailTransaksi copyWith({
    int? productId,
    String? productName,
    int? quantity,
    double? harga,
  }) {
    return DetailTransaksi(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      harga: harga ?? this.harga,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'harga': harga,
    };
  }

  factory DetailTransaksi.fromMap(Map<String, dynamic> map) {
    return DetailTransaksi(
      productId: map['productId']?.toInt() ?? 0,
      productName: map['productName'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      harga: map['harga']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DetailTransaksi.fromJson(String source) =>
      DetailTransaksi.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DetailTransaksi(productId: $productId, productName: $productName, quantity: $quantity, harga: $harga)';
  }

  @override
  List<Object> get props => [productId, productName, quantity, harga];
}
