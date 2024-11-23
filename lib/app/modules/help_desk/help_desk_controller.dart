// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class HelpDeskController extends GetxController {
  final isExpanded = <bool>[].obs;
  final Uri url = Uri.parse('https://wa.me/6283871647864/');

  final List<FAQItem> faqItems = [
    FAQItem(
      'Bagaimana cara menggunakan aplikasi ini?',
      'Aplikasi ini dirancang untuk mudah digunakan. Anda dapat memulai dengan:'
          '\n\n1. Login menggunakan akun Anda'
          '\n2. Pilih menu yang tersedia di beranda'
          '\n3. Ikuti petunjuk yang ada di setiap halaman',
    ),
    FAQItem(
      'Bagaimana cara mengubah profil saya?',
      'Untuk mengubah profil:\n'
          '\n1. Buka menu profil di pojok kanan atas'
          '\n2. Tekan tombol "Edit Profil"'
          '\n3. Ubah informasi yang diinginkan'
          '\n4. Tekan "Simpan" untuk menyimpan perubahan',
    ),
    FAQItem(
      'Apa yang harus saya lakukan jika lupa password?',
      'Jika Anda lupa password, ikuti langkah berikut:'
          '\n\n1. Tekan "Lupa Password" di halaman login'
          '\n2. Masukkan email terdaftar'
          '\n3. Cek email Anda untuk instruksi selanjutnya',
    ),
    // Tambahkan FAQ lainnya sesuai kebutuhan
  ].obs;

  @override
  void onInit() {
    super.onInit();
    isExpanded.value = List.generate(faqItems.length, (index) => false);
  }

  Future<void> contactSupport() async {
    const link = WhatsAppUnilink(
      phoneNumber: '+6283871647864',
      text: "Hai Admin, Saya ingin bertanya",
    );
    // Convert the WhatsAppUnilink instance to a string.
    // Use either Dart's string interpolation or the toString() method.
    // The "launchUrlString" method is part of "url_launcher_string".
    await launchUrlString('$link');
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem(this.question, this.answer);
}
