import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/string_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_page_header.dart';
import 'package:plantix_app/app/data/models/calculation_model.dart';

import 'kalkulasi_tanam_controller.dart';

class KalkulasiTanamPage extends GetView<KalkulasiTanamController> {
  const KalkulasiTanamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Stack(
        children: [
          PageHeader(
            title: "Kalkulasi Tanam",
            height: MediaQuery.of(context).size.height * 0.17,
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
                        SizedBox(height: 12),
                        _buildHasilKalkulasi(),
                        SizedBox(height: 12),
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
    );
  }

  Widget _buildInputCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              controller: controller.luasLahanController,
              label: 'Luas Lahan (m²)',
              icon: Icons.landscape,
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Harap masukkan luas lahan' : null,
            ),
            SizedBox(height: 16),
            _buildJenisTanamanDropdown(),
            SizedBox(height: 16),
            _buildTanggalTanamField(context),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.jumlahBenihController,
              label: 'Jumlah Benih',
              icon: Icons.grass,
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Harap masukkan jumlah benih' : null,
            ),
            SizedBox(height: 16),
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
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: Colors.grey[100],
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildJenisTanamanDropdown() {
    return Obx(() {
      return DropdownButtonFormField<String>(
        value: controller.selectedJenisTanaman.value,
        decoration: InputDecoration(
          fillColor: Colors.grey[100],
          labelText: 'Jenis Tanaman',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.eco),
        ),
        items: controller.jenisTanamanList
            .map((jenis) => DropdownMenuItem(value: jenis, child: Text(jenis)))
            .toList(),
        onChanged: (value) => controller.selectedJenisTanaman.value = value!,
        validator: (value) =>
            value?.isEmpty ?? true ? 'Pilih jenis tanaman' : null,
      );
    });
  }

  Widget _buildTanggalTanamField(BuildContext context) {
    return TextFormField(
      controller: controller.tanggalTanamController,
      decoration: InputDecoration(
        labelText: 'Tanggal Tanam',
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
        prefixIcon: Icon(Icons.date_range),
      ),
      readOnly: true,
      onTap: () => _selectDate(context),
      validator: (value) =>
          value?.isEmpty ?? true ? 'Harap pilih tanggal tanam' : null,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      controller.tanggalTanamController.text =
          pickedDate.toLocal().toString().split(' ')[0];
    }
  }

  Widget _buildHitungButton() {
    return ElevatedButton(
      onPressed: controller.submitKalkulasi,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text('Hitung', style: TextStyle(fontSize: 16)),
    );
  }

  Widget _buildHasilKalkulasi() {
    return Obx(() {
      if (controller.totalBiaya.value == 0) return SizedBox.shrink();
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hasil Kalkulasi:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _buildHasilItem(
                  'Kebutuhan Pupuk', '${controller.kebutuhanPupuk.value} kg'),
              _buildHasilItem(
                  'Kebutuhan Air', '${controller.kebutuhanAir.value} liter'),
              _buildHasilItem('Kebutuhan Pestisida',
                  '${controller.kebutuhanPestisida.value} liter'),
              SizedBox(height: 8),
              _buildHasilItem(
                  'Biaya Benih',
                  controller.biayaBenih.value
                      .toStringAsFixed(2)
                      .currencyFormatRp),
              _buildHasilItem(
                  'Biaya Pupuk',
                  controller.biayaPupuk.value
                      .toStringAsFixed(2)
                      .currencyFormatRp),
              _buildHasilItem(
                  'Biaya Pestisida',
                  controller.biayaPestisida.value
                      .toStringAsFixed(2)
                      .currencyFormatRp),
              SizedBox(height: 8),
              Divider(),
              SizedBox(height: 8),
              _buildHasilItem(
                'Total Biaya',
                controller.totalBiaya.value.toStringAsFixed(2).currencyFormatRp,
                style: TStyle.head4,
              ),
              SizedBox(height: 8),
              _buildHasilItem(
                'Estimasi Hasil Panen',
                '${controller.estimasiPanen.value} kg',
                style: TStyle.head4,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHasilItem(String label, String value, {TextStyle? style}) {
    return Text(
      '$label: $value',
      style: style,
    );
  }

  Widget _buildRiwayatKalkulasi() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.riwayatKalkulasi.isEmpty) {
            return Center(
                child: Text('Belum ada riwayat kalkulasi.',
                    style: TextStyle(fontSize: 16)));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Riwayat Kalkulasi:', style: TStyle.head3),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.riwayatKalkulasi.length,
                itemBuilder: (context, index) =>
                    _buildRiwayatItem(controller.riwayatKalkulasi[index]),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildRiwayatItem(Kalkulasi kalkulasi) {
    return ListTile(
      leading: Icon(Icons.check_circle, color: Colors.green),
      title: Text('${kalkulasi.jenisTanaman} - ${kalkulasi.luasLahan} m²',
          style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Text('Tanggal Tanam: ${kalkulasi.tanggalTanam}'),
          Text('Total Biaya: Rp ${kalkulasi.totalBiaya.toStringAsFixed(2)}'),
          Text('Estimasi Panen: ${kalkulasi.estimasiPanen} kg'),
        ],
      ),
    );
  }
}
