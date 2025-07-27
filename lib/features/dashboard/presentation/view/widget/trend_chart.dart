import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hisab_kitab/features/dashboard/domain/entity/chart_data_point_entity.dart';

class SalesPurchaseChart extends StatelessWidget {
  final List<ChartDataPointEntity> data;
  const SalesPurchaseChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text("No chart data available."));
    }

    final double maxYValue = data.fold<double>(
      0,
      (max, e) =>
          (e.sales > max ? e.sales : max) > e.purchases
              ? (e.sales > max ? e.sales : max)
              : e.purchases,
    );
    final double chartMaxY = (maxYValue * 1.2).ceilToDouble();

    final salesSpots = <FlSpot>[];
    final purchaseSpots = <FlSpot>[];
    for (int i = 0; i < data.length; i++) {
      salesSpots.add(FlSpot(i.toDouble(), data[i].sales));
      purchaseSpots.add(FlSpot(i.toDouble(), data[i].purchases));
    }

    return Column(
      children: [
        Expanded(
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: max(1000, chartMaxY),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: max(200, chartMaxY / 5),
                getDrawingHorizontalLine:
                    (value) => FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    ),
                getDrawingVerticalLine:
                    (value) => FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget:
                        (value, meta) => Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[700],
                          ),
                        ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 && value.toInt() < data.length) {
                        return Text(
                          data[value.toInt()].name,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[700],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                _createLineChartBarData(salesSpots, [
                  Colors.blueAccent,
                  Colors.lightBlue,
                ]),
                _createLineChartBarData(purchaseSpots, [
                  Colors.green,
                  Colors.lightGreenAccent,
                ]),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(Colors.blueAccent, "Sales"),
              const SizedBox(width: 20),
              _buildLegendItem(Colors.green, "Purchases"),
            ],
          ),
        ),
      ],
    );
  }

  LineChartBarData _createLineChartBarData(
    List<FlSpot> spots,
    List<Color> colors,
  ) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      gradient: LinearGradient(colors: colors),
      barWidth: 3,
      isStrokeCapRound: true,
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [colors.first.withOpacity(0.3), Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      dotData: FlDotData(show: false),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
