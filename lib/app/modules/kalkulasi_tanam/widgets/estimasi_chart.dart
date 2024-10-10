                              // // Grafik Estimasi Panen
                              // Text(
                              //   'Grafik Estimasi Panen',
                              //   style: TextStyle(
                              //       fontSize: 18, fontWeight: FontWeight.bold),
                              // ),
                              // SizedBox(height: 16),
                              // Container(
                              //   height: 200,
                              //   child: BarChart(
                              //     BarChartData(
                              //       alignment: BarChartAlignment.spaceAround,
                              //       maxY: controller.yieldPerM2.values
                              //               .reduce((a, b) => a > b ? a : b) *
                              //           (controller.luasLahanController.text
                              //                   .isNotEmpty
                              //               ? double.parse(controller
                              //                   .luasLahanController.text)
                              //               : 10),
                              //       barTouchData: BarTouchData(
                              //         enabled: true,
                              //         touchTooltipData: BarTouchTooltipData(
                              //           getTooltipItem:
                              //               (group, groupIndex, rod, rodIndex) {
                              //             return BarTooltipItem(
                              //               '${group.x}: ${rod.toY} kg',
                              //               TextStyle(color: Colors.white),
                              //             );
                              //           },
                              //         ),
                              //       ),
                              //       titlesData: FlTitlesData(
                              //         show: true,
                              //         bottomTitles: AxisTitles(
                              //           sideTitles: SideTitles(
                              //             showTitles: true,
                              //             getTitlesWidget: (value, meta) {
                              //               return Text(
                              //                 controller.yieldPerM2.keys
                              //                     .elementAt(value.toInt()),
                              //                 style: TextStyle(
                              //                   color: Colors.black,
                              //                 ),
                              //               );
                              //             },
                              //           ),
                              //         ),
                              //       ),
                              //       borderData: FlBorderData(
                              //         show: false,
                              //       ),
                              //       barGroups: [
                              //         BarChartGroupData(
                              //           x: 0,
                              //           barRods: [
                              //             BarChartRodData(
                              //               toY: controller.estimasiPanen.value,
                              //               color: Colors.lightGreen,
                              //               width: 20,
                              //             ),
                              //           ],
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
