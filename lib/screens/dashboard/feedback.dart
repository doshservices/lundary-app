import 'package:flutter/material.dart';
import 'package:laundry_app/utils/custom_textformfield.dart';
import 'package:laundry_app/utils/rounded_raisedbutton.dart';

class FeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report & Feedbacks"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ReportItem(),
                    ReportItem(),
                    ReportItem(),
                    ReportItem(),
                    ReportItem(),
                    ReportItem(),
                    ReportItem(),
                    ReportItem(),
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

class ReportItem extends StatelessWidget {
  const ReportItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Order ID 455456",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "The delievery was prompt and timely... and the shirts were well arranged",
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
