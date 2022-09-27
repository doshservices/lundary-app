import 'package:flutter/material.dart';
import 'package:laundry_app/constants.dart';
import 'package:laundry_app/providers/auth.dart';
import 'package:laundry_app/utils/custom_textformfield.dart';
import 'package:laundry_app/utils/rounded_raisedbutton.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = new GlobalKey<FormState>();
  // bool _rememberMe = false;
  bool _isLoading = false;
  String userEmail, userPassword;
  String errMsg = "";
  bool _obscurePassword = true;

  Future<void> _submitLogin() async {
    if (!_loginFormKey.currentState.validate()) {
      return;
    }
    _loginFormKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .signIn(userEmail, userPassword);

      Navigator.of(context)
          .pushNamedAndRemoveUntil(kDashboardScreen, (route) => false);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text(
          "Log In",
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
              key: _loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Getting started",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Input your details to Sign in"),
                  SizedBox(
                    height: 40,
                  ),
                  CustomTextFormField(
                    labelText: "Email address",
                    icon: Icon(Icons.email_outlined, color: Colors.black),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Email can't be empty";
                      }
                    },
                    onSaved: (value) {
                      userEmail = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    labelText: "Password",
                    icon: _obscurePassword
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility_rounded),
                    obscureText: _obscurePassword,
                    iconPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Password can't be empty";
                      }
                    },
                    onSaved: (value) {
                      userPassword = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(kRecoverPassword);
                        },
                        child: Text(
                          "Forgot Password?",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 160,
                  ),
                  RoundedRaisedButton(
                    title: "Sign in",
                    width: MediaQuery.of(context).size.width,
                    isLoading: _isLoading,
                    onPress: () async {
                      await _submitLogin();
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(kRegisterScreen);
                        },
                        child: Text(
                          "Sign up",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
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
