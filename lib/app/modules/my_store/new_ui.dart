import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  // Dummy data untuk dashboard
  var totalSales = 1500000.obs;
  var totalProducts = 50.obs;
  var totalOrders = 120.obs;
  var totalCancelled = 10.obs;

  // Dummy data untuk grafik penjualan
  var salesData = [
    {'month': 'Jan', 'sales': 300000},
    {'month': 'Feb', 'sales': 400000},
    {'month': 'Mar', 'sales': 500000},
    {'month': 'Apr', 'sales': 600000},
  ].obs;
}

class DashboardPage extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());

  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Toko Saya'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ringkasan Penjualan
            Text(
              'Ringkasan Penjualan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSummaryCard('Total Penjualan',
                      'Rp ${controller.totalSales.value}', Colors.green),
                  _buildSummaryCard('Total Produk',
                      '${controller.totalProducts.value}', Colors.blue),
                  _buildSummaryCard('Total Pesanan',
                      '${controller.totalOrders.value}', Colors.orange),
                  _buildSummaryCard('Dibatalkan',
                      '${controller.totalCancelled.value}', Colors.red),
                ],
              ),
            ),
            SizedBox(height: 32),

            // Grafik Penjualan
            Text(
              'Grafik Penjualan Bulanan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomPaint(
                  painter: SalesChartPainter(controller.salesData),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      color: color.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> salesData;

  SalesChartPainter(this.salesData);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    double barWidth = size.width / salesData.length;
    double maxSales = salesData
        .map((data) => data['sales'])
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    for (int i = 0; i < salesData.length; i++) {
      double barHeight = (salesData[i]['sales'] / maxSales) * size.height;
      canvas.drawRect(
        Rect.fromLTWH(
            i * barWidth, size.height - barHeight, barWidth - 10, barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

void main() {
  runApp(GetMaterialApp(home: DashboardPage()));
}
