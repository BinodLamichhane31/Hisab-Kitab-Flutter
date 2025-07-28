import 'package:equatable/equatable.dart';

abstract class AssistantEvent extends Equatable {
  const AssistantEvent();
  @override
  List<Object> get props => [];
}

class SendQuery extends AssistantEvent {
  final String query;
  const SendQuery(this.query);
  @override
  List<Object> get props => [query];
}
