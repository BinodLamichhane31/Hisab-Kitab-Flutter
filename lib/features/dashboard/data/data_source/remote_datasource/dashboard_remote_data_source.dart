import 'package:dio/dio.dart';
import 'package:hisab_kitab/app/constant/api_endpoints.dart';
import 'package:hisab_kitab/core/network/api_service.dart';
import 'package:hisab_kitab/features/dashboard/data/data_source/dashboard_data_source.dart';
import 'package:hisab_kitab/features/dashboard/data/model/chart_data_point_api_model.dart';
import 'package:hisab_kitab/features/dashboard/data/model/dashboard_stats_api_model.dart';
import 'package:hisab_kitab/features/dashboard/domain/entity/chart_data_point_entity.dart';
import 'package:hisab_kitab/features/dashboard/domain/entity/dashboard_stats_entity.dart';
import 'package:hisab_kitab/features/dashboard/domain/use_case/record_cash_in_usecase.dart';
import 'package:hisab_kitab/features/dashboard/domain/use_case/record_cash_out_usecase.dart';

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

  @override
  Future<String> recordCashIn(RecordCashInParams params) async {
    try {
      final Map<String, dynamic> data = {
        'shopId': params.shopId,
        'customerId': params.customerId,
        'amount': params.amount,
        'paymentMethod': params.paymentMethod,
        'notes': params.notes,
        if (params.transactionDate != null)
          'transactionDate': params.transactionDate!.toIso8601String(),
      };

      final response = await _apiService.dio.post(
        '${ApiEndpoints.cash}/in',
        data: data,
      );

      if (response.statusCode == 200) {
        return response.data['message'] as String;
      } else {
        throw Exception(
          'Server returned status code ${response.statusCode} while recording cash in.',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to record cash in: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while recording cash in: $e',
      );
    }
  }

  @override
  Future<String> recordCashOut(RecordCashOutParams params) async {
    try {
      final Map<String, dynamic> data = {
        'shopId': params.shopId,
        'supplierId': params.supplierId,
        'amount': params.amount,
        'paymentMethod': params.paymentMethod,
        'notes': params.notes,
        if (params.transactionDate != null)
          'transactionDate': params.transactionDate!.toIso8601String(),
      };

      final response = await _apiService.dio.post(
        '${ApiEndpoints.cash}/out',
        data: data,
      );

      if (response.statusCode == 200) {
        return response.data['message'] as String;
      } else {
        throw Exception(
          'Server returned status code ${response.statusCode} while recording cash out.',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to record cash out: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while recording cash out: $e',
      );
    }
  }
}
