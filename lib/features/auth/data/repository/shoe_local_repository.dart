import 'package:dartz/dartz.dart';
import 'package:final_flutter_project/features/auth/domain/entity/shoe_entity.dart';
import 'package:final_flutter_project/features/auth/domain/repository/shoe_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/error/failure.dart';
import '../model/shoe_hive_model.dart';

class ShoeLocalRepository implements ShoeRepository {
  final Box<ShoeHiveModel> shoeBox;

  ShoeLocalRepository(this.shoeBox);

  @override
  Future<Either<Failure, List<ShoeEntity>>> getShoes() async {
    try {
      final shoes = shoeBox.values
          .map((shoeHiveModel) => shoeHiveModel.toEntity())
          .toList();
      return Right(shoes);
    } catch (e) {
      return Left(CacheFailure("Failed to load shoes from local storage."));
    }
  }

  @override
  Future<Either<Failure, void>> addShoe(ShoeEntity shoe) async {
    try {
      final shoeModel = ShoeHiveModel.fromEntity(shoe);
      await shoeBox.put(shoe.id, shoeModel);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure("Failed to add shoe to local storage."));
    }
  }

  @override
  Future<Either<Failure, void>> deleteShoe(String shoeId) async {
    try {
      await shoeBox.delete(shoeId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure("Failed to delete shoe from local storage."));
    }
  }
}
