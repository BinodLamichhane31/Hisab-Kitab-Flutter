import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/suppliers/domain/entity/supplier_entity.dart';

abstract class SupplierDetailEvent extends Equatable {
  const SupplierDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadSupplierDetailEvent extends SupplierDetailEvent {
  final String supplierId;

  const LoadSupplierDetailEvent(this.supplierId);

  @override
  List<Object?> get props => [supplierId];
}

class UpdateSupplierDetailEvent extends SupplierDetailEvent {
  final SupplierEntity supplier;

  const UpdateSupplierDetailEvent(this.supplier);

  @override
  List<Object?> get props => [supplier];
}

class DeleteSupplierEvent extends SupplierDetailEvent {
  final String supplierId;

  const DeleteSupplierEvent(this.supplierId);

  @override
  List<Object?> get props => [supplierId];
}
