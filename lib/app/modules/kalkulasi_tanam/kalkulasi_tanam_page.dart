// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/currency_ext.dart';
import 'package:plantix_app/app/core/extensions/date_time_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_dropdown.dart';
import 'package:plantix_app/app/core/widgets/custom_page_header.dart';
import 'package:plantix_app/app/core/widgets/custom_text_form.dart';
import 'package:plantix_app/app/data/models/calculation_model.dart';

import 'kalkulasi_tanam_controller.dart';

class KalkulasiTanamPage extends GetView<KalkulasiTanamController> {
  const KalkulasiTanamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            PageHeader(
              title: "Kalkulasi Tanam",
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                Expanded(
                  child: Form(
                    key: controller.formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildInputCard(context),
                          const SizedBox(height: 16),
                          _buildHasilKalkulasi(),
                          const SizedBox(height: 16),
                          _buildRiwayatKalkulasi(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Input Data Pertanian', style: TStyle.head4),
            const SizedBox(height: 16),
            _buildTextField(
              controller: controller.luasLahanController,
              label: 'Luas Lahan (m²)',
              icon: Icons.landscape,
              keyboardType: TextInputType.number,
              validator:
                  (value) =>
                      value?.isEmpty ?? true
                          ? 'Harap masukkan luas lahan'
                          : null,
            ),
            const SizedBox(height: 16),
            _buildJenisTanamanDropdown(),
            const SizedBox(height: 16),
            _buildTanggalTanamField(context),
            const SizedBox(height: 16),
            _buildTextField(
              controller: controller.jumlahBenihController,
              label: 'Jumlah Benih',
              icon: Icons.grass,
              keyboardType: TextInputType.number,
              validator:
                  (value) =>
                      value?.isEmpty ?? true
                          ? 'Harap masukkan jumlah benih'
                          : null,
              suffixText: 'Kg',
            ),
            const SizedBox(height: 24),
            _buildHitungButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
    String? suffixText,
  }) {
    return CustomTextFormSimple(
      label: label,
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      suffixText: suffixText,
    );
  }

  Widget _buildJenisTanamanDropdown() {
    return Obx(() {
      return CustomDropDownSimple(
        label: 'Jenis Tanaman',
        value: controller.selectedJenisTanaman.value,
        items:
            controller.jenisTanamanList
                .map(
                  (jenis) => DropdownMenuItem(value: jenis, child: Text(jenis)),
                )
                .toList(),
        onChanged: (value) => controller.selectedJenisTanaman.value = value!,
        validator:
            (value) => value?.isEmpty ?? true ? 'Pilih jenis tanaman' : null,
      );
    });
  }

  Widget _buildTanggalTanamField(BuildContext context) {
    return CustomTextFormSimple(
      label: 'Tanggal Tanam',
      controller: controller.tanggalTanamController,
      suffixIcon: const Icon(Icons.calendar_today),
      prefixIcon: const Icon(Icons.date_range),
      readOnly: true,
      onTap: () => _selectDate(context),
      validator:
          (value) =>
              value?.isEmpty ?? true ? 'Harap pilih tanggal tanam' : null,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          controller.tanggalTanamController.text.isEmpty
              ? DateTime.now()
              : DateTime.parse(controller.tanggalTanamController.text),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != controller.tanggalTanamController.text) {
      controller.tanggalTanamController.text =
          picked.toLocal().toString().split(' ')[0];
      controller.update();
    }
  }

  Widget _buildHitungButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.submitKalkulasi,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Hitung Kalkulasi',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildHasilKalkulasi() {
    return Obx(() {
      if (controller.totalBiaya.value == 0) return const SizedBox.shrink();
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.calculate, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Hasil Kalkulasi',
                    style: TStyle.head4.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildSectionTitle('Informasi Tanaman'),
              _buildHasilItem(
                'Jenis Tanaman',
                controller.selectedJenisTanaman.value ?? '',
                icon: Icons.grass,
              ),
              _buildHasilItem(
                'Estimasi Durasi Tanam',
                '${controller.durasi.value} hari',
                icon: Icons.timer,
                description: 'Perkiraan waktu dari tanam sampai panen',
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Kebutuhan Bahan'),
              _buildHasilItem(
                'Kebutuhan Pupuk',
                '${controller.kebutuhanPupuk.value.toStringAsFixed(2)} kg',
                icon: Icons.eco,
              ),
              _buildHasilItem(
                'Kebutuhan Air',
                '${(controller.kebutuhanAir.value / 1000).toStringAsFixed(2)} m³',
                icon: Icons.water_drop,
                description: 'Total kebutuhan air selama masa tanam',
              ),
              _buildHasilItem(
                'Kebutuhan Pestisida',
                '${controller.kebutuhanPestisida.value.toStringAsFixed(2)} liter',
                icon: Icons.pest_control,
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Estimasi Biaya'),
              _buildHasilItem(
                'Biaya Benih',
                controller.biayaBenih.value.toStringAsFixed(2).currencyFormatRp,
                icon: Icons.monetization_on,
              ),
              _buildHasilItem(
                'Biaya Pupuk',
                controller.biayaPupuk.value.toStringAsFixed(2).currencyFormatRp,
                icon: Icons.monetization_on,
              ),
              _buildHasilItem(
                'Biaya Pestisida',
                controller.biayaPestisida.value
                    .toStringAsFixed(2)
                    .currencyFormatRp,
                icon: Icons.monetization_on,
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              _buildTotalBiayaItem(
                'Total Biaya Produksi',
                controller.totalBiaya.value.toStringAsFixed(2).currencyFormatRp,
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Estimasi Hasil'),
              _buildHasilPanenItem(
                'Estimasi Hasil Panen',
                '${controller.estimasiPanen.value.toStringAsFixed(2)} kg',
              ),
              _buildTanggalPanenItem(
                'Perkiraan Tanggal Panen',
                controller.tanggalTanamController.text.isNotEmpty
                    ? _calculateHarvestDate()
                    : '-',
              ),
            ],
          ),
        ),
      );
    });
  }

  String _calculateHarvestDate() {
    if (controller.tanggalTanamController.text.isEmpty ||
        controller.durasi.value == 0) {
      return '-';
    }

    final DateTime tanggalTanam = DateTime.parse(
      controller.tanggalTanamController.text,
    );
    final DateTime tanggalPanen = tanggalTanam.add(
      Duration(days: controller.durasi.value),
    );
    return tanggalPanen.toFormattedDate();
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TStyle.bodyText1.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildHasilItem(
    String label,
    String value, {
    IconData? icon,
    String? description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label:',
                  style: TStyle.bodyText2.copyWith(color: Colors.grey[700]),
                ),
                if (description != null) ...[
                  Text(
                    description,
                    style: TStyle.bodyText3.copyWith(
                      color: Colors.grey[500],
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            value,
            style: TStyle.bodyText2.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalBiayaItem(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TStyle.bodyText1.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          value,
          style: TStyle.head4.copyWith(
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildHasilPanenItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.agriculture, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TStyle.bodyText1.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            value,
            style: TStyle.head4.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTanggalPanenItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.event, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TStyle.bodyText1.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            value,
            style: TStyle.head4.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatKalkulasi() {
    return Obx(() {
      if (controller.riwayatKalkulasi.isEmpty) {
        return const SizedBox.shrink();
      }
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.history, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Riwayat Kalkulasi',
                    style: TStyle.head4.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(height: 24),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.riwayatKalkulasi.length,
                separatorBuilder: (context, index) => const Divider(height: 32),
                itemBuilder:
                    (context, index) => _buildRiwayatItem(
                      controller.riwayatKalkulasi[controller
                              .riwayatKalkulasi
                              .length -
                          1 -
                          index],
                    ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildRiwayatItem(Kalkulasi kalkulasi) {
    final DateTime tanggalPanen = kalkulasi.tanggalTanam.add(
      Duration(days: kalkulasi.durasi),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.grass, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kalkulasi.jenisTanaman,
                    style: TStyle.bodyText1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Luas Lahan: ${kalkulasi.luasLahan} m²',
                    style: TStyle.bodyText3,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Tanam: ${kalkulasi.tanggalTanam.toFormattedDate()}',
                  style: TStyle.bodyText3,
                ),
                Text(
                  'Panen: ${tanggalPanen.toFormattedDate()}',
                  style: TStyle.bodyText3.copyWith(color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Biaya: ${kalkulasi.totalBiaya.toStringAsFixed(2).currencyFormatRp}',
              style: TStyle.bodyText2.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              'Hasil: ${kalkulasi.estimasiPanen.toStringAsFixed(2)} kg',
              style: TStyle.bodyText2.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
