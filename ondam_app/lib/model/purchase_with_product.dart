class PurchaseWithProductDate {
  String? companyCode;
  String? tranDate;
  int? totalPrice;
  int? cumulativeTotalPrice;
  int? salesCount;
  int? cumulativeSalesCount;
  int? countCartNum;
  int? refundCount;
  int? refundPrice;

  PurchaseWithProductDate(
    {
      this.companyCode,
      this.tranDate,
      this.totalPrice,
      this.cumulativeTotalPrice,
      this.salesCount,
      this.cumulativeSalesCount,
      this.countCartNum,
      this.refundCount,
      this.refundPrice,
    }
    );
}