class Purchase {
  final int? purchaseNum; // A.I.
  final int cartNum;
  final String tableNum;
  final String companyCode;
  final String menuCode;
  final String tranDate;
  final int femaleNum;
  final int maleNum;
  final int quantity;

  Purchase({
    this.purchaseNum,
    required this.cartNum,
    required this.tableNum,
    required this.companyCode,
    required this.menuCode,
    required this.tranDate,
    required this.femaleNum,
    required this.maleNum,
    required this.quantity
  });


factory Purchase.fromJson(List<dynamic>json){
  return Purchase(
    cartNum: json[0]??0, 
    tableNum: json[1]??"", 
    companyCode: json[2]??"", 
    menuCode: json[3]??"", 
    tranDate: json[4]??"", 
    femaleNum: json[5]??0, 
    maleNum: json[6]??0, 
    quantity: json[7]??0
  );
}
}