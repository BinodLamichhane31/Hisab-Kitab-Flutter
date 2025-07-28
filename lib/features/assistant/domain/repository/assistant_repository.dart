import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/assistant/domain/entity/assistant_entity.dart';

abstract class IAssistantRepository {
  Future<Either<Failure, AssistantEntity>> postQuery({
    required String query,
    required List<AssistantEntity> conversationHistory,
  });
}
