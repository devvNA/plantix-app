import 'dart:async';

import 'package:get_storage/get_storage.dart';
import 'package:plantix_app/app/data/models/store_model.dart';

class LocalStorageService {
  // Singleton pattern
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  // Instance GetStorage
  final _storage = GetStorage();

  // Key constants untuk storage
  static const String keyUserProfile = 'user_profile';
  static const String keyAuthToken = 'auth_token';
  static const String keySettings = 'settings';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyFirstTime = 'first_time';
  static const String keyLastSync = 'last_sync';
  static const String keyCachedData = 'cached_data';

  // Generic method untuk menyimpan data
  Future<void> saveData<T>(String key, T value) async {
    try {
      await _storage.write(key, value);
    } catch (e) {
      throw Exception('Gagal menyimpan data: $e');
    }
  }

  // Generic method untuk mengambil data
  T? getData<T>(String key) {
    try {
      return _storage.read<T>(key);
    } catch (e) {
      throw Exception('Gagal mengambil data: $e');
    }
  }

  // Method untuk menghapus data spesifik
  Future<void> removeData(String key) async {
    try {
      await _storage.remove(key);
    } catch (e) {
      throw Exception('Gagal menghapus data: $e');
    }
  }

  // Method untuk menghapus semua data
  Future<void> clearAll() async {
    try {
      await _storage.erase();
    } catch (e) {
      throw Exception('Gagal menghapus semua data: $e');
    }
  }

  // Method untuk memeriksa apakah key ada
  bool hasData(String key) {
    try {
      return _storage.hasData(key);
    } catch (e) {
      throw Exception('Gagal memeriksa keberadaan data: $e');
    }
  }

  // Method untuk menyimpan data dengan expiry time
  Future<void> saveDataWithExpiry(
      String key, dynamic value, Duration expiry) async {
    try {
      final expiryTime = DateTime.now().add(expiry).millisecondsSinceEpoch;
      final dataToStore = {
        'value': value,
        'expiry': expiryTime,
      };
      await _storage.write(key, dataToStore);
    } catch (e) {
      throw Exception('Gagal menyimpan data dengan expiry: $e');
    }
  }

  // Method untuk mengambil data dengan expiry check
  T? getDataWithExpiry<T>(String key) {
    try {
      final data = _storage.read(key);
      if (data == null) return null;

      final expiryTime = data['expiry'] as int;
      if (DateTime.now().millisecondsSinceEpoch > expiryTime) {
        // Data sudah expired, hapus data
        removeData(key);
        return null;
      }
      return data['value'] as T;
    } catch (e) {
      throw Exception('Gagal mengambil data dengan expiry: $e');
    }
  }

  // Method untuk menyimpan list data
  Future<void> saveList<T>(String key, List<T> list) async {
    try {
      await _storage.write(key, list);
    } catch (e) {
      throw Exception('Gagal menyimpan list: $e');
    }
  }

  // Method untuk mengambil list data
  List<T>? getList<T>(String key) {
    try {
      final data = _storage.read(key);
      if (data == null) return null;
      return List<T>.from(data);
    } catch (e) {
      throw Exception('Gagal mengambil list: $e');
    }
  }

  // Method untuk menambah item ke list yang sudah ada
  Future<void> addToList<T>(String key, T item) async {
    try {
      final existingList = getList<T>(key) ?? [];
      existingList.add(item);
      await saveList<T>(key, existingList);
    } catch (e) {
      throw Exception('Gagal menambah item ke list: $e');
    }
  }

  // Method untuk mengupdate item dalam list
  Future<void> updateListItem<T>(String key, int index, T newItem) async {
    try {
      final existingList = getList<T>(key);
      if (existingList == null || index >= existingList.length) {
        throw Exception('Index tidak valid atau list tidak ditemukan');
      }
      existingList[index] = newItem;
      await saveList<T>(key, existingList);
    } catch (e) {
      throw Exception('Gagal mengupdate item dalam list: $e');
    }
  }

  // Method untuk menghapus item dari list
  Future<void> removeFromList<T>(String key, int index) async {
    try {
      final existingList = getList<T>(key);
      if (existingList == null || index >= existingList.length) {
        throw Exception('Index tidak valid atau list tidak ditemukan');
      }
      existingList.removeAt(index);
      await saveList<T>(key, existingList);
    } catch (e) {
      throw Exception('Gagal menghapus item dari list: $e');
    }
  }

  // Method untuk menyimpan map data
  Future<void> saveMap<K, V>(String key, Map<K, V> map) async {
    try {
      await _storage.write(key, map);
    } catch (e) {
      throw Exception('Gagal menyimpan map: $e');
    }
  }

  // Method untuk mengambil map data
  Map<K, V>? getMap<K, V>(String key) {
    try {
      final data = _storage.read(key);
      if (data == null) return null;
      return Map<K, V>.from(data);
    } catch (e) {
      throw Exception('Gagal mengambil map: $e');
    }
  }
}

// class UserManager {
//   static final UserManager _instance = UserManager._internal();
//   final _dbServices = LocalStorageService();

//   factory UserManager() {
//     return _instance;
//   }

//   UserManager._internal();

//   UserModel? _currentUser;

//   UserModel? get currentUser => _currentUser;

//   Future<UserModel?> getUser() async {
//     if (_currentUser != null) {
//       return _currentUser;
//     }

//     final userData = _dbServices.getData('LoggedInUser');
//     if (userData != null) {
//       _currentUser = userData;
//       return _currentUser;
//     }

//     return null;
//   }
// }

class DBServices {
  // Simulasi penyimpanan data toko
  static StoreModel? _store;

  static Future<StoreModel?> getStore() async {
    // Ganti dengan logika pengambilan data dari database atau API
    await Future.delayed(const Duration(milliseconds: 500));
    return _store;
  }

  static Future<void> updateStore(StoreModel store) async {
    // Ganti dengan logika pembaruan data di database atau API
    await Future.delayed(const Duration(milliseconds: 500));
    _store = store;
  }

  static Future<String> uploadStoreImage(String path) async {
    // Ganti dengan logika upload gambar ke server dan mendapatkan URL
    await Future.delayed(const Duration(milliseconds: 500));
    return "https://res.cloudinary.com/dotz74j1p/image/upload/v1715660683/no-image.jpg";
  }
}
