import 'package:laundry_app/models/cart.dart';
import 'package:laundry_app/screens/dashboard/dry_cleaning.dart';

class OrderModel {
  String paymentMethod,
      ironingAndFolding,
      extraStarch,
      express,
      isSpecialOrder,
      id,
      userId,
      address,
      contact,
      deliverTo,
      pickupDate,
      pickupTime,
      deliveryDate,
      deliveryTime,
      orderNumber,
      orderStatus;
  double totalPrice;
  List<CartModel> items;
  OrderModel(
      {this.address,
      this.contact,
      this.deliverTo,
      this.deliveryDate,
      this.deliveryTime,
      this.express,
      this.extraStarch,
      this.id,
      this.items,
      this.ironingAndFolding,
      this.isSpecialOrder,
      this.orderNumber,
      this.orderStatus,
      this.paymentMethod,
      this.pickupDate,
      this.pickupTime,
      this.totalPrice,
      this.userId});
}
