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
    factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      menuCode: json['menuCode'], 
      menuName: json['menuName'], 
      menuPrice: json['menuPrice'], 
      menuImage: json['menuImage'], 
      description: json['description']
    );
  }

  Map<String, dynamic> toJSON(){
    return {
      'menuCode': menuCode,
      'menuName': menuName,
      'menuPrice': menuPrice,
      'menuImage': menuImage,
      'description': description
    };
  }
}