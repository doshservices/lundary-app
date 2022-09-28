import 'package:flutter/material.dart';
import 'package:laundry_app/constants.dart';
import 'package:laundry_app/models/cart.dart';
import 'package:laundry_app/models/service_model.dart';
import 'package:laundry_app/providers/auth.dart';
import 'package:laundry_app/providers/cart.dart';
import 'package:laundry_app/providers/service_provider.dart';
import 'package:laundry_app/screens/dashboard/quantity_controller.dart';
import 'package:provider/provider.dart';

class DryCleaningScreen extends StatefulWidget {
  @override
  _DryCleaningScreenState createState() => _DryCleaningScreenState();
}

class _DryCleaningScreenState extends State<DryCleaningScreen> {
  String category = "MEN";
  String type = "";

  @override
  Widget build(BuildContext context) {
    final serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    final authProvider = Provider.of<Auth>(context);
    // final cartProvider = Provider.of<CartProvider>(context);
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    type = arguments["type"];
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text(
          "${type == 'LAUNDRY' ? 'Laundry' : 'Dry Clean'}",
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
          child: Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Column(
                children: [
                  child,
                  Column(
                    children: [
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Your Basket",
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "${cart.cartItems.length} item${cart.cartItems.length > 1 ? 's' : ''}  added",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(kMyBag);
                                },
                                child: Icon(Icons.arrow_forward,
                                    color: Colors.white))
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            child: Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      category = "MEN";
                                    });
                                  },
                                  child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      child: Image.asset(
                                          "assets/images/Combined shape 772.png",
                                          width: 30,
                                          color: category == "MEN"
                                              ? Colors.blue
                                              : Colors.grey,
                                          height: 30)),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Men",
                                  style: TextStyle(
                                      color: category == "MEN"
                                          ? Colors.blue
                                          : Colors.black),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      category = "WOMEN";
                                    });
                                  },
                                  child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      child: Image.asset(
                                          "assets/images/Combined shape 773.png",
                                          width: 30,
                                          color: category == "WOMEN"
                                              ? Colors.blue
                                              : Colors.grey,
                                          height: 30)),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Women",
                                  style: TextStyle(
                                      color: category == "WOMEN"
                                          ? Colors.blue
                                          : Colors.black),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      category = "HOUSEHOLD";
                                    });
                                  },
                                  child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      child: Image.asset(
                                          "assets/images/Object (9).png",
                                          width: 30,
                                          color: category == "HOUSEHOLD"
                                              ? Colors.blue
                                              : Colors.grey,
                                          height: 30)),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Household",
                                  style: TextStyle(
                                      color: category == "HOUSEHOLD"
                                          ? Colors.blue
                                          : Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: serviceProvider.fetchServiceProviders(
                            category, type),
                        builder: (ctx, snapShot) {
                          if (snapShot.connectionState !=
                              ConnectionState.done) {
                            return Container(
                              height: 260,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else if (snapShot.hasError) {
                            if (snapShot.error.toString() == "401") {
                              authProvider.logout();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  kLoginScreen, (route) => false);
                            }

                            return Center(
                              child: Image.asset(
                                  "assets/images/empty_state_card.png"),
                            );
                          } else if (snapShot.hasData) {
                            return Container(
                              height: 260,
                              child: snapShot.data.length == 0
                                  ? Center(
                                      child: Image.asset(
                                          "assets/images/empty_state_card.png"),
                                    )
                                  : ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: snapShot.data.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return CartItem(
                                          service: snapShot.data[index],
                                        );
                                      },
                                    ),
                            );
                          } else {
                            return Container(
                              height: 260,
                              child: Center(
                                child: Image.asset(
                                    "assets/images/empty_state_card.png"),
                              ),
                            );
                          }
                        },
                      ),
                      // SingleChildScrollView(
                      //   child: Column(
                      //     children: [
                      //       CartItem(),
                      //       CartItem(),
                      //       CartItem(),
                      //       CartItem(),
                      //       CartItem(),
                      //       CartItem(),
                      //       CartItem()
                      //     ],
                      //   ),
                      // ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final ServiceModel service;
  CartItem({this.service});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return ListTile(
      leading: Image.network("${service.image}", width: 40, height: 40),
      title: Text("${service.name}"),
      subtitle: Text(
        "N${service.price.toStringAsFixed(2)}",
        style: TextStyle(
          color: Color(0xff0285E0),
        ),
      ),
      trailing: Container(
          width: 70,
          child: QuantityController(
            initialValue: cartProvider.checkProductInCart(service.id)
                ? cartProvider.cartItems[service.id].productQuantity
                : 0,
            onIncrement: (num) {
              if (cartProvider.checkProductInCart(service.id)) {
                cartProvider.updateProductInCART(
                    newProductQuantity: num,
                    product: CartModel(
                      category: service.category,
                      image: service.image,
                      productId: service.id,
                      productName: service.name,
                      productPrice: service.price,
                      state: service.state,
                    ));
              } else {
                cartProvider.addToCART(
                    category: service.category,
                    image: service.image,
                    productId: service.id,
                    productName: service.name,
                    productPrice: service.price,
                    state: service.state,
                    productQuantity: num,
                    productTotalPrice: num * service.price);
              }
            },
            onDecrement: (num) {
              if (num == 0) {
                cartProvider.removeFromCART(productId: service.id);
              } else {
                cartProvider.updateProductInCART(
                    newProductQuantity: num,
                    product: CartModel(
                      category: service.category,
                      image: service.image,
                      productId: service.id,
                      productName: service.name,
                      productPrice: service.price,
                      state: service.state,
                    ));
              }
            },
          )),
    );
  }
}
