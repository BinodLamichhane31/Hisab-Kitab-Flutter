import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/dashboard/domain/repository/dashboard_repository.dart';

class RecordCashOutParams extends Equatable {
  final String shopId;
  final String supplierId;
  final double amount;
  final String paymentMethod;
  final String? notes;
  final DateTime? transactionDate;

  const RecordCashOutParams({
    required this.shopId,
    required this.supplierId,
    required this.amount,
    required this.paymentMethod,
    this.notes,
    this.transactionDate,
  });

  @override
  List<Object?> get props => [
    shopId,
    supplierId,
    amount,
    paymentMethod,
    notes,
    transactionDate,
  ];
}

class RecordCashOutUsecase
    implements UseCaseWithParams<String, RecordCashOutParams> {
  final IDashboardRepository _repository;

  RecordCashOutUsecase({required IDashboardRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, String>> call(RecordCashOutParams params) {
    return _repository.recordCashOut(params);
  }
}
