import 'package:hisab_kitab/features/assistant_bot/domain/entity/assistant_entity.dart';

abstract interface class IAssistantDatasource {
  Future<String> postQuery({
    required String query,
    required List<AssistantEntity> history,
  });
}
