import 'package:flutter/material.dart';
import 'package:laundry_app/constants.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset("assets/images/nathan_logo.png", width: 350),
        ),
      ),
    );
  }
}
