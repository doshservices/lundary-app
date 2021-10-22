class TakeOrderModel {
  bool isIroning;
  bool express;
  bool extraStarch;
  String note, selectedStarch;
  String paymentMethod;
  TakeOrderModel(
      {this.express,
      this.extraStarch,
      this.selectedStarch,
      this.isIroning,
      this.note,
      this.paymentMethod});
}
