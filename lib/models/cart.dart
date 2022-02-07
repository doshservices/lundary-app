class CartModel {
  int productQuantity;

  double productPrice, productTotalPrice;
  String productName, productId, image, state, category;
  CartModel({
    this.productId,
    this.productQuantity,
    this.productPrice,
    this.productTotalPrice,
    this.productName,
    this.image,
    this.category,
    this.state,
  });
}
