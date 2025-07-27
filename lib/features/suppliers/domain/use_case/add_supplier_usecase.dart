import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/suppliers/domain/entity/supplier_entity.dart';
import 'package:hisab_kitab/features/suppliers/domain/repository/supplier_repository.dart';

class AddSupplierParams extends Equatable {
  final String name;
  final String phone;
  final String email;
  final String address;
  final double currentBalance;
  final double totalSupplied;
  final String shopId;

  const AddSupplierParams({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.currentBalance,
    required this.totalSupplied,
    required this.shopId,
  });

  const AddSupplierParams.initial()
    : name = '_empty.string',
      phone = '_empty.string',
      email = '_empty.string',
      address = '_empty.string',
      currentBalance = 0.0,
      totalSupplied = 0.0,
      shopId = '_empty.string';

  @override
  List<Object?> get props => [
    name,
    phone,
    email,
    address,
    currentBalance,
    totalSupplied,
    shopId,
  ];
}

class AddSupplierUsecase implements UseCaseWithParams<void, AddSupplierParams> {
  final ISupplierRepository supplierRepository;

  AddSupplierUsecase({required this.supplierRepository});
  @override
  Future<Either<Failure, void>> call(AddSupplierParams params) async {
    return await supplierRepository.addSupplier(
      SupplierEntity(
        name: params.name,
        phone: params.phone,
        email: params.email,
        address: params.address,
        currentBalance: params.currentBalance,
        totalSupplied: params.totalSupplied,
        shopId: params.shopId,
      ),
    );
  }
}
