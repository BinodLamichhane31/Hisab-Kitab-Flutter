import 'package:dio/dio.dart';
import 'package:hisab_kitab/app/constant/api_endpoints.dart';
import 'package:hisab_kitab/core/network/api_service.dart';
import 'package:hisab_kitab/features/dashboard/data/data_source/dashboard_data_source.dart';
import 'package:hisab_kitab/features/dashboard/data/model/chart_data_point_api_model.dart';
import 'package:hisab_kitab/features/dashboard/data/model/dashboard_stats_api_model.dart';
import 'package:hisab_kitab/features/dashboard/domain/entity/chart_data_point_entity.dart';
import 'package:hisab_kitab/features/dashboard/domain/entity/dashboard_stats_entity.dart';

class DashboardRemoteDataSource implements IDashboardDataSource {
  final ApiService _apiService;

  DashboardRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<DashboardStatsEntity> getDashboardStats(String shopId) async {
    try {
      final response = await _apiService.dio.get(
        '${ApiEndpoints.dashboard}/stats',
        queryParameters: {'shopId': shopId},
      );

      if (response.statusCode == 200) {
        final statsJson = response.data['data'];
        final apiModel = DashboardStatsApiModel.fromJson(statsJson);
        return apiModel.toEntity();
      } else {
        throw Exception(
          'Server returned status code ${response.statusCode} while fetching stats.',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch dashboard stats: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred while fetching stats: $e');
    }
  }

  @override
  Future<List<ChartDataPointEntity>> getChartData(String shopId) async {
    try {
      final response = await _apiService.dio.get(
        '${ApiEndpoints.dashboard}/chart',
        queryParameters: {'shopId': shopId},
      );

      if (response.statusCode == 200) {
        final List<dynamic> chartDataJsonList = response.data['data'];
        final List<ChartDataPointApiModel> apiModels =
            chartDataJsonList
                .map((json) => ChartDataPointApiModel.fromJson(json))
                .toList();

        return ChartDataPointApiModel.toEntityList(apiModels);
      } else {
        throw Exception(
          'Server returned status code ${response.statusCode} while fetching chart data.',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch chart data: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while fetching chart data: $e',
      );
    }
  }
}
