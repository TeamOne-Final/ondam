import 'dart:typed_data';

class Product{
  final String menuCode;
  final String menuName;
  final int menuPrice;
  final Uint8List menuImage;
  final String description;

  Product({
    required this.menuCode,
    required this.menuName,
    required this.menuPrice,
    required this.menuImage,
    required this.description,
  });
}