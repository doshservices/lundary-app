import 'package:flutter/material.dart';
import 'package:laundry_app/utils/custom_textformfield.dart';
import 'package:laundry_app/utils/rounded_raisedbutton.dart';

class RequestDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Locations"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    LocationItem(),
                    LocationItem(),
                    LocationItem(),
                    LocationItem(),
                    LocationItem(),
                    LocationItem(),
                    LocationItem(),
                    LocationItem(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationItem extends StatelessWidget {
  const LocationItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pickup Address",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset("assets/images/Combined shape 588.png",
                      height: 15, width: 15)
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Home - Sco 78-79, Phase IV, Suleija, Abuja, Nigeria, 160059",
                style: TextStyle(),
              ),
            ],
          ),
        ),
        Divider()
      ],
    );
  }
}
