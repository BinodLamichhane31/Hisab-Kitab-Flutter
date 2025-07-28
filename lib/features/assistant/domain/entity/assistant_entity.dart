// lib/features/assistant/domain/entity/assistant_message_entity.dart
import 'package:equatable/equatable.dart';

enum MessageRole { user, model, error }

class AssistantEntity extends Equatable {
  final MessageRole role;
  final String text;
  final DateTime timestamp;

  const AssistantEntity({
    required this.role,
    required this.text,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [role, text, timestamp];
}
