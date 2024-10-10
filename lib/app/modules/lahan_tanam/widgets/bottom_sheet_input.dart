import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/helpers/validator.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_dropdown.dart';
import 'package:plantix_app/app/core/widgets/custom_text_form.dart';
import 'package:plantix_app/app/modules/lahan_tanam/lahan_tanam_controller.dart';

class AddLandBottomSheet extends GetView<LahanTanamController> {
  AddLandBottomSheet();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8.0,
            ),
            Text(
              'Tambah Lahan',
              style: TStyle.head4,
            ),
            SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextForm(
                    controller: controller.namaController,
                    hintText: 'Nama Lahan',
                    obscureText: false,
                    validator: Validator.required,
                  ),
                  const SizedBox(height: 12),
                  CustomTextForm(
                    controller: controller.luasLahanController,
                    hintText: 'Luas Lahan',
                    obscureText: false,
                    suffixText: 'm²',
                    validator: Validator.required,
                  ),
                  const SizedBox(height: 12),

                  /// === PROVINCE === ///
                  Obx(() => CustomDropdown(
                        validator: Validator.required,
                        onChanged: (value) {
                          controller.selectedProvinceId = value!;

                          ///
                          controller.selectedCityId =
                              null; // Reset kota yang dipilih
                          controller.cityList.clear(); // Kosongkan daftar kota
                          controller.selectedDistrictId =
                              null; // Reset kecamatan yang dipilih
                          controller.districtList
                              .clear(); // Kosongkan daftar kecamatan
                          controller.selectedVillageId =
                              null; // Reset kota yang dipilih
                          controller.villageList
                              .clear(); // Kosongkan daftar kota
                          log(value);

                          controller.getCity(int.parse(value));
                        },
                        hintText: 'Pilih Provinsi',
                        items: controller.provinceList.map((province) {
                          return DropdownMenuItem<String>(
                            onTap: () {
                              controller.selectedProvince.value = province.name;
                            },
                            value: province.id,
                            child: Text(province.name
                                .split(', ')
                                .map((word) => word.capitalize)
                                .join(', ')),
                          );
                        }).toList(),
                      )),
                  const SizedBox(
                    height: 12.0,
                  ),

                  /// === CITY === ///
                  Obx(() => Visibility(
                        visible: controller.cityList.isNotEmpty,
                        child: CustomDropdown(
                          validator: Validator.required,
                          value: controller.selectedCityId,
                          onChanged: (value) {
                            controller.selectedCityId = value;
                            if (value != null) {
                              controller.getDistrict(int.parse(value));
                            }
                            controller.selectedDistrictId =
                                null; // Reset kecamatan yang dipilih
                            controller.districtList
                                .clear(); // Kosongkan daftar kecamatan
                          },
                          hintText: 'Pilih Kota',
                          items: controller.cityList.map((city) {
                            return DropdownMenuItem<String>(
                              onTap: () {
                                controller.selectedCity.value = city.name;
                              },
                              value: city.id,
                              child: Text(city.name
                                  .split(', ')
                                  .map((word) => word.capitalize)
                                  .join(', ')),
                            );
                          }).toList(),
                        ),
                      )),
                  const SizedBox(
                    height: 12.0,
                  ),

                  /// === DISTRICT === ///
                  Obx(() => Visibility(
                        visible: controller.districtList.isNotEmpty,
                        child: CustomDropdown(
                          validator: Validator.required,
                          value: controller.selectedDistrictId,
                          onChanged: (value) {
                            controller.selectedDistrictId = value;
                            if (value != null) {
                              controller.getVillage(int.parse(value));

                              controller.selectedVillageId =
                                  null; // Reset desa yang dipilih
                              controller.villageList
                                  .clear(); // Kosongkan daftar desa
                            }
                          },
                          hintText: 'Pilih Kecamatan',
                          items: controller.districtList.map((district) {
                            return DropdownMenuItem<String>(
                              onTap: () {
                                controller.selectedDistrict.value =
                                    district.name;
                              },
                              value: district.id,
                              child: Text(district.name
                                  .split(', ')
                                  .map((word) => word.capitalize)
                                  .join(', ')),
                            );
                          }).toList(),
                        ),
                      )),
                  const SizedBox(
                    height: 12.0,
                  ),

                  /// === VILLAGE === ///
                  Obx(() => Visibility(
                        visible: controller.villageList.isNotEmpty,
                        child: CustomDropdown(
                          validator: Validator.required,
                          value: controller.selectedVillageId,
                          onChanged: (value) {
                            controller.selectedVillageId = value;
                            // if (value != null) {
                            //   controller.selectedDistrict =
                            //       null; // Reset kecamatan yang dipilih
                            //   controller.districtList
                            //       .clear(); // Kosongkan daftar kecamatan
                            // }
                          },
                          hintText: 'Pilih Desa',
                          items: controller.villageList.map((village) {
                            return DropdownMenuItem<String>(
                              onTap: () {
                                controller.selectedVillage.value = village.name;
                              },
                              value: village.id,
                              child: Text(village.name
                                  .split(', ')
                                  .map((word) => word.capitalize)
                                  .join(', ')),
                            );
                          }).toList(),
                        ),
                      )),
                  SizedBox(height: 12),
                  CustomTextForm(
                    controller: controller.lokasiController,
                    hintText: 'Alamat Lengkap',
                    obscureText: false,
                    maxLines: 4,
                    validator: Validator.required,
                    suffixIcon: GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.location_on,
                        size: 24.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomTextForm(
                    controller: controller.plantNameController,
                    hintText: 'Tanaman',
                    obscureText: false,
                    validator: Validator.required,
                  ),
                  const SizedBox(height: 12),
                  CustomTextForm(
                    controller: controller.plantTypeController,
                    hintText: 'Jenis Tanaman',
                    obscureText: false,
                    validator: Validator.required,
                  ),

                  const SizedBox(height: 22),
                  ElevatedButton(
                    onPressed: _submitData,
                    child: Text('Simpan'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      controller.addLahan();
    }
  }
}
