import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/dashboard/domain/repository/dashboard_repository.dart';

class RecordCashInParams extends Equatable {
  final String shopId;
  final String customerId;
  final double amount;
  final String paymentMethod;
  final String? notes;
  final DateTime? transactionDate;

  const RecordCashInParams({
    required this.shopId,
    required this.customerId,
    required this.amount,
    required this.paymentMethod,
    this.notes,
    this.transactionDate,
  });

  @override
  List<Object?> get props => [
    shopId,
    customerId,
    amount,
    paymentMethod,
    notes,
    transactionDate,
  ];
}

class RecordCashInUsecase
    implements UseCaseWithParams<String, RecordCashInParams> {
  final IDashboardRepository _repository;

  RecordCashInUsecase({required IDashboardRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, String>> call(RecordCashInParams params) {
    return _repository.recordCashIn(params);
  }
}
