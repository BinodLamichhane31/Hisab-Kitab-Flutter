import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/notification/domain/entity/notification_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_api_model.g.dart';

@JsonSerializable()
class NotificationApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String message;
  final String type;
  final String link;
  final bool isRead;
  final DateTime createdAt;

  const NotificationApiModel({
    required this.id,
    required this.message,
    required this.type,
    required this.link,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationApiModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationApiModelToJson(this);

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      message: message,
      type: _mapStringToEnum(type),
      link: link,
      isRead: isRead,
      createdAt: createdAt,
    );
  }

  static NotificationType _mapStringToEnum(String type) {
    switch (type) {
      case 'LOW_STOCK':
        return NotificationType.LOW_STOCK;
      case 'COLLECTION_OVERDUE':
        return NotificationType.COLLECTION_OVERDUE;
      case 'PAYMENT_DUE':
        return NotificationType.PAYMENT_DUE;
      default:
        return NotificationType.GENERAL;
    }
  }

  static List<NotificationEntity> toEntityList(
    List<NotificationApiModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => [id, message, type, link, isRead, createdAt];
}
