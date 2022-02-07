import 'package:flutter/material.dart';
import 'package:laundry_app/constants.dart';
import 'package:laundry_app/models/http_exception.dart';
import 'package:laundry_app/models/user_model.dart';
import 'package:laundry_app/providers/auth.dart';
import 'package:laundry_app/utils/custom_textformfield.dart';
import 'package:laundry_app/utils/rounded_raisedbutton.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey();

  final _passwordController = TextEditingController();

  UserModel userModel = UserModel();
  bool _termsAndCondition = false;
  TextEditingController _date = new TextEditingController();
  bool agree = false;

  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_registerFormKey.currentState.validate()) {
      Get.snackbar('Error!', 'Please complete the missing fields',
          barBlur: 0,
          dismissDirection: SnackDismissDirection.VERTICAL,
          backgroundColor: Colors.red,
          overlayBlur: 0,
          animationDuration: Duration(milliseconds: 500),
          duration: Duration(seconds: 2));
      return;
    }
    _registerFormKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false).sendOtp(userModel.email);
      Navigator.of(context)
          .pushNamed(kOtpVerification, arguments: {"user": userModel});
    } on HttpException catch (error) {
      Get.snackbar('Error!', '${error.toString()}',
          barBlur: 0,
          dismissDirection: SnackDismissDirection.VERTICAL,
          backgroundColor: Colors.red,
          overlayBlur: 0,
          animationDuration: Duration(milliseconds: 500),
          duration: Duration(seconds: 2));
    } catch (error) {
      Get.snackbar('Error!', 'Registration Failed, Please try again later',
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
          "Create Account",
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
              key: _registerFormKey,
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
                  Text("Create an account to continue"),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          labelText: "First name",
                          icon: Icon(Icons.person_outline, color: Colors.black),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "First Name required";
                            }
                          },
                          onSaved: (value) {
                            userModel.firstName = value;
                          },
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: CustomTextFormField(
                          labelText: "Last name",
                          // icon: Icon(Icons.person_outline, color: Colors.black),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Last Name required";
                            }
                          },
                          onSaved: (value) {
                            userModel.lastName = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    labelText: "Email address",
                    icon: Icon(Icons.email_outlined, color: Colors.black),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Email required required";
                      }
                    },
                    onSaved: (value) {
                      userModel.email = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    labelText: "Phone number",
                    keyboardType: TextInputType.number,
                    icon: Icon(Icons.phone_outlined, color: Colors.black),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Phone number required";
                      }
                    },
                    onSaved: (value) {
                      userModel.phoneNumber = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    labelText: "Password",
                    icon: Image.asset(
                      "assets/images/lock.png",
                      width: 25,
                      color: Colors.black,
                    ),
                    suffixIcon: _obscurePassword
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility_rounded),
                    obscureText: _obscurePassword,
                    suffixIconPressed: () {
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
                      userModel.password = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Row(
                      children: [
                        Checkbox(
                            activeColor: kPrimaryColor,
                            //  checkColor: kPrimaryColor,
                            value: agree,
                            onChanged: (value) {
                              setState(() {
                                agree = value ?? false;
                              });
                            }),
                        Text(
                          'I accept the ',
                          overflow: TextOverflow.ellipsis,
                          // style: TextStyle(color: kPrimaryColor),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(kPrivacyPolicy);
                          },
                          child: Text(
                            'Terms & Conditions',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: kPrimaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RoundedRaisedButton(
                    title: "Sign up",
                    width: MediaQuery.of(context).size.width,
                    isLoading: _isLoading,
                    onPress: () async {
                      _submit();
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(kLoginScreen);
                        },
                        child: Text(
                          "Sign in",
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
