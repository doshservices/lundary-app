import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import './../models/cart.dart';
import './../models/http_exception.dart';
import 'package:laundry_app/config.dart';

class CartProvider with ChangeNotifier {
  String token;
  Map<String, CartModel> cartItems = {};
  double cartTotalAmount = 0;

  CartProvider(this.token, this.cartItems, this.cartTotalAmount);

  void addToCART({
    String productId,
    String productName,
    int productQuantity,
    double productPrice,
    double productTotalPrice,
    String image,
    String category,
    String state,
  }) {
    print(image);
    cartItems[productId] = CartModel(
      productId: productId,
      productName: productName,
      productQuantity: productQuantity,
      productPrice: productPrice,
      category: category,
      state: state,
      productTotalPrice: productTotalPrice,
      image: image,
    );
    calculateCartTotalAmount();
    notifyListeners();
  }

  void updateProductInCART(
      //   {
      //   int productId,
      //   String productName,
      //   int productQuantity,
      //   double productPrice,
      //   double productTotalPrice,
      // }
      {CartModel product,
      int newProductQuantity}) {
    cartItems.update(product.productId, (value) {
      return CartModel(
        productId: product.productId,
        productName: product.productName,
        productQuantity: newProductQuantity,
        productPrice: product.productPrice,
        category: product.category,
        state: product.state,
        image: product.image,
        productTotalPrice: product.productPrice * newProductQuantity,
      );
    });

    calculateCartTotalAmount();

    notifyListeners();
  }

  void calculateCartTotalAmount() {
    cartTotalAmount = 0;
    if (cartItems.length > 0) {
      cartItems.forEach((key, value) {
        cartTotalAmount += value.productTotalPrice;
      });
    }
  }

  void removeFromCART({
    String productId,
  }) {
    cartItems.remove(productId);
    calculateCartTotalAmount();
    notifyListeners();
  }

  void clearCART() {
    cartItems.clear();
    calculateCartTotalAmount();
    notifyListeners();
  }

  //to check if product is in cart
  bool checkProductInCart(String productId) {
    return cartItems.containsKey(productId) ? true : false;
  }

  // //Cart Transactions
  // Future<void> checkOutFromWallet() async {
  //   Map<String, Map<String, dynamic>> cart = {};
  //   cartItems.forEach((key, value) {
  //     cart["${value.productToken}"] = {
  //       "token": value.productToken,
  //       "name": value.productName,
  //       "quantity": value.productQuantity,
  //       "price": value.productPrice.toInt()
  //     };
  //   });
  //   print(cart);
  //   try {
  //     var data = jsonEncode({"paymentType": 1, "cart": cart});
  //     final response = await http.post("$kBaseUrl/cart/make-payment",
  //         headers: {
  //           "Authorization": "Bearer $token",
  //           "content-type": "application/json"
  //         },
  //         body: data);
  //     print(data);
  //     var resData = jsonDecode(response.body);
  //     print(resData);

  //     if (resData["status"] == true) {
  //       clearCART();
  //     } else {
  //       print(resData);
  //       throw HttpException(resData["errors"]);
  //     }

  //     print(resData);

  //     notifyListeners();
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  // Future<void> checkOutWithPaystack({String ref}) async {
  //   Map<String, Map<String, dynamic>> cart = {};
  //   cartItems.forEach((key, value) {
  //     cart["${value.productToken}"] = {
  //       "token": value.productToken,
  //       "name": value.productName,
  //       "quantity": value.productQuantity,
  //       "price": value.productPrice.toInt()
  //     };
  //   });
  //   print(cart);
  //   try {
  //     final response = await http.post(
  //       "$kBaseUrl/cart/make-payment",
  //       headers: {
  //         "Authorization": "Bearer $token",
  //         "content-type": "application/json"
  //       },
  //       body: jsonEncode(
  //           {"paymentType": 2, "cart": cart, "transaction_ref": ref}),
  //     );
  //     print(response);
  //     var resData = jsonDecode(response.body);
  //     print(resData);

  //     if (resData["status"] == true) {
  //       clearCART();
  //     } else {
  //       print(resData);
  //       throw HttpException(resData["errors"]);
  //     }

  //     print(resData);

  //     notifyListeners();
  //   } catch (error) {
  //     throw error;
  //   }
  // }
}
