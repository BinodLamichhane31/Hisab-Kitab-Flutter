import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/assistant_bot/domain/entity/assistant_entity.dart';

enum AssistantStatus { initial, loading, success, error }

class AssistantState extends Equatable {
  final AssistantStatus status;
  final List<AssistantEntity> messages;
  final String? errorMessage;

  const AssistantState({
    required this.status,
    required this.messages,
    this.errorMessage,
  });

  factory AssistantState.initial() {
    return AssistantState(
      status: AssistantStatus.initial,
      messages: [
        AssistantEntity(
          role: MessageRole.model,
          text:
              "Hello! I'm your Hisab Assistant. How can I help you with your business data today?",
          timestamp: DateTime.now(),
        ),
      ],
    );
  }

  AssistantState copyWith({
    AssistantStatus? status,
    List<AssistantEntity>? messages,
    String? errorMessage,
  }) {
    return AssistantState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, messages, errorMessage];
}
