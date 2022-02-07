import 'package:flutter/material.dart';
import 'package:laundry_app/constants.dart';
import 'package:laundry_app/utils/custom_textformfield.dart';
import 'package:laundry_app/utils/rounded_raisedbutton.dart';
import 'package:get/get.dart';
import 'package:laundry_app/providers/auth.dart';
import 'package:provider/provider.dart';

class RecoverPasswordScreen extends StatefulWidget {
  @override
  _RecoverPasswordScreenState createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  String email = "";
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Password Recovery",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Enter your email to recover your password"),
                SizedBox(
                  height: 40,
                ),
                CustomTextFormField(
                  labelText: "Email address",
                  icon: Icon(Icons.email, color: Colors.black),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Email required";
                    }
                  },
                  onSaved: (value) {
                    email = value;
                  },
                ),
                Expanded(child: Container()),
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
                          .forgotPassword(email);
                      Navigator.of(context).pushNamed(kResetPasswordToken);
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
    );
  }
}
