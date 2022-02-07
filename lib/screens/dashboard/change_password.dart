import 'package:flutter/material.dart';
import 'package:laundry_app/constants.dart';
import 'package:laundry_app/utils/custom_textformfield.dart';
import 'package:laundry_app/utils/rounded_raisedbutton.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:laundry_app/providers/auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  String oldPassword = "";
  String newPassword = "";
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text(
          "Change password",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Icon(Icons.arrow_back_ios),
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Reset password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Kindly enter your old password"),
                  SizedBox(
                    height: 40,
                  ),
                  CustomTextFormField(
                    labelText: "Old password",
                    icon: Image.asset(
                      "assets/images/lock.png",
                      width: 25,
                      color: Colors.black,
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Token required";
                      }
                    },
                    onSaved: (value) {
                      oldPassword = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    labelText: "New password",
                    icon: Image.asset(
                      "assets/images/lock.png",
                      width: 25,
                      color: Colors.black,
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Token required";
                      }
                    },
                    onSaved: (value) {
                      newPassword = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 200,
                  ),
                  RoundedRaisedButton(
                    title: "Confirm",
                    isLoading: _isLoading,
                    width: MediaQuery.of(context).size.width,
                    onPress: () async {
                      try {
                        FocusScope.of(context).unfocus();
                        if (!_formKey.currentState.validate()) {
                          Get.snackbar(
                              'Error!', 'Please complete the missing fields',
                              barBlur: 0,
                              dismissDirection: SnackDismissDirection.VERTICAL,
                              backgroundColor: Colors.red,
                              overlayBlur: 0,
                              animationDuration: Duration(milliseconds: 500),
                              duration: Duration(seconds: 2));
                          return;
                        }
                        _formKey.currentState.save();
                        setState(() {
                          _isLoading = true;
                        });
                        await Provider.of<Auth>(context, listen: false)
                            .changePassword(oldPassword, newPassword);
                        Navigator.of(context).pop();

                        Get.snackbar('Success!', 'Pssword changed successfully',
                            barBlur: 0,
                            dismissDirection: SnackDismissDirection.VERTICAL,
                            backgroundColor: Colors.green,
                            overlayBlur: 0,
                            animationDuration: Duration(milliseconds: 500),
                            duration: Duration(seconds: 2));
                      } catch (error) {
                        Get.snackbar('Error!', '${error.toString()}',
                            barBlur: 0,
                            dismissDirection: SnackDismissDirection.VERTICAL,
                            backgroundColor: Colors.red,
                            overlayBlur: 0,
                            animationDuration: Duration(milliseconds: 500),
                            duration: Duration(seconds: 2));
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
