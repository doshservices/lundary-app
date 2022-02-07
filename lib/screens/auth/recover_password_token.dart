import 'package:flutter/material.dart';
import 'package:laundry_app/constants.dart';
import 'package:laundry_app/utils/custom_textformfield.dart';
import 'package:laundry_app/utils/rounded_raisedbutton.dart';
import 'package:get/get.dart';
import 'package:laundry_app/providers/auth.dart';
import 'package:provider/provider.dart';

class RecoverPasswordTokenScreen extends StatefulWidget {
  @override
  _RecoverPasswordTokenScreenState createState() =>
      _RecoverPasswordTokenScreenState();
}

class _RecoverPasswordTokenScreenState
    extends State<RecoverPasswordTokenScreen> {
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  String token = "";
  String newPassword = "";
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text(
          "Recover Password",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Icon(Icons.arrow_back_ios),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Recovery Token Sent",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Please enter password recovery token sent your email"),
                  SizedBox(
                    height: 40,
                  ),
                  CustomTextFormField(
                    labelText: "Token",
                    icon: Icon(Icons.lock, color: Colors.black),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Token required";
                      }
                    },
                    onSaved: (value) {
                      token = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    labelText: "New Password",
                    icon: Icon(Icons.lock, color: Colors.black),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "password required";
                      }
                    },
                    onSaved: (value) {
                      newPassword = value;
                    },
                    suffixIcon: _obscurePassword
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility_rounded),
                    obscureText: _obscurePassword,
                    suffixIconPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  RoundedRaisedButton(
                    title: "Continue",
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
                            .forgotPasswordCompletion(token, newPassword);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .pushReplacementNamed(kLoginScreen);
                        Get.snackbar('Success!', 'Pssword reset successful',
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
