import 'package:flutter/material.dart';
import 'package:laundry_app/models/address_model.dart';
import 'package:laundry_app/providers/auth.dart';
import 'package:laundry_app/utils/custom_textformfield.dart';
import 'package:laundry_app/utils/rounded_raisedbutton.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class EditLocation extends StatefulWidget {
  @override
  _EditLocationState createState() => _EditLocationState();
}

class _EditLocationState extends State<EditLocation> {
  GlobalKey<FormState> _addressFormKey = GlobalKey();
  AddressModel address = AddressModel();
  bool _isSavingAddress = false;
  bool _isInit = true;
  String addressLocation = "HOME";
  String type = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final arguments =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

      type = arguments["type"];
      address = type == "edit" ? arguments["address"] : AddressModel();
      addressLocation = address.deliverTo != null ? address.deliverTo : "HOME";

      setState(() {
        _isInit = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Location"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 50,
              color: Color(0xffF7F7F7),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "${type == 'edit' ? 'Edit' : 'Add'} Address",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      hintText: "Enter City",
                      labelText: "",
                      initialValue: address.city != null ? address.city : "",
                      validator: (value) {
                        if (value.isEmpty) {
                          return "City required";
                        }
                      },
                      onSaved: (value) {
                        address.city = value;
                      },
                    ),
                    CustomTextFormField(
                      hintText: "Enter State",
                      labelText: "",
                      initialValue: address.state != null ? address.state : "",
                      validator: (value) {
                        if (value.isEmpty) {
                          return "State required";
                        }
                      },
                      onSaved: (value) {
                        address.state = value;
                      },
                    ),
                    CustomTextFormField(
                      hintText: "Enter Address",
                      labelText: "",
                      initialValue:
                          address.address != null ? address.address : "",
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
                      hintText: "Contact Phone number",
                      keyboardType: TextInputType.number,
                      initialValue:
                          address.contact != null ? address.contact : "",
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
                              contentPadding: EdgeInsets.all(0),
                              groupValue: addressLocation,
                              title: Text(
                                "HOME",
                                style: TextStyle(fontSize: 12),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  addressLocation = value;
                                });
                              }),
                        ),
                        Expanded(
                          child: RadioListTile(
                              value: "WORK",
                              title: Text(
                                "WORK",
                                style: TextStyle(fontSize: 12),
                              ),
                              contentPadding: EdgeInsets.all(0),
                              groupValue: addressLocation,
                              onChanged: (value) {
                                setState(() {
                                  addressLocation = value;
                                });
                              }),
                        ),
                        Expanded(
                          child: RadioListTile(
                              value: "OTHER",
                              title: Text(
                                "OTHER",
                                style: TextStyle(fontSize: 12),
                              ),
                              contentPadding: EdgeInsets.all(0),
                              groupValue: addressLocation,
                              onChanged: (value) {
                                setState(() {
                                  addressLocation = value;
                                });
                              }),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: RoundedRaisedButton(
                        title: "SAVE AND CONTINUE",
                        isLoading: _isSavingAddress,
                        onPress: () async {
                          try {
                            if (!_addressFormKey.currentState.validate()) {
                              return;
                            }
                            _addressFormKey.currentState.save();
                            address.deliverTo = addressLocation;
                            setState(() {
                              _isSavingAddress = true;
                            });
                            if (type == "edit") {
                              await Provider.of<Auth>(context, listen: false)
                                  .updateAddress(address);
                            } else {
                              await Provider.of<Auth>(context, listen: false)
                                  .createAddress(address);
                            }

                            Navigator.of(context).pop(true);

                            Get.snackbar(
                                'Success!', 'Address updated successfully',
                                barBlur: 0,
                                dismissDirection:
                                    SnackDismissDirection.VERTICAL,
                                backgroundColor: Colors.green,
                                overlayBlur: 0,
                                animationDuration: Duration(milliseconds: 500),
                                duration: Duration(seconds: 2));
                          } catch (error) {
                            Get.snackbar('Error!', '${error.toString()}',
                                barBlur: 0,
                                dismissDirection:
                                    SnackDismissDirection.VERTICAL,
                                backgroundColor: Colors.red,
                                overlayBlur: 0,
                                animationDuration: Duration(milliseconds: 500),
                                duration: Duration(seconds: 2));
                          } finally {
                            setState(() {
                              _isSavingAddress = false;
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
  }
}
