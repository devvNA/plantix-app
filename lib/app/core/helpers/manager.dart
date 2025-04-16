import 'dart:developer';

import 'package:get/get.dart';
import 'package:plantix_app/app/data/models/store_model.dart';
import 'package:plantix_app/app/data/models/user_model.dart';
import 'package:plantix_app/app/data/repositories/my_store_repository.dart';
import 'package:plantix_app/app/data/repositories/profile_repository.dart';

class UserManager {
  // Singleton instance
  static final UserManager instance = UserManager._internal();

  // Private constructor
  UserManager._internal();

  // Menyimpan data user saat ini
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  // Status kepemilikan toko
  bool? _hasStore;
  bool get hasStore => _hasStore ?? false;

  // Memuat data user dari repository
  Future<void> loadUserData() async {
    final response = await ProfileRepository().getUser();
    response.fold(
      (failure) {
        log('Gagal memuat data user: ${failure.message}');
        _currentUser = null;
        _hasStore = false;
      },
      (user) {
        _currentUser = user;
        _hasStore = user.hasStore;
      },
    );
  }

  /// Membersihkan data user saat logout
  void clearUserData() {
    _currentUser = null;
    _hasStore = false;
    log('Data user telah dibersihkan');
  }
}

/// Manager untuk mengelola data toko
class StoreManager {
  // Singleton instance
  static final StoreManager instance = StoreManager._internal();

  // Private constructor
  StoreManager._internal();

  // Reactive data untuk toko saat ini
  final Rx<MyStoreModel?> _currentStoreRx = Rx<MyStoreModel?>(null);

  // Menyimpan data toko saat ini
  MyStoreModel? get currentStore => _currentStoreRx.value;

  // Stream untuk memantau perubahan data toko
  Stream<MyStoreModel?> get storeStream => _currentStoreRx.stream;

  /// Memeriksa apakah toko sudah dimuat
  // bool get isStoreLoaded => currentStore != null;

  /// Memuat data toko dari repository
  Future<void> loadStoreData() async {
    final response = await MyStoreRepository().getMyStore();
    response.fold(
      (failure) {
        log('Gagal memuat data toko: ${failure.message}');
        _currentStoreRx.value = null;
      },
      (store) {
        log('Berhasil memuat data toko: ${store.storeName}');
        _currentStoreRx.value = store;
      },
    );
  }

  /// Memperbarui data toko secara lokal tanpa memanggil API
  void updateStoreLocalData(MyStoreModel store) {
    _currentStoreRx.value = store;
  }

  /// Membersihkan data toko saat logout
  void clearStoreData() {
    _currentStoreRx.value = null;
    log('Data toko telah dibersihkan');
  }
}
