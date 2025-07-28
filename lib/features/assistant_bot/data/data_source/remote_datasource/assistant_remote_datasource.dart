// lib/features/assistant/data/data_source/assistant_remote_data_source.dart
import 'package:hisab_kitab/app/constant/api_endpoints.dart';
import 'package:hisab_kitab/core/network/api_service.dart';
import 'package:hisab_kitab/features/assistant_bot/data/data_source/assistant_datasource.dart';
import 'package:hisab_kitab/features/assistant_bot/data/model/assistant_api_model.dart';
import 'package:hisab_kitab/features/assistant_bot/domain/entity/assistant_entity.dart';

class AssistantRemoteDatasource implements IAssistantDatasource {
  final ApiService _apiService;

  AssistantRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<String> postQuery({
    required String query,
    required List<AssistantEntity> history,
  }) async {
    final historyForApi =
        history.map((msg) {
          return {
            'role': msg.role.name,
            'parts': [
              {'text': msg.text},
            ],
          };
        }).toList();

    final requestModel = AssistantApiModel(
      query: query,
      conversationHistory: historyForApi,
    );

    final response = await _apiService.dio.post(
      ApiEndpoints.hisabAssistant,
      data: requestModel.toJson(),
    );

    return response.data['reply'] as String;
  }
}
