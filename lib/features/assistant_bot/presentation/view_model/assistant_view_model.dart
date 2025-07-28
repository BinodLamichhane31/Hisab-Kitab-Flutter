import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/assistant_bot/domain/entity/assistant_entity.dart';
import 'package:hisab_kitab/features/assistant_bot/domain/use_case/ask_assistant_usecase.dart';
import 'package:hisab_kitab/features/assistant_bot/presentation/view_model/assistant_event.dart';
import 'package:hisab_kitab/features/assistant_bot/presentation/view_model/assistant_state.dart';

class AssistantViewModel extends Bloc<AssistantEvent, AssistantState> {
  final AskAssistantUsecase _askAssistantUsecase;

  AssistantViewModel(this._askAssistantUsecase)
    : super(AssistantState.initial()) {
    on<SendQuery>(_onSendQuery);
  }

  Future<void> _onSendQuery(
    SendQuery event,
    Emitter<AssistantState> emit,
  ) async {
    final userMessage = AssistantEntity(
      role: MessageRole.user,
      text: event.query,
      timestamp: DateTime.now(),
    );
    final currentMessages = List<AssistantEntity>.from(state.messages)
      ..add(userMessage);

    emit(
      state.copyWith(
        status: AssistantStatus.loading,
        messages: currentMessages,
      ),
    );

    final result = await _askAssistantUsecase(
      AskAssistantParams(query: event.query, history: state.messages),
    );

    result.fold(
      (failure) {
        final errorMessage = AssistantEntity(
          role: MessageRole.error,
          text: failure.message,
          timestamp: DateTime.now(),
        );
        emit(
          state.copyWith(
            status: AssistantStatus.error,
            messages: List.from(state.messages)..add(errorMessage),
          ),
        );
      },
      (replyMessage) {
        emit(
          state.copyWith(
            status: AssistantStatus.success,
            messages: List.from(state.messages)..add(replyMessage),
          ),
        );
      },
    );
  }
}
