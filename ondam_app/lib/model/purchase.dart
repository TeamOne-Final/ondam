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


}