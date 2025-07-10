import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
sealed class ShopEvent {}

final class LoadShopsEvent extends ShopEvent {}

final class CreateShopEvent extends ShopEvent {
  final String shopName;
  final String? address;
  final String? contactNumber;

  CreateShopEvent({required this.shopName, this.address, this.contactNumber});
}

class NavigateToHomeView extends ShopEvent {
  final BuildContext context;
  final Widget destination;

  NavigateToHomeView({required this.context, required this.destination});
}
