import 'package:equatable/equatable.dart';

class DashboardStatsEntity extends Equatable {
  final int totalCustomers;
  final int totalSuppliers;
  final double receivableAmount;
  final double payableAmount;

  const DashboardStatsEntity({
    required this.totalCustomers,
    required this.totalSuppliers,
    required this.receivableAmount,
    required this.payableAmount,
  });

  @override
  List<Object?> get props => [
    totalCustomers,
    totalSuppliers,
    receivableAmount,
    payableAmount,
  ];
}
