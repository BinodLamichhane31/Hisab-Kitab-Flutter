import 'package:equatable/equatable.dart';

class ChartDataPointEntity extends Equatable {
  final String name; // e.g., "Jan", "Feb"
  final double sales;
  final double purchases;

  const ChartDataPointEntity({
    required this.name,
    required this.sales,
    required this.purchases,
  });

  @override
  List<Object?> get props => [name, sales, purchases];
}
