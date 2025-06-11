class PurchaseWithProductDate {
  String? companyCode;
  String? tranDate;
  int? totalPrice;
  int? cumulativeTotalPrice;
  int? salesCount;
  int? cumulativeSalesCount;

  PurchaseWithProductDate(
    {
      this.companyCode,
      this.tranDate,
      this.totalPrice,
      this.cumulativeTotalPrice,
      this.salesCount,
      this.cumulativeSalesCount
    }
    );
}