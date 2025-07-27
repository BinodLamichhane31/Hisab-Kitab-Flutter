import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/dashboard/domain/entity/dashboard_data_entity.dart';
import 'package:hisab_kitab/features/dashboard/domain/repository/dashboard_repository.dart';

class GetDashboardDataUsecase
    implements UseCaseWithParams<DashboardDataEntity, String> {
  final IDashboardRepository _dashboardRepository;

  GetDashboardDataUsecase({required IDashboardRepository dashboardRepository})
    : _dashboardRepository = dashboardRepository;

  @override
  Future<Either<Failure, DashboardDataEntity>> call(String shopId) {
    return _dashboardRepository.getDashboardData(shopId: shopId);
  }
}
