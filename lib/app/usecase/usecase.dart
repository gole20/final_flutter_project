import 'package:dartz/dartz.dart';
import 'package:final_flutter_project/core/error/failure.dart';


/// A usecase interface with parameters.
abstract interface class UsecaseWithParams<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

/// A usecase interface without parameters.
abstract interface class UsecaseWithoutParams<SuccessType> {
  Future<Either<Failure, SuccessType>> call();
}
