import 'package:json_annotation/json_annotation.dart';

part 'assistant_api_model.g.dart';

@JsonSerializable(createFactory: false)
class AssistantApiModel {
  final String query;
  final List<Map<String, dynamic>> conversationHistory;

  const AssistantApiModel({
    required this.query,
    required this.conversationHistory,
  });

  Map<String, dynamic> toJson() => _$AssistantRequestModelToJson(this);
}
