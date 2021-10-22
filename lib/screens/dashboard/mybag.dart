import 'package:flutter/material.dart';
import 'package:laundry_app/constants.dart';
import 'package:laundry_app/models/cart.dart';
import 'package:laundry_app/providers/cart.dart';
import 'package:laundry_app/screens/dashboard/quantity_controller.dart';
import 'package:laundry_app/utils/custom_textformfield.dart';
import 'package:laundry_app/utils/rounded_raisedbutton.dart';
import 'package:expandable/expandable.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class MyBagScreen extends StatefulWidget {
  @override
  _MyBagScreenState createState() => _MyBagScreenState();
}

class _MyBagScreenState extends State<MyBagScreen> {
  @override
  Widget build(BuildContext context) {
    List<CartModel> menCartItems = [];
    List<CartModel> womenCartItems = [];
    List<CartModel> householdCartItems = [];
    final cartProvider = Provider.of<CartProvider>(context);
    List<CartModel> cartItems = [];
    cartProvider.cartItems.forEach((key, value) {
      cartItems.add(value);
      if (value.category == "MEN") {
        menCartItems.add(value);
      }
      if (value.category == "WOMEN") {
        womenCartItems.add(value);
      }
      if (value.category == "HOUSEHOLD") {
        householdCartItems.add(value);
      }
    });
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text(
          "Your Bag",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios)),
        elevation: 0,
      ),
      body: Container(
        color: kPrimaryColor,
        padding: EdgeInsets.only(top: 20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          // padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/Object (7).png",
                                width: 70, height: 70),
                            SizedBox(width: 10),
                            Text(
                              "Drycleaning & Laundry",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        cartItems.length <= 0
                            ? Container(
                                height: 400,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                        "assets/images/empty_state_card.png"),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text("Your bag is Empty")
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  menCartItems.length > 0
                                      ? CartItem(
                                          title: "Men's",
                                          cart: menCartItems,
                                        )
                                      : Container(),
                                  womenCartItems.length > 0
                                      ? CartItem(
                                          title: "Women's",
                                          cart: womenCartItems,
                                        )
                                      : Container(),
                                  householdCartItems.length > 0
                                      ? CartItem(
                                          title: "Household's",
                                          cart: householdCartItems,
                                        )
                                      : Container(),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (cartItems.length <= 0) {
                    Get.snackbar('Error!', 'Add items to continue',
                        barBlur: 0,
                        dismissDirection: SnackDismissDirection.VERTICAL,
                        backgroundColor: Colors.red,
                        overlayBlur: 0,
                        animationDuration: Duration(milliseconds: 500),
                        duration: Duration(seconds: 2));
                  } else {
                    Navigator.of(context).pushNamed(kAddsOn);
                  }
                },
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "CONTINUE",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  List<CartModel> cart;
  CartItem({this.title, this.cart});
  String title;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20),
          child: Text(
            "$title",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        ListView.builder(
          itemCount: cart.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (ctx, index) {
            return ListTile(
              leading: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${cart[index].productName}"),
                  SizedBox(height: 10),
                  Text(
                    "N${cart[index].productPrice} x ${cart[index].productQuantity}",
                    style: TextStyle(
                      color: Color(0xff0285E0),
                    ),
                  )
                ],
              ),
              contentPadding: EdgeInsets.all(0),
              // title: Padding(
              //   padding: const EdgeInsets.only(left: 20.0, right: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Container(
              //           width: 70,
              //           child: QuantityController(
              //             initialValue: cart[index].productQuantity,
              //             onIncrement: (num) {
              //               if (cartProvider
              //                   .checkProductInCart(cart[index].productId)) {
              //                 cartProvider.updateProductInCART(
              //                     newProductQuantity: num,
              //                     product: CartModel(
              //                       category: cart[index].category,
              //                       image: cart[index].image,
              //                       productId: cart[index].productId,
              //                       productName: cart[index].productName,
              //                       productPrice: cart[index].productPrice,
              //                       state: cart[index].state,
              //                     ));
              //               } else {
              //                 cartProvider.addToCART(
              //                     category: cart[index].category,
              //                     image: cart[index].image,
              //                     productId: cart[index].productId,
              //                     productName: cart[index].productName,
              //                     productPrice: cart[index].productPrice,
              //                     state: cart[index].state,
              //                     productQuantity: num,
              //                     productTotalPrice:
              //                         num * cart[index].productPrice);
              //               }
              //             },
              //             onDecrement: (num) {
              //               if (num == 0) {
              //                 cartProvider.removeFromCART(
              //                     productId: cart[index].productId);
              //               } else {
              //                 cartProvider.updateProductInCART(
              //                     newProductQuantity: num,
              //                     product: CartModel(
              //                       category: cart[index].category,
              //                       image: cart[index].image,
              //                       productId: cart[index].productId,
              //                       productName: cart[index].productName,
              //                       productPrice: cart[index].productPrice,
              //                       state: cart[index].state,
              //                     ));
              //               }
              //             },
              //           )),
              //       Text("N${cart[index].productTotalPrice}"),
              //       GestureDetector(
              //           onTap: () {
              //             cartProvider.removeFromCART(
              //                 productId: cart[index].productId);
              //           },
              //           child: Image.asset("assets/images/Vector (3).png"))
              //     ],
              //   ),
              // ),
              trailing: GestureDetector(
                  onTap: () {
                    cartProvider.removeFromCART(
                        productId: cart[index].productId);
                  },
                  child: Image.asset("assets/images/Vector (3).png")),
            );
          },
        ),
      ],
    );

    // ExpandablePanel(
    //   header: Padding(
    //     padding: const EdgeInsets.only(top: 10.0),
    //     child: Text(
    //       "$title",
    //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //     ),
    //   ),
    //   expanded: ListView.builder(
    //     itemCount: cart.length,
    //     physics: NeverScrollableScrollPhysics(),
    //     shrinkWrap: true,
    //     itemBuilder: (ctx, index) {
    //       return ListTile(
    //         leading: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text("${cart[index].productName}"),
    //             SizedBox(height: 10),
    //             Text(
    //               "N${cart[index].productPrice} x ${cart[index].productQuantity}",
    //               style: TextStyle(
    //                 color: Color(0xff0285E0),
    //               ),
    //             )
    //           ],
    //         ),
    //         contentPadding: EdgeInsets.all(0),
    //         // title: Padding(
    //         //   padding: const EdgeInsets.only(left: 20.0, right: 10),
    //         //   child: Row(
    //         //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         //     children: [
    //         //       Container(
    //         //           width: 70,
    //         //           child: QuantityController(
    //         //             initialValue: cart[index].productQuantity,
    //         //             onIncrement: (num) {
    //         //               if (cartProvider
    //         //                   .checkProductInCart(cart[index].productId)) {
    //         //                 cartProvider.updateProductInCART(
    //         //                     newProductQuantity: num,
    //         //                     product: CartModel(
    //         //                       category: cart[index].category,
    //         //                       image: cart[index].image,
    //         //                       productId: cart[index].productId,
    //         //                       productName: cart[index].productName,
    //         //                       productPrice: cart[index].productPrice,
    //         //                       state: cart[index].state,
    //         //                     ));
    //         //               } else {
    //         //                 cartProvider.addToCART(
    //         //                     category: cart[index].category,
    //         //                     image: cart[index].image,
    //         //                     productId: cart[index].productId,
    //         //                     productName: cart[index].productName,
    //         //                     productPrice: cart[index].productPrice,
    //         //                     state: cart[index].state,
    //         //                     productQuantity: num,
    //         //                     productTotalPrice:
    //         //                         num * cart[index].productPrice);
    //         //               }
    //         //             },
    //         //             onDecrement: (num) {
    //         //               if (num == 0) {
    //         //                 cartProvider.removeFromCART(
    //         //                     productId: cart[index].productId);
    //         //               } else {
    //         //                 cartProvider.updateProductInCART(
    //         //                     newProductQuantity: num,
    //         //                     product: CartModel(
    //         //                       category: cart[index].category,
    //         //                       image: cart[index].image,
    //         //                       productId: cart[index].productId,
    //         //                       productName: cart[index].productName,
    //         //                       productPrice: cart[index].productPrice,
    //         //                       state: cart[index].state,
    //         //                     ));
    //         //               }
    //         //             },
    //         //           )),
    //         //       Text("N${cart[index].productTotalPrice}"),
    //         //       GestureDetector(
    //         //           onTap: () {
    //         //             cartProvider.removeFromCART(
    //         //                 productId: cart[index].productId);
    //         //           },
    //         //           child: Image.asset("assets/images/Vector (3).png"))
    //         //     ],
    //         //   ),
    //         // ),
    //         trailing: GestureDetector(
    //             onTap: () {
    //               cartProvider.removeFromCART(productId: cart[index].productId);
    //             },
    //             child: Image.asset("assets/images/Vector (3).png")),
    //       );
    //     },
    //   ),
    // );
  }
}
