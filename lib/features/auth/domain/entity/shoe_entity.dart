import 'package:equatable/equatable.dart';

class ShoeEntity extends Equatable {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String category;
  final List<String> sizes;
  final String imageUrl;

  const ShoeEntity({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.category,
    required this.sizes,
    required this.imageUrl,
  });

  @override
  List<Object?> get props =>
      [id, name, brand, price, category, sizes, imageUrl];
}
