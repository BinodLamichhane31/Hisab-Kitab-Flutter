import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesPurchaseChart extends StatelessWidget {
  const SalesPurchaseChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minY: 1000,
        maxY: 4000,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 500,
          getDrawingHorizontalLine:
              (value) =>
                  FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
          getDrawingVerticalLine:
              (value) =>
                  FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget:
                  (value, meta) => Text(
                    value.toInt().toString(),
                    style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                  ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final months = [
                  'Jan',
                  'Feb',
                  'Mar',
                  'Apr',
                  'May',
                  'Jun',
                  'Jul',
                  'Aug',
                  'Sep',
                  'Oct',
                  'Nov',
                  'Dec',
                ];
                if (value.toInt() >= 0 && value.toInt() < months.length) {
                  return Text(
                    months[value.toInt()],
                    style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: Colors.black12),
            left: BorderSide(color: Colors.black12),
            right: BorderSide(color: Colors.transparent),
            top: BorderSide(color: Colors.transparent),
          ),
        ),
        lineBarsData: [
          // Sales
          LineChartBarData(
            spots: [
              FlSpot(0, 2000),
              FlSpot(1, 2500),
              FlSpot(2, 1800),
              FlSpot(3, 2200),
              FlSpot(4, 3000),
              FlSpot(5, 2800),
              FlSpot(6, 3100),
              FlSpot(7, 3300),
              FlSpot(8, 2900),
              FlSpot(9, 3200),
              FlSpot(10, 3500),
              FlSpot(11, 3700),
            ],
            isCurved: true,
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.blueAccent.withOpacity(0.3),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            dotData: FlDotData(show: false),
          ),

          // Purchase
          LineChartBarData(
            spots: [
              FlSpot(0, 1500),
              FlSpot(1, 2000),
              FlSpot(2, 1600),
              FlSpot(3, 2100),
              FlSpot(4, 2700),
              FlSpot(5, 2600),
              FlSpot(6, 2800),
              FlSpot(7, 3000),
              FlSpot(8, 2500),
              FlSpot(9, 2900),
              FlSpot(10, 3100),
              FlSpot(11, 3300),
            ],
            isCurved: true,
            gradient: LinearGradient(
              colors: [Colors.green, Colors.lightGreenAccent],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [Colors.green.withOpacity(0.3), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
