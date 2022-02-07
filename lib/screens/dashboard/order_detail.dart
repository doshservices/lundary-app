import 'package:flutter/material.dart';
import 'package:laundry_app/constants.dart';
import 'package:laundry_app/models/order.dart';
import 'package:laundry_app/utils/custom_textformfield.dart';
import 'package:laundry_app/utils/rounded_raisedbutton.dart';
import 'package:expandable/expandable.dart';

class OrderDetailScreen extends StatefulWidget {
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderModel order;

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    order = arguments["order"];
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text(
          "Order Details",
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
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 8,
                  shadowColor: Colors.grey.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order No - ${order.orderNumber}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Pickup Date",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("${order.pickupDate} "),
                          SizedBox(
                            height: 5,
                          ),

                          Divider(),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Items",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(),
                          SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) {
                                return order.items[index].productQuantity ==
                                        null
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${order.items[index].productName}",
                                              softWrap: true,
                                              textAlign: TextAlign.justify,
                                            ),
                                            Text(
                                              "N${order.items[index].productTotalPrice}",
                                              softWrap: true,
                                              textAlign: TextAlign.justify,
                                            ),
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${order.items[index].productQuantity} x ${order.items[index].productName}",
                                              softWrap: true,
                                              textAlign: TextAlign.justify,
                                            ),
                                            Text(
                                              "N${order.items[index].productTotalPrice}",
                                              softWrap: true,
                                              textAlign: TextAlign.justify,
                                            ),
                                          ],
                                        ),
                                      );
                              },
                              itemCount: order.items.length),
                          // OrderItem(
                          //   title: "Washup and Fold",
                          // ),
                          // OrderItem(
                          //   title: "Washup and Iron",
                          // ),

                          SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "N${order.totalPrice != null ? order.totalPrice.toStringAsFixed(2) : 0.00}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 8,
                  shadowColor: Colors.grey.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        order.orderStatus == "COMFIRMED"
                            ? Row(
                                children: [
                                  Image.asset(
                                    "assets/images/Object (1).png",
                                    width: 20,
                                    height: 20,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Order Status",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Confirmed",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  ),
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
                                      Column(
                                        children: [
                                          Text(
                                            "Order Status",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Picked up",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                          )
                                        ],
                                      ),
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
                                          Column(
                                            children: [
                                              Text(
                                                "Order Status",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "In process",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              )
                                            ],
                                          ),
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
                                              Column(
                                                children: [
                                                  Text(
                                                    "Order Status",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "Shipped",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                    ),
                                                  )
                                                ],
                                              ),
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
                                                  Column(
                                                    children: [
                                                      Text(
                                                        "Order Status",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        "Delivered",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              )
                                            : SizedBox(
                                                width: 0,
                                                height: 0,
                                              ),
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 8,
                  shadowColor: Colors.grey.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Laundry Shop",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        ListTile(
                          leading: Image.asset("assets/images/Object (7).png",
                              width: 40, height: 40),
                          contentPadding: EdgeInsets.all(0),
                          minLeadingWidth: 30,
                          title: Text("Nathan’s Drycleaner"),
                          trailing: Image.asset(
                              "assets/images/Combined shape 414.png",
                              width: 20,
                              height: 20),
                          subtitle: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 16,
                              ),
                              Text("5.0")
                            ],
                          ),
                        ),
                        // SizedBox(height: 5),
                        // Text(
                        //   "1810 Camino Real, Redwood City, CA  94063,United States",
                        // ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  OrderItem({
    this.title,
  });
  String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpandablePanel(
          header: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              "$title",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          expanded: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "1 x T-shirt (men)",
                    softWrap: true,
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    "N10.00",
                    softWrap: true,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "2 x Trouser (men)",
                    softWrap: true,
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    "N10.00",
                    softWrap: true,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ],
          ),
          tapHeaderToExpand: true,
        ),
        Divider(),
      ],
    );
  }
}
