import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/dashboard/domain/entity/dashboard_data_entity.dart';
import 'package:hisab_kitab/features/dashboard/domain/use_case/record_cash_in_usecase.dart';
import 'package:hisab_kitab/features/dashboard/domain/use_case/record_cash_out_usecase.dart';

abstract class IDashboardRepository {
  Future<Either<Failure, DashboardDataEntity>> getDashboardData({
    required String shopId,
  });
  Future<Either<Failure, String>> recordCashIn(RecordCashInParams params);
  Future<Either<Failure, String>> recordCashOut(RecordCashOutParams params);
}
