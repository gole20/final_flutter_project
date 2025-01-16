import 'package:dartz/dartz.dart';
import 'package:final_flutter_project/features/shoe/domain/entity/shoe_entity.dart';

import '../../../../core/error/failure.dart';

abstract class ShoeRepository {
  Future<Either<Failure, List<ShoeEntity>>> getShoes();
  Future<Either<Failure, void>> addShoe(ShoeEntity shoe);
  Future<Either<Failure, void>> deleteShoe(String shoeId);
}
