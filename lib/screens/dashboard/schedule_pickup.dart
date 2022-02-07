import 'dart:convert';
import 'dart:io';
import 'dart:math' as Math;

import 'package:date_time_picker/date_time_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:laundry_app/constants.dart';
import 'package:laundry_app/models/address_model.dart';
import 'package:laundry_app/models/cart.dart';
import 'package:laundry_app/models/take_order.dart';
import 'package:laundry_app/providers/auth.dart';
import 'package:laundry_app/providers/cart.dart';
import 'package:laundry_app/providers/service_provider.dart';
import 'package:laundry_app/utils/custom_textformfield.dart';
import 'package:laundry_app/utils/rounded_raisedbutton.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class SchedulePickUp extends StatefulWidget {
  @override
  _SchedulePickUpState createState() => _SchedulePickUpState();
}

class _SchedulePickUpState extends State<SchedulePickUp> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  PageController _uploadPageController = PageController(initialPage: 0);

  GlobalKey<FormState> _page1FormKey = GlobalKey();
  GlobalKey<FormState> _page2FormKey = GlobalKey();
  GlobalKey<FormState> _page3FormKey = GlobalKey();
  GlobalKey<FormState> _page4FormKey = GlobalKey();
  GlobalKey<FormState> _addressFormKey = GlobalKey();
  String _selectedFeatureType = "";
  String _selectedMaritalStatus = "";
  String _selectedPropertyCondition = "";
  List<Widget> pages;
  int pageIndex = 0;
  bool _isLoading = false;
  File _signatureImage, _idImage;
  String _signatureImageExtension, _idImageExtension;
  var base64SignatureImage, base64IdImage;
  List<AddressModel> addresses = [];
  AddressModel address = AddressModel();
  String addressLocation = "HOME";
  bool _isSavingAddress = false;
  bool _isSubmitingOrder = false;
  String paymentMethod = "PAYSTACK";
  TakeOrderModel order;
  double totalAmount = 0;

  TextEditingController unitController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  var _isInit = true;

  String currentLocation = "";
  List<DropdownMenuItem> locationItems = [
    DropdownMenuItem(
      child: Text(
        "Select State",
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
    if (_isInit) {
      try {
        final authProvider = Provider.of<Auth>(context, listen: false);
        addresses = await authProvider.fetchAddresses();
        currentLocation =
            Provider.of<ServiceProvider>(context, listen: false).state;
      } catch (error) {} finally {
        setState(() {
          _isInit = false;
        });
      }
    }
    super.didChangeDependencies();
  }

  Future<void> validatePage(int index) async {
    if (index == 0) {
      if (selectedAddressId.isEmpty) {
        Get.snackbar('Error!', 'Select delivery address to continue',
            barBlur: 0,
            dismissDirection: SnackDismissDirection.VERTICAL,
            backgroundColor: Colors.red,
            overlayBlur: 0,
            animationDuration: Duration(milliseconds: 500),
            duration: Duration(seconds: 2));
        throw "error";
      }
    }
    if (index == 1) {
      if (pickupDate.isEmpty) {
        Get.snackbar('Error!', 'Select pickup date to continue',
            barBlur: 0,
            dismissDirection: SnackDismissDirection.VERTICAL,
            backgroundColor: Colors.red,
            overlayBlur: 0,
            animationDuration: Duration(milliseconds: 500),
            duration: Duration(seconds: 2));
        throw "error";
      }
      // if (pickupTime.isEmpty) {
      //   Get.snackbar('Error!', 'Select pickup time to continue',
      //       barBlur: 0,
      //       dismissDirection: SnackDismissDirection.VERTICAL,
      //       backgroundColor: Colors.red,
      //       overlayBlur: 0,
      //       animationDuration: Duration(milliseconds: 500),
      //       duration: Duration(seconds: 2));
      //   throw "error";
      // }
      // if (deliveryDate.isEmpty) {
      //   Get.snackbar('Error!', 'Select delivery date to continue',
      //       barBlur: 0,
      //       dismissDirection: SnackDismissDirection.VERTICAL,
      //       backgroundColor: Colors.red,
      //       overlayBlur: 0,
      //       animationDuration: Duration(milliseconds: 500),
      //       duration: Duration(seconds: 2));
      //   throw "error";
      // }
      // if (deliveryTime.isEmpty) {
      //   Get.snackbar('Error!', 'Select delivery time to continue',
      //       barBlur: 0,
      //       dismissDirection: SnackDismissDirection.VERTICAL,
      //       backgroundColor: Colors.red,
      //       overlayBlur: 0,
      //       animationDuration: Duration(milliseconds: 500),
      //       duration: Duration(seconds: 2));
      //   throw "error";
      // }
    }
    if (index == 2) {
      _page3FormKey.currentState.save();
      setState(() {
        _isSubmitingOrder = true;
      });
      try {
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        List<CartModel> cartItems = [];
        totalAmount = cartProvider.cartTotalAmount +
            (order.extraStarch ? 500 : 0) +
            (order.isIroning ? 500 : 0) +
            (order.express ? cartProvider.cartTotalAmount : 0);
        cartProvider.cartItems.forEach((key, value) {
          cartItems.add(value);
        });
        Map<String, dynamic> result =
            await Provider.of<ServiceProvider>(context, listen: false)
                .createOrder(
                    addressId: selectedAddressId,
                    // deliveryDate: deliveryDate,
                    // deliveryTime: deliveryTime,
                    pickupDate: pickupDate,
                    // pickupTime: pickupTime,
                    paymentType: paymentMethod,
                    price: totalAmount,
                    carts: cartItems,
                    order: order,
                    userId: Provider.of<Auth>(context, listen: false).user.id);
        cartProvider.clearCART();
        if (paymentMethod == "PAYSTACK") {
          Navigator.of(context).pushReplacementNamed(kMakePayment,
              arguments: {"confirmationUrl": result["confirmationUrl"]});
        }
      } catch (error) {
        Get.snackbar('Error!', '${error.toString()}',
            barBlur: 0,
            dismissDirection: SnackDismissDirection.VERTICAL,
            backgroundColor: Colors.red,
            overlayBlur: 0,
            animationDuration: Duration(milliseconds: 500),
            duration: Duration(seconds: 2));
        throw "error";
      } finally {
        setState(() {
          _isSubmitingOrder = false;
        });
      }
    }
  }

  String selectedAddressId = "";
  String pickupDate = "", pickupTime = "", deliveryDate = "", deliveryTime = "";

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    order = arguments["order"];

    //  print(countrydata);

    List<DropdownMenuItem> timeItems = [
      DropdownMenuItem(
        child: Text(
          "Select Time",
        ),
        value: "",
      ),
      DropdownMenuItem(
        child: Text(
          "12:00 A.M - 02:00 A.M",
        ),
        value: "12:00 A.M - 02:00 A.M",
      ),
      DropdownMenuItem(
        child: Text(
          "02:00 A.M - 04:00 A.M",
        ),
        value: "02:00 A.M - 04:00 A.M",
      ),
      DropdownMenuItem(
        child: Text(
          "04:00 A.M - 06:00 A.M",
        ),
        value: "04:00 A.M - 06:00 A.M",
      ),
      DropdownMenuItem(
        child: Text(
          "06:00 A.M - 08:00 A.M",
        ),
        value: "06:00 A.M - 08:00 A.M",
      ),
      DropdownMenuItem(
        child: Text(
          "08:00 A.M - 10:00 A.M",
        ),
        value: "08:00 A.M - 10:00 A.M",
      ),
      DropdownMenuItem(
        child: Text(
          "10:00 A.M - 12:00 P.M",
        ),
        value: "10:00 A.M - 12:00 P.M",
      ),
      DropdownMenuItem(
        child: Text(
          "12:00 P.M - 02:00 P.M",
        ),
        value: "12:00 P.M - 02:00 P.M",
      ),
      DropdownMenuItem(
        child: Text(
          "02:00 P.M - 04:00 P.M",
        ),
        value: "02:00 P.M - 04:00 P.M",
      ),
      DropdownMenuItem(
        child: Text(
          "04:00 P.M - 06:00 P.M",
        ),
        value: "04:00 P.M - 06:00 P.M",
      ),
      DropdownMenuItem(
        child: Text(
          "06:00 P.M - 08:00 P.M",
        ),
        value: "06:00 P.M - 08:00 P.M",
      ),
      DropdownMenuItem(
        child: Text(
          "08:00 P.M - 10:00 P.M",
        ),
        value: "08:00 P.M - 10:00 P.M",
      ),
      DropdownMenuItem(
        child: Text(
          "10:00 P.M - 12:00 A.M",
        ),
        value: "10:00 P.M - 12:00 A.M",
      ),
    ];

    Widget page1 = _isInit
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Where should we deliver?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    addresses.length > 0
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: addresses.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 8,
                                  shadowColor: Colors.grey.withOpacity(0.2),
                                  child: RadioListTile(
                                    value: addresses[index].id,
                                    groupValue: selectedAddressId,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedAddressId = value;
                                      });
                                    },
                                    title:
                                        Text("${addresses[index].deliverTo}"),
                                    subtitle: Text(
                                        "${addresses[index].address}, ${addresses[index].state}."),
                                  ));
                            },
                          )
                        : Center(
                            child: Column(
                              children: [
                                Image.asset(
                                    "assets/images/empty_state_card.png"),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("No Address added yet")
                              ],
                            ),
                          ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            clipBehavior: Clip.hardEdge,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            builder: (ctx) {
                              return StatefulBuilder(
                                builder: (ctx, setState) {
                                  return SingleChildScrollView(
                                    child: Container(
                                      height: 600,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 50,
                                            color: Color(0xffF7F7F7),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Text(
                                                "Add Address",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 20, bottom: 10, top: 10),
                                            child: Text(
                                              "State",
                                              // style: TextStyle(
                                              //     fontWeight: FontWeight.bold,
                                              //     fontSize: 18),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Form(
                                              key: _addressFormKey,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    padding: EdgeInsets.only(
                                                        bottom: 10),
                                                    height: 70,
                                                    child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    15.0,
                                                                vertical: 5),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child: DropdownButton(
                                                            items:
                                                                locationItems,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                currentLocation =
                                                                    value;
                                                                address.state =
                                                                    value;
                                                                // Provider.of<ServiceProvider>(
                                                                //         context,
                                                                //         listen:
                                                                //             false)
                                                                //     .setState(
                                                                //         currentLocation);
                                                              });
                                                            },
                                                            value:
                                                                currentLocation,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  CustomTextFormField(
                                                    hintText: "Enter Address",
                                                    labelText: "",
                                                    validator: (value) {
                                                      if (value.isEmpty) {
                                                        return "Address required";
                                                      }
                                                    },
                                                    onSaved: (value) {
                                                      address.address = value;
                                                    },
                                                  ),
                                                  CustomTextFormField(
                                                    hintText:
                                                        "Contact Phone number",
                                                    keyboardType:
                                                        TextInputType.number,
                                                    labelText: "",
                                                    validator: (value) {
                                                      if (value.isEmpty) {
                                                        return "Contact required";
                                                      }
                                                    },
                                                    onSaved: (value) {
                                                      address.contact = value;
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: RadioListTile(
                                                            value: "HOME",
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            groupValue:
                                                                addressLocation,
                                                            title: Text(
                                                              "HOME",
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                addressLocation =
                                                                    value;
                                                              });
                                                            }),
                                                      ),
                                                      Expanded(
                                                        child: RadioListTile(
                                                            value: "WORK",
                                                            title: Text(
                                                              "WORK",
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            groupValue:
                                                                addressLocation,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                addressLocation =
                                                                    value;
                                                              });
                                                            }),
                                                      ),
                                                      Expanded(
                                                        child: RadioListTile(
                                                            value: "OTHER",
                                                            title: Text(
                                                              "OTHER",
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            groupValue:
                                                                addressLocation,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                addressLocation =
                                                                    value;
                                                              });
                                                            }),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: RoundedRaisedButton(
                                                      title:
                                                          "SAVE AND CONTINUE",
                                                      isLoading:
                                                          _isSavingAddress,
                                                      onPress: () async {
                                                        try {
                                                          if (!_addressFormKey
                                                              .currentState
                                                              .validate()) {
                                                            return;
                                                          }
                                                          _addressFormKey
                                                              .currentState
                                                              .save();
                                                          address.deliverTo =
                                                              addressLocation;
                                                          setState(() {
                                                            _isSavingAddress =
                                                                true;
                                                          });
                                                          await Provider.of<
                                                                      Auth>(
                                                                  context,
                                                                  listen: false)
                                                              .createAddress(
                                                                  address);
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.of(context)
                                                              .pushReplacementNamed(
                                                                  kSchedulePickup,
                                                                  arguments: {
                                                                ...arguments
                                                              });
                                                          Get.snackbar(
                                                              'Success!',
                                                              'Address updated successfully',
                                                              barBlur: 0,
                                                              dismissDirection:
                                                                  SnackDismissDirection
                                                                      .VERTICAL,
                                                              backgroundColor:
                                                                  Colors.green,
                                                              overlayBlur: 0,
                                                              animationDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                          500),
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          2));
                                                        } catch (error) {
                                                          Get.snackbar('Error!',
                                                              '${error.toString()}',
                                                              barBlur: 0,
                                                              dismissDirection:
                                                                  SnackDismissDirection
                                                                      .VERTICAL,
                                                              backgroundColor:
                                                                  Colors.red,
                                                              overlayBlur: 0,
                                                              animationDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                          500),
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          2));
                                                        } finally {
                                                          setState(() {
                                                            _isSavingAddress =
                                                                false;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            });
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 8,
                        shadowColor: Colors.grey.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.add,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  "Add Address",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          );

    Widget page2 = SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _page2FormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pickup Date & Time",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8,
                shadowColor: Colors.grey.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: DateTimePicker(
                            initialValue: '',
                            type: DateTimePickerType.date,
                            fieldLabelText:
                                "When do you want your Tenancy to commence",
                            fieldHintText:
                                "When do you want your Tenancy to commence",
                            // use24HourFormat: false,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 10, top: 10),
                                border: InputBorder.none,
                                hintText: "Select Date",
                                suffixIcon: Icon(Icons.calendar_today,
                                    color: Theme.of(context).primaryColor)),

                            // icon: ,
                            // decoration: InputDecoration(border: InputBorder.none),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                            dateLabelText: 'Select Date',
                            onChanged: (val) {
                              String date;
                              try {
                                date = DateFormat("dd-MM-yyyy")
                                    .format(DateTime.parse(val));
                              } catch (error) {}

                              setState(() {
                                pickupDate = date;
                              });
                            },
                            validator: (val) {
                              print(val);
                              return null;
                            },
                            onSaved: (val) {
                              String date;
                              try {
                                date = DateFormat("dd-MM-yyyy")
                                    .format(DateTime.parse(val));
                              } catch (error) {}
                              setState(() {
                                pickupDate = date;
                              });
                            },
                          ),
                        ),
                      ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   padding: EdgeInsets.only(bottom: 10),
                      //   height: 70,
                      //   child: Card(
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(15.0),
                      //       child: DropdownButtonHideUnderline(
                      //         child: DropdownButton(
                      //           items: timeItems,
                      //           onChanged: (value) {
                      //             setState(() {
                      //               pickupTime = value;
                      //             });
                      //           },
                      //           value: pickupTime,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 20),
              // Text(
              //   "Delivery Date & Time",
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 18,
              //   ),
              // ),
              // SizedBox(height: 10),
              // Card(
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   elevation: 8,
              //   shadowColor: Colors.grey.withOpacity(0.2),
              //   child: Padding(
              //     padding: const EdgeInsets.all(10.0),
              //     child: Column(
              //       children: [
              //         Card(
              //           child: Padding(
              //             padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //             child: DateTimePicker(
              //               initialValue: '',
              //               type: DateTimePickerType.date,
              //               fieldLabelText:
              //                   "When do you want your Tenancy to commence",
              //               fieldHintText:
              //                   "When do you want your Tenancy to commence",
              //               // use24HourFormat: false,
              //               decoration: InputDecoration(
              //                   contentPadding:
              //                       EdgeInsets.only(left: 10, top: 10),
              //                   hintText: "Select Date",
              //                   border: InputBorder.none,
              //                   suffixIcon: Icon(Icons.calendar_today,
              //                       color: Theme.of(context).primaryColor)),

              //               // icon: ,
              //               // decoration: InputDecoration(border: InputBorder.none),
              //               firstDate: DateTime.now(),
              //               lastDate: DateTime(2100),
              //               dateLabelText: 'Select Date',
              //               onChanged: (val) {
              //                 String date;
              //                 try {
              //                   date = DateFormat("dd-MM-yyyy")
              //                       .format(DateTime.parse(val));
              //                 } catch (error) {}

              //                 setState(() {
              //                   deliveryDate = date;
              //                 });
              //               },
              //               validator: (val) {
              //                 print(val);
              //                 return null;
              //               },
              //               onSaved: (val) {
              //                 String date;
              //                 try {
              //                   date = DateFormat("dd-MM-yyyy")
              //                       .format(DateTime.parse(val));
              //                 } catch (error) {}
              //                 setState(() {
              //                   deliveryDate = date;
              //                 });
              //               },
              //             ),
              //           ),
              //         ),
              //         Container(
              //           width: MediaQuery.of(context).size.width,
              //           padding: EdgeInsets.only(bottom: 10),
              //           height: 70,
              //           child: Card(
              //             child: Padding(
              //               padding: const EdgeInsets.all(15.0),
              //               child: DropdownButtonHideUnderline(
              //                 child: DropdownButton(
              //                   items: timeItems,
              //                   onChanged: (value) {
              //                     setState(() {
              //                       deliveryTime = value;
              //                     });
              //                   },
              //                   value: deliveryTime,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
    final cartProvider = Provider.of<CartProvider>(context);
    Widget page3 = SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _page3FormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/Object (7).png",
                      width: 70, height: 70),
                  SizedBox(width: 10),
                  Text(
                    "Nathans Superior Drycleaners ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Payment Method",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RadioListTile(
                          value: "PAYSTACK",
                          groupValue: paymentMethod,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Card Payment"),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/master.png",
                                    width: 25,
                                    height: 25,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Image.asset(
                                    "assets/images/visa.png",
                                    width: 25,
                                    height: 25,
                                  ),
                                ],
                              )
                            ],
                          ),
                          onChanged: (value) {
                            setState(() {
                              paymentMethod = value;
                            });
                          }),
                      RadioListTile(
                          value: "CASH_ON_DELIVERY",
                          groupValue: paymentMethod,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Cash On Delivery"),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/cash.png",
                                    width: 25,
                                    height: 25,
                                  ),
                                ],
                              )
                            ],
                          ),
                          onChanged: (value) {
                            setState(() {
                              paymentMethod = value;
                            });
                          }),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Price Details",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Items Subtotal"),
                          Text(
                              "N${cartProvider.cartTotalAmount.toStringAsFixed(2)}")
                        ],
                      ),
                      order.isIroning
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text("Folding"), Text("N500")],
                            )
                          : Container(),
                      order.extraStarch
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text("Extra Starch"), Text("N500")],
                            )
                          : Container(),
                      order.express
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Express"),
                                Text("N${cartProvider.cartTotalAmount}")
                              ],
                            )
                          : Container(),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "N${cartProvider.cartTotalAmount + (order.extraStarch ? 500 : 0) + (order.isIroning ? 500 : 0) + (order.express ? cartProvider.cartTotalAmount : 0)}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );

    Widget page4 = SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _page3FormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/Object (8).png",
                width: 100,
                height: 100,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Thank You For Choosing Us!",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Your request has been received."),
              SizedBox(
                height: 50,
              ),
              // Card(
              //   child: Padding(
              //     padding: const EdgeInsets.all(15.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           "Pickup Date & Time",
              //           style: TextStyle(fontWeight: FontWeight.bold),
              //         ),
              //         SizedBox(height: 5),
              //         Text("Monday, 10 Nov 2017 at 10:00 AM to 12:00 PM"),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );

    pages = [page1, page2, page3, page4];
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        leading: Icon(Icons.arrow_back, color: Colors.white),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Schedule Pickup',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Container(
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    TrackerWidget(
                      title: "Location",
                      icon: "assets/images/Vector (2).png",
                      filled: pageIndex >= 0 ? true : false,
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Divider(),
                    )),
                    TrackerWidget(
                      title: "Date",
                      filled: pageIndex >= 1 ? true : false,
                      icon: "assets/images/fa-solid_calendar-alt (1).png",
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Divider(),
                    )),
                    TrackerWidget(
                      title: "Payment",
                      filled: pageIndex >= 2 ? true : false,
                      icon: "assets/images/card.png",
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Divider(),
                    )),
                    TrackerWidget(
                      title: "Complete",
                      filled: pageIndex >= 3 ? true : false,
                      icon: "assets/images/ant-design_check-circle-filled.png",
                    ),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: PageView(
                  controller: _uploadPageController,
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      pageIndex = index;
                    });
                  },
                  children: [...pages],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: pageIndex > 0
                          ? RoundedRaisedButton(
                              title: "Back",
                              buttonColor: Colors.white,
                              titleColor: Colors.black,
                              onPress: pageIndex > 2
                                  ? null
                                  : () {
                                      if (pageIndex > 0) {
                                        _uploadPageController.animateToPage(
                                          --pageIndex,
                                          duration: Duration(microseconds: 200),
                                          curve: Curves.easeIn,
                                        );
                                      }
                                    },
                            )
                          : Container(),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: RoundedRaisedButton(
                        title:
                            pageIndex == pages.length - 1 ? "Complete" : "Next",
                        buttonColor: Theme.of(context).primaryColor,
                        isLoading: _isSubmitingOrder,
                        titleColor: Colors.white,
                        onPress: pageIndex == pages.length - 1
                            ? () async {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              }
                            : () async {
                                if (pageIndex < pages.length - 1) {
                                  try {
                                    await validatePage(pageIndex);
                                    _uploadPageController.animateToPage(
                                      ++pageIndex,
                                      duration: Duration(microseconds: 200),
                                      curve: Curves.easeIn,
                                    );
                                  } catch (error) {
                                    print(error.toString());
                                  }
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrackerWidget extends StatelessWidget {
  TrackerWidget({this.title, this.filled, this.icon});
  String title;
  bool filled;
  String icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor:
              filled ? Theme.of(context).primaryColor : Colors.grey,
          child: Image.asset("$icon", width: 20, height: 20),
          radius: 20,
        ),
        SizedBox(
          height: 5,
        ),
        Text("$title",
            style: TextStyle(
                fontSize: 12, color: filled ? Colors.black : Colors.grey)),
      ],
    );
  }
}
