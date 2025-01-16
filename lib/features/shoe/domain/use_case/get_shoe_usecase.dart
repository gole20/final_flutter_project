import 'package:dartz/dartz.dart';
import 'package:final_flutter_project/app/usecase/usecase.dart';
import 'package:final_flutter_project/features/shoe/domain/entity/shoe_entity.dart';
import 'package:final_flutter_project/features/shoe/domain/repository/shoe_repository.dart';

import '../../../../core/error/failure.dart';

class GetShoesUsecase implements UsecaseWithoutParams<List<ShoeEntity>> {
  final ShoeRepository repository;

  GetShoesUsecase(this.repository);

  @override
  Future<Either<Failure, List<ShoeEntity>>> call() async {
    return await repository.getShoes();
  }
}
