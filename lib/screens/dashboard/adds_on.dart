import 'package:flutter/material.dart';
import 'package:laundry_app/constants.dart';
import 'package:laundry_app/models/take_order.dart';
import 'package:laundry_app/providers/cart.dart';
import 'package:laundry_app/screens/dashboard/quantity_controller.dart';
import 'package:laundry_app/utils/custom_textformfield.dart';
import 'package:laundry_app/utils/rounded_raisedbutton.dart';
import 'package:expandable/expandable.dart';
import 'package:provider/provider.dart';

class AddsOnScreen extends StatefulWidget {
  @override
  _AddsOnScreenState createState() => _AddsOnScreenState();
}

class _AddsOnScreenState extends State<AddsOnScreen> {
  bool ironingAndFolding = false;
  bool extraStarch = false;
  bool express = false;
  TakeOrderModel order = TakeOrderModel();
  String selectedStarch = "none";

  List<DropdownMenuItem> starchItems = [
    DropdownMenuItem(
      child: Text(
        "Choose Starch",
      ),
      value: "none",
    ),
    DropdownMenuItem(
      child: Text(
        "Light starch",
      ),
      value: "light",
    ),
    DropdownMenuItem(
      child: Text(
        "Heavy starch",
      ),
      value: "heavy",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text(
          "Adds-on",
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                            "Kindly select extra features you would like to have us do for you",
                            textAlign: TextAlign.center),
                        SizedBox(height: 50),
                        Row(
                          children: [
                            Image.asset("assets/images/Vector (4).png",
                                width: 20, height: 20),
                            Expanded(
                              child: CheckboxListTile(
                                // leading: Image.asset("assets/images/Vector (4).png",
                                //     width: 20, height: 20),
                                onChanged: (value) {
                                  setState(() {
                                    ironingAndFolding = value;
                                  });
                                },
                                activeColor: Theme.of(context).primaryColor,
                                value: ironingAndFolding,
                                title: Text("Folding"),
                                subtitle: Text(
                                  "N500",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     Image.asset("assets/images/Vector (6).png",
                        //         width: 20, height: 20),
                        //     Expanded(
                        //       child: CheckboxListTile(
                        //         // leading: Image.asset("assets/images/Vector (4).png",
                        //         //     width: 20, height: 20),
                        //         onChanged: (value) {
                        //           setState(() {
                        //             extraStarch = value;
                        //           });
                        //         },
                        //         activeColor: Theme.of(context).primaryColor,
                        //         value: extraStarch,
                        //         title: Text("Extra starch"),
                        //         subtitle: Text(
                        //           "N500",
                        //           style: TextStyle(
                        //               color: Theme.of(context).primaryColor),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        Row(
                          children: [
                            Image.asset("assets/images/Vector (7).png",
                                width: 20, height: 20),
                            Expanded(
                              child: CheckboxListTile(
                                // leading: Image.asset("assets/images/Vector (4).png",
                                //     width: 20, height: 20),
                                onChanged: (value) {
                                  setState(() {
                                    express = value;
                                  });
                                },
                                activeColor: Theme.of(context).primaryColor,
                                value: express,
                                title: Text("Express"),
                                subtitle: Text(
                                  "",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(bottom: 10),
                          margin: EdgeInsets.symmetric(horizontal: 0),
                          height: 80,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 5),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  items: starchItems,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedStarch = value;
                                      // Provider.of<ServiceProvider>(context,
                                      //         listen: false)
                                      //     .setState(currentLocation);
                                    });
                                  },
                                  value: selectedStarch,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Card(
                            child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                      "assets/images/Combined shape 1070.png",
                                      width: 20,
                                      height: 20),
                                  SizedBox(width: 10),
                                  Text(
                                    "Add Special Instructions",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              CustomTextFormField(
                                hintText: "Enter here",
                                labelText: "",
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          "${cartProvider.cartItems.length} item${cartProvider.cartItems.length > 1 ? 's' : ''} added",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    GestureDetector(
                        onTap: () {
                          order.express = express;
                          order.isIroning = ironingAndFolding;
                          order.extraStarch = extraStarch;
                          order.selectedStarch = selectedStarch;
                          Navigator.of(context).pushNamed(kSchedulePickup,
                              arguments: {"order": order});
                        },
                        child: Icon(Icons.arrow_forward, color: Colors.white))
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

class CartItem extends StatelessWidget {
  const CartItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          Image.asset("assets/images/Image (1).png", width: 40, height: 40),
      title: Text("T-Shirt"),
      subtitle: Text(
        "N500",
        style: TextStyle(
          color: Color(0xff0285E0),
        ),
      ),
      trailing: Container(
          width: 70,
          child: QuantityController(
            initialValue: 0,
            onIncrement: (num) {},
            onDecrement: (num) {},
          )),
    );
  }
}
