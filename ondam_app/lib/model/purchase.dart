class Purchase {
  final int? purchaseNum; // A.I.
  final int cartNum;
  final String tableNum;
  final String companyCode;
  final String menuCode;
  final String tranDate;
  final int tranPrice;
  final int femaleNum;
  final int maleNum;

  Purchase({
    this.purchaseNum,
    required this.cartNum,
    required this.tableNum,
    required this.companyCode,
    required this.menuCode,
    required this.tranDate,
    required this.tranPrice,
    required this.femaleNum,
    required this.maleNum,
  });


}