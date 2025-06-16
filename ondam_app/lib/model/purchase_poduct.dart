class PurchasePoduct {
  final int cartNum;
  final String receiptLine;
  final String salesMenus;
  final String tranDate;
  final String userTableCompanyCode;
  final int totalPirce;

  PurchasePoduct({
    required this.cartNum,
    required this.receiptLine,
    required this.salesMenus,
    required this.tranDate,
    required this.userTableCompanyCode,
    required this.totalPirce,
  });

  factory PurchasePoduct.fromJson(Map<String, dynamic> json) {
    return PurchasePoduct(
      cartNum: json['cartNum'],
      receiptLine: json['receiptLine'],
      salesMenus: json['sales_menus'],
      tranDate:json["tranDate"],
      userTableCompanyCode: json['userTable_CompanyCode'],
      totalPirce: (json['total_pirce'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartNum': cartNum,
      'receiptLine': receiptLine,
      'sales_menus': salesMenus,
      'tranDate': tranDate,
      'userTable_CompanyCode': userTableCompanyCode,
      'total_pirce': totalPirce,
    };
  }
}