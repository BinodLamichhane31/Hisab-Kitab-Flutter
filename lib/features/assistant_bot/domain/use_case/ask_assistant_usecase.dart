import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/assistant_bot/domain/entity/assistant_entity.dart';
import 'package:hisab_kitab/features/assistant_bot/domain/repository/assistant_repository.dart';

class AskAssistantParams extends Equatable {
  final String query;
  final List<AssistantEntity> history;

  const AskAssistantParams({required this.query, required this.history});

  @override
  List<Object?> get props => [query, history];
}

class AskAssistantUsecase
    implements UseCaseWithParams<AssistantEntity, AskAssistantParams> {
  final IAssistantRepository _repository;

  AskAssistantUsecase({required IAssistantRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, AssistantEntity>> call(AskAssistantParams params) {
    return _repository.postQuery(
      query: params.query,
      conversationHistory: params.history,
    );
  }
}
