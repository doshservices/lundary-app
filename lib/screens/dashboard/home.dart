import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:laundry_app/constants.dart';
import 'package:laundry_app/models/order.dart';
import 'package:laundry_app/providers/auth.dart';
import 'package:laundry_app/providers/service_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInit = true;
  String currentLocation = "";
  List<DropdownMenuItem> locationItems = [
    DropdownMenuItem(
      child: Text(
        "Switch Location",
      ),
      value: "",
    ),
    DropdownMenuItem(
      child: Text(
        "LAGOS",
      ),
      value: "LAGOS",
    ),
    DropdownMenuItem(
      child: Text(
        "ABUJA",
      ),
      value: "ABUJA",
    ),
  ];

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      await Provider.of<ServiceProvider>(context, listen: false).getState();
      setState(() {
        _isInit = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    final serviceProvider = Provider.of<ServiceProvider>(context);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).primaryColor,
        child: _isInit
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hello ${authProvider.user.firstName},",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(kMyBag);
                              },
                              child: Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(kNotificationScreen);
                              },
                              child: Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(bottom: 10),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 50,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: locationItems,
                            onChanged: (value) {
                              setState(() {
                                currentLocation = value;
                                Provider.of<ServiceProvider>(context,
                                        listen: false)
                                    .setState(currentLocation);
                              });
                            },
                            value: currentLocation,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${serviceProvider.state}",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                                child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Flat 50% off on \nFirst Order",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Get Started",
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                  Image.asset("assets/images/pngfind 1.png",
                                      width: 100, height: 100),
                                ],
                              ),
                            )),
                            SizedBox(height: 20),
                            Text(
                              "Services",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          kDryCleaning,
                                          arguments: {"type": "DRY-CLEANING"});
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/Group 1000001317.png",
                                          width: 60,
                                          height: 60,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("Dry Clean")
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          kDryCleaning,
                                          arguments: {"type": "LAUNDRY"});
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/laundry.png",
                                          width: 60,
                                          height: 60,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("Laundry")
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed(kSpecialOrderScreen);
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/Group 1000001318.png",
                                          width: 60,
                                          height: 60,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("Special Orders")
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Your Active Orders",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                // Text(
                                //   "View all",
                                //   style: TextStyle(
                                //     fontSize: 16,
                                //   ),
                                // ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 120,
                              child: FutureBuilder(
                                future: Provider.of<ServiceProvider>(context,
                                        listen: false)
                                    .fetchActiveOrders(),
                                builder: (ctx, snapShot) {
                                  if (snapShot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapShot.hasError) {
                                    if (snapShot.error.toString() == "401") {
                                      authProvider.logout();
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              kLoginScreen, (route) => false);
                                    }

                                    return Center(
                                      child: Image.asset(
                                          "assets/images/empty_state_card.png"),
                                    );
                                  } else if (snapShot.hasData) {
                                    return snapShot.data.length <= 0
                                        ? Center(
                                            child: Image.asset(
                                                "assets/images/empty_state_card.png"),
                                          )
                                        : ListView.builder(
                                            itemBuilder: (ctx, index) {
                                              return ActiveOrderItem(
                                                order: snapShot.data[index],
                                              );
                                            },
                                            itemCount: snapShot.data.length,
                                            scrollDirection: Axis.horizontal,
                                          );
                                  } else {
                                    return Center(
                                      child: Image.asset(
                                          "assets/images/empty_state_card.png"),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

class ActiveOrderItem extends StatelessWidget {
  OrderModel order;
  ActiveOrderItem({this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(kOrderDetailScreen, arguments: {"order": order});
      },
      child: Container(
        width: 260,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order No: ${order.orderNumber}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                order.orderStatus == "COMFIRMED"
                    ? Row(
                        children: [
                          Image.asset(
                            "assets/images/Object (1).png",
                            width: 20,
                            height: 20,
                          ),
                          Text(
                            "Confirmed",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          )
                        ],
                      )
                    : order.orderStatus == "PICKED_UP"
                        ? Row(
                            children: [
                              Image.asset(
                                "assets/images/Object (2).png",
                                width: 20,
                                height: 20,
                              ),
                              Text(
                                "Picked up",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          )
                        : order.orderStatus == "IN_PROCESS"
                            ? Row(
                                children: [
                                  Image.asset(
                                    "assets/images/Object (3).png",
                                    width: 20,
                                    height: 20,
                                  ),
                                  Text(
                                    "In process",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              )
                            : order.orderStatus == "SHIPPED"
                                ? Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/Object (4).png",
                                        width: 20,
                                        height: 20,
                                      ),
                                      Text(
                                        "Shipped",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      )
                                    ],
                                  )
                                : order.orderStatus == "DELIVERED"
                                    ? Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/Object (5).png",
                                            width: 20,
                                            height: 20,
                                          ),
                                          Text(
                                            "Delivered",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          )
                                        ],
                                      )
                                    : SizedBox(
                                        width: 0,
                                        height: 0,
                                      ),
                SizedBox(height: 7),
                Text(
                  "N${order.totalPrice}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                // SizedBox(height: 2),
                // Padding(
                //   padding: const EdgeInsets.all(0.0),
                //   child: Row(
                //     children: [
                //       Slider(
                //         value: 0.8,
                //         onChanged: (value) {},
                //         activeColor: Colors.purple,
                //         inactiveColor: Colors.grey,
                //       ),
                //       Text("80%")
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
