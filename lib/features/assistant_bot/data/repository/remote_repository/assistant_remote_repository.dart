import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hisab_kitab/core/error/error_handler.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/assistant_bot/data/data_source/remote_datasource/assistant_remote_datasource.dart';
import 'package:hisab_kitab/features/assistant_bot/domain/entity/assistant_entity.dart';
import 'package:hisab_kitab/features/assistant_bot/domain/repository/assistant_repository.dart';

class AssistantRemoteRepository implements IAssistantRepository {
  final AssistantRemoteDatasource _dataSource;

  AssistantRemoteRepository({required AssistantRemoteDatasource dataSource})
    : _dataSource = dataSource;

  @override
  Future<Either<Failure, AssistantEntity>> postQuery({
    required String query,
    required List<AssistantEntity> conversationHistory,
  }) async {
    try {
      final replyText = await _dataSource.postQuery(
        query: query,
        history: conversationHistory,
      );
      return Right(
        AssistantEntity(
          role: MessageRole.model,
          text: replyText,
          timestamp: DateTime.now(),
        ),
      );
    } on DioException catch (e) {
      return Left(handleDioError(e));
    } catch (e) {
      return Left(
        ApiFailure(message: 'An unexpected application error occurred.'),
      );
    }
  }
}
