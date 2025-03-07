import 'package:final_flutter_project/features/auth/domain/entity/shoe_entity.dart';
import 'package:hive/hive.dart';

part 'shoe_hive_model.g.dart';

@HiveType(typeId: 0)
class ShoeHiveModel {
  @HiveField(0)
  final String shoeId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String brand;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final List<String> sizes;

  @HiveField(6)
  final String imageUrl;

  ShoeHiveModel({
    required this.shoeId,
    required this.name,
    required this.brand,
    required this.price,
    required this.category,
    required this.sizes,
    required this.imageUrl,
  });

  /// Converts ShoeHiveModel to ShoeEntity
  ShoeEntity toEntity() {
    return ShoeEntity(
      id: shoeId,
      name: name,
      brand: brand,
      price: price,
      category: category,
      sizes: sizes,
      imageUrl: imageUrl,
    );
  }

  /// Converts ShoeEntity to ShoeHiveModel
  factory ShoeHiveModel.fromEntity(ShoeEntity entity) {
    return ShoeHiveModel(
      shoeId: entity.id,
      name: entity.name,
      brand: entity.brand,
      price: entity.price,
      category: entity.category,
      sizes: entity.sizes,
      imageUrl: entity.imageUrl,
    );
  }
}
