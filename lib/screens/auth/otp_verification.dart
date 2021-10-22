import 'dart:async';

import 'package:flutter/material.dart';
import 'package:laundry_app/constants.dart';
import 'package:laundry_app/models/http_exception.dart';
import 'package:laundry_app/utils/custom_textformfield.dart';
import 'package:laundry_app/utils/rounded_raisedbutton.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:get/get.dart';
import 'package:laundry_app/providers/auth.dart';
import 'package:laundry_app/models/user_model.dart';
import 'package:provider/provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  Map<String, dynamic> labels = {};
  final formKey = GlobalKey<FormState>();
  bool hasError = false;
  TextEditingController textEditingController = TextEditingController();
  String currentText = "";
  bool _isLoading = false;
  StreamController<ErrorAnimationType> errorController;
  bool _isDigitComplete = false;
  bool _isResendingOtp = false;
  bool _isValidatingOtp = false;
  UserModel user = UserModel();

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (currentText.isEmpty) {
      Get.snackbar('Error!', 'Enter valid OTP',
          barBlur: 0,
          dismissDirection: SnackDismissDirection.VERTICAL,
          backgroundColor: Colors.red,
          overlayBlur: 0,
          animationDuration: Duration(milliseconds: 500),
          duration: Duration(seconds: 2));
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).signUp(user, currentText);

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            return AlertDialog(
              title: Text("Registration Successful"),
              content: Text("Account has been successfully created"),
              actions: [
                RoundedRaisedButton(
                  title: "Login",
                  width: 150,
                  onPress: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed(kLoginScreen);
                  },
                )
              ],
            );
          });
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
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    user = arguments["user"];
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text(
          "Verifications",
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Verifications",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                  "A 6-digits pin has been sent to your email address, enter it below to continue"),
              SizedBox(
                height: 40,
              ),
              Text("Code verification"),
              PinCodeTextField(
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                length: 6,
                obscureText: false,
                obscuringCharacter: '*',
                blinkWhenObscuring: true,
                animationType: AnimationType.fade,
                validator: (v) {
                  // if (v.length < 6) {
                  //   setState(() {
                  //     _isDigitComplete = false;
                  //   });
                  // } else {
                  //   return null;
                  // }
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.underline,
                  inactiveColor: Colors.grey,
                  borderRadius: BorderRadius.circular(15),
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Color(0xffF0F3F6),
                  selectedColor: Theme.of(context).primaryColor,
                  activeColor: Theme.of(context).primaryColor,
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: hasError ? Colors.grey : Colors.white,
                ),
                cursorColor: Colors.black,
                animationDuration: Duration(milliseconds: 300),
                backgroundColor: Colors.white10,
                enableActiveFill: true,
                errorAnimationController: errorController,
                controller: textEditingController,
                keyboardType: TextInputType.number,

                // boxShadows: [
                //   BoxShadow(
                //     offset: Offset(0, 1),
                //     color: Colors.black12,
                //     blurRadius: 10,
                //   )
                // ],
                onCompleted: (v) async {
                  print("Completed");
                  setState(() {
                    _isDigitComplete = true;
                  });
                  // await signup(context);
                },
                // onTap: () {
                //   print("Pressed");
                // },
                onChanged: (value) {
                  print(value);
                  setState(() {
                    currentText = value;
                  });
                  if (value.length < 6) {
                    setState(() {
                      _isDigitComplete = false;
                    });
                  }
                },
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isResendingOtp
                        ? null
                        : () async {
                            try {
                              setState(() {
                                _isResendingOtp = true;
                              });
                              await Provider.of<Auth>(context, listen: false)
                                  .sendOtp(user.email);
                            } catch (error) {
                              Get.snackbar('Error!', '${error.toString()}',
                                  barBlur: 0,
                                  dismissDirection:
                                      SnackDismissDirection.VERTICAL,
                                  backgroundColor: Colors.red,
                                  overlayBlur: 0,
                                  animationDuration:
                                      Duration(milliseconds: 500),
                                  duration: Duration(seconds: 2));
                            } finally {
                              setState(() {
                                _isResendingOtp = false;
                              });
                            }
                          },
                    child: _isResendingOtp
                        ? Row(
                            children: [
                              Container(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator()),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Resending Otp"),
                            ],
                          )
                        : Text("Resend Otp"),
                  ),
                ],
              ),
              Expanded(child: Container()),
              RoundedRaisedButton(
                title: "Continue",
                width: MediaQuery.of(context).size.width,
                isLoading: _isLoading,
                onPress: () {
                  _submit();
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
