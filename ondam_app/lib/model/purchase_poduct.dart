class PurchasePoduct {
  final int cartNum;
  final String menuName;
  final String tranDate;
  final String userTableCompanyCode;
  final int cartNumTotalPrice;

  PurchasePoduct({
    required this.cartNum,
    required this.menuName,
    required this.tranDate,
    required this.userTableCompanyCode,
    required this.cartNumTotalPrice,
  });

  // JSON -> Dart 변환
  factory PurchasePoduct.fromJson(Map<String, dynamic> json) {
    return PurchasePoduct(
      cartNum: json['cartNum'],
      menuName: json['menuName'],
      tranDate: json['tranDate'],
      userTableCompanyCode: json['userTable_CompanyCode'],
      cartNumTotalPrice: json['cartNum_total_price'],
    );
  }

  // Dart -> JSON (필요할 경우)
  Map<String, dynamic> toJson() {
    return {
      'cartNum': cartNum,
      'menuName': menuName,
      'tranDate': tranDate,
      'userTable_CompanyCode': userTableCompanyCode,
      'cartNum_total_price': cartNumTotalPrice,
    };
  }
}