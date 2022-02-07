import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:laundry_app/constants.dart';
import 'package:laundry_app/models/order.dart';
import 'package:laundry_app/providers/auth.dart';
import 'package:laundry_app/providers/service_provider.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Request",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
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
                  horizontal: 0,
                ),
                decoration: BoxDecoration(
                    color: Color(0xffEFF8FE),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: DefaultTabController(
                  length: 2,
                  initialIndex: selectedIndex,
                  child: Column(
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(maxHeight: 150.0),
                        child: Material(
                          color: Colors.white,
                          child: TabBar(
                            unselectedLabelColor: Colors.black,
                            labelColor: Theme.of(context).primaryColor,
                            indicatorColor: Theme.of(context).primaryColor,
                            labelStyle: TextStyle(
                                color: Theme.of(context).primaryColor),
                            tabs: [
                              Tab(
                                text: "Processing",
                                key: Key("new"),
                              ),
                              Tab(
                                text: "Completed",
                                key: Key("ongoing"),
                              ),
                            ],
                            onTap: (index) async {
                              await Future.delayed(Duration(milliseconds: 500));
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            selectedIndex != 0
                                ? Text("")
                                : FutureBuilder(
                                    future: Provider.of<ServiceProvider>(
                                            context,
                                            listen: false)
                                        .fetchProcessingOrders(),
                                    builder: (ctx, snapShot) {
                                      if (snapShot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (snapShot.hasError) {
                                        if (snapShot.error.toString() ==
                                            "401") {
                                          authProvider.logout();
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  kLoginScreen,
                                                  (route) => false);
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
                                                  return OrderItem(
                                                    order: snapShot.data[index],
                                                  );
                                                },
                                                itemCount: snapShot.data.length,
                                              );
                                      } else {
                                        return Center(
                                          child: Image.asset(
                                              "assets/images/empty_state_card.png"),
                                        );
                                      }
                                    },
                                  ),
                            selectedIndex != 1
                                ? Text("")
                                : FutureBuilder(
                                    future: Provider.of<ServiceProvider>(
                                            context,
                                            listen: false)
                                        .fetchConfirmedOrders(),
                                    builder: (ctx, snapShot) {
                                      if (snapShot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (snapShot.hasError) {
                                        if (snapShot.error.toString() ==
                                            "401") {
                                          authProvider.logout();
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  kLoginScreen,
                                                  (route) => false);
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
                                                  return OrderItem(
                                                    order: snapShot.data[index],
                                                  );
                                                },
                                                itemCount: snapShot.data.length,
                                              );
                                      } else {
                                        return Center(
                                          child: Image.asset(
                                              "assets/images/empty_state_card.png"),
                                        );
                                      }
                                    },
                                  ),
                          ],
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

class OrderItem extends StatelessWidget {
  OrderModel order;
  OrderItem({this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(kOrderDetailScreen, arguments: {"order": order});
      },
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Nathan's Laundry Service",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  "N${order.totalPrice}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order No - ${order.orderNumber}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                order.orderStatus == "COMFIRMED"
                    ? Column(
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
                        ? Column(
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
                            ? Column(
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
                                ? Column(
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
                                    ? Column(
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
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            // Row(
            //   children: [
            //     Column(
            //       children: [
            //         Image.asset(
            //           "assets/images/Object (1).png",
            //           width: 20,
            //           height: 20,
            //         ),
            //         Text(
            //           "Confirmed",
            //           style: TextStyle(
            //             fontSize: 12,
            //           ),
            //         )
            //       ],
            //     ),
            //     Expanded(child: Divider()),
            //     Column(
            //       children: [
            //         Image.asset(
            //           "assets/images/Object (2).png",
            //           width: 20,
            //           height: 20,
            //         ),
            //         Text(
            //           "Picked up",
            //           style: TextStyle(
            //             color: Colors.grey,
            //             fontSize: 12,
            //           ),
            //         )
            //       ],
            //     ),
            //     Expanded(child: Divider()),
            //     Column(
            //       children: [
            //         Image.asset(
            //           "assets/images/Object (3).png",
            //           width: 20,
            //           height: 20,
            //         ),
            //         Text(
            //           "In process",
            //           style: TextStyle(
            //             color: Colors.grey,
            //             fontSize: 12,
            //           ),
            //         )
            //       ],
            //     ),
            //     Expanded(child: Divider()),
            //     Column(
            //       children: [
            //         Image.asset(
            //           "assets/images/Object (4).png",
            //           width: 20,
            //           height: 20,
            //         ),
            //         Text(
            //           "Shipped",
            //           style: TextStyle(
            //             color: Colors.grey,
            //             fontSize: 12,
            //           ),
            //         )
            //       ],
            //     ),
            //     Expanded(child: Divider()),
            //     Column(
            //       children: [
            //         Image.asset(
            //           "assets/images/Object (5).png",
            //           width: 20,
            //           height: 20,
            //         ),
            //         Text(
            //           "Delivered",
            //           style: TextStyle(
            //             color: Colors.grey,
            //             fontSize: 12,
            //           ),
            //         )
            //       ],
            //     )
            //   ],
            // ),
            Text(
              "Pickup Date",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text("${order.pickupDate}")
          ],
        ),
      )),
    );
  }
}

class RequestItem extends StatelessWidget {
  const RequestItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order No - 110040717",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text("09, Nov")
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Divider(),
            SizedBox(
              height: 5,
            ),
            Text(
              "Pickup Date & Time",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text("Monday, 10 Nov 2017 at 10:00 AM to 12:00 PM")
          ],
        ),
      ),
    );
  }
}

class ActiveOrderItem extends StatelessWidget {
  const ActiveOrderItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Order No:12234324",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Order Confirmed",
              ),
              SizedBox(height: 10),
              Text(
                "N256",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  children: [
                    Slider(
                      value: 0.8,
                      onChanged: (value) {},
                      activeColor: Colors.purple,
                      inactiveColor: Colors.grey,
                    ),
                    Text("80%")
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
