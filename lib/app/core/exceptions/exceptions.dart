import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Kelas abstrak `Failure` digunakan untuk menangani kegagalan pada proses.
abstract class Failure extends Equatable {
  /// Variabel message digunakan untuk menyimpan pesan error.
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Kelas `Exception` digunakan untuk menangani kesalahan pada proses.
class Exception extends Failure {
  const Exception(super.message);
}

/// Kelas `LocalDatabaseQueryFailure` digunakan untuk menangani kesalahan query pada database lokal.
class LocalDatabaseQueryFailure extends Failure {
  const LocalDatabaseQueryFailure(super.message);
}

/// Kelas `ConnectionFailure` digunakan untuk menangani kesalahan koneksi.
class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}

/// Kelas `ParsingFailure` digunakan untuk menangani kesalahan parsing.
class ParsingFailure extends Failure {
  const ParsingFailure(super.message);
}

/// Menangani error dari Supabase dan error umum
Failure handleError(dynamic e) {
  if (e is PostgrestException) {
    log(e.message);
    return Exception(e.message);
  }
  return Exception(e.toString());
}
