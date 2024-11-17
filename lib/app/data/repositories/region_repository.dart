import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:plantix_app/app/core/services/network_request.dart';
import 'package:plantix_app/app/data/models/region/city_model.dart';
import 'package:plantix_app/app/data/models/region/district_model.dart';
import 'package:plantix_app/app/data/models/region/province_model.dart';
import 'package:plantix_app/app/data/models/region/village_model.dart';

class RegionRepository {
  final ApiRequest _request = ApiRequest();

  Future<List<ProvinceModel>> getProvince() async {
    try {
      List<ProvinceModel> data = [];

      final response = await _request.get(
          "https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json");
      // Map obj = response.data;

      if (response.statusCode == 200) {
        for (var value in response.data) {
          final result = ProvinceModel.fromJson(value);
          data.add(result);
        }
        return data;
      } else {
        throw Exception('Gagal memuat data provinsi');
      }
    } on DioException catch (e) {
      log(e.response!.data.toString());
      throw Exception('Terjadi kesalahan saat memuat data provinsi');
    }
  }

  Future<List<CityModel>> getCity({required int provinceId}) async {
    try {
      List<CityModel> data = [];

      final response = await _request.get(
          "https://www.emsifa.com/api-wilayah-indonesia/api/regencies/$provinceId.json");

      if (response.statusCode == 200) {
        for (var value in response.data) {
          final result = CityModel.fromJson(value);
          data.add(result);
        }
        return data;
      } else {
        throw Exception('Gagal memuat data kota');
      }
    } on DioException catch (e) {
      log(e.response!.data.toString());
      throw Exception('Terjadi kesalahan saat memuat data kota');
    }
  }

  Future<List<DistrictModel>> getDistrict({required int cityId}) async {
    try {
      List<DistrictModel> data = [];

      final response = await _request.get(
          "https://www.emsifa.com/api-wilayah-indonesia/api/districts/$cityId.json");

      if (response.statusCode == 200) {
        for (var value in response.data) {
          final result = DistrictModel.fromJson(value);
          data.add(result);
        }
        return data;
      } else {
        throw Exception('Gagal memuat data kabupaten');
      }
    } on DioException catch (e) {
      log(e.response!.data.toString());
      throw Exception('Terjadi kesalahan saat memuat data kabupaten');
    }
  }

  Future<List<VillageModel>> getVillage({required int districtId}) async {
    try {
      List<VillageModel> data = [];

      final response = await _request.get(
          "https://www.emsifa.com/api-wilayah-indonesia/api/villages/$districtId.json");

      if (response.statusCode == 200) {
        for (var value in response.data) {
          final result = VillageModel.fromJson(value);
          data.add(result);
        }
        return data;
      } else {
        throw Exception('Gagal memuat data kelurahan');
      }
    } on DioException catch (e) {
      log(e.response!.data.toString());
      throw Exception('Terjadi kesalahan saat memuat data kelurahan');
    }
  }
}
