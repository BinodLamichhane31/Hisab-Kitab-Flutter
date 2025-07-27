import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';

abstract class StreamUseCaseWithParams<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

abstract class StreamUseCaseWithoutParams<Type> {
  Stream<Either<Failure, Type>> call();
}
