import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/dashboard/domain/use_case/record_cash_in_usecase.dart';
import 'package:hisab_kitab/features/dashboard/domain/use_case/record_cash_out_usecase.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object> get props => [];
}

class LoadDashboardData extends DashboardEvent {}

class RecordCashInSubmitted extends DashboardEvent {
  final RecordCashInParams params;
  const RecordCashInSubmitted(this.params);
  @override
  List<Object> get props => [params];
}

class RecordCashOutSubmitted extends DashboardEvent {
  final RecordCashOutParams params;
  const RecordCashOutSubmitted(this.params);
  @override
  List<Object> get props => [params];
}
