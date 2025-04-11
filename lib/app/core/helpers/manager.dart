import 'dart:developer';

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
}

class StoreManager {
  // Singleton instance
  static final StoreManager instance = StoreManager._internal();

  // Private constructor
  StoreManager._internal();

  // Menyimpan data user saat ini
  MyStoreModel? _currentStore;
  MyStoreModel? get currentStore => _currentStore;

  // Memuat data user dari repository
  Future<void> loadStoreData() async {
    final response = await MyStoreRepository().getMyStore();
    response.fold((failure) {
      log('Gagal memuat data toko: ${failure.message}');
      _currentStore = null;
    }, (store) => _currentStore = store);
  }
}
