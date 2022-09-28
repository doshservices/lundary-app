import 'package:flutter/material.dart';
import 'package:laundry_app/constants.dart';
import 'package:laundry_app/models/order.dart';
import 'package:laundry_app/providers/auth.dart';
import 'package:laundry_app/providers/service_provider.dart';
import 'package:provider/provider.dart';

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
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
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                    color: Color(0xffEFF8FE),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: FutureBuilder(
                  future: Provider.of<ServiceProvider>(context, listen: false)
                      .fetchSpecialOrders(),
                  builder: (ctx, snapShot) {
                    if (snapShot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapShot.hasError) {
                      if (snapShot.error.toString() == "401") {
                        authProvider.logout();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            kLoginScreen, (route) => false);
                      }

                      return Center(
                        child:
                            Image.asset("assets/images/empty_state_card.png"),
                      );
                    } else if (snapShot.hasData) {
                      return snapShot.data.length <= 0
                          ? Center(
                              child: Image.asset(
                                  "assets/images/empty_state_card.png"),
                            )
                          : ListView.builder(
                              itemBuilder: (ctx, index) {
                                return RequestItem(
                                  order: snapShot.data[index],
                                );
                              },
                              itemCount: snapShot.data.length,
                            );
                    } else {
                      return Center(
                        child:
                            Image.asset("assets/images/empty_state_card.png"),
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RequestItem extends StatelessWidget {
  final OrderModel order;
  RequestItem({this.order});

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
                  "Order No - ${order.orderNumber}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
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
            SizedBox(
              height: 5,
            ),
            Divider(),
            SizedBox(
              height: 5,
            ),
            Text(
              "Pickup Date",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text("${order.pickupDate}  "),
            SizedBox(
              height: 5,
            ),
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
