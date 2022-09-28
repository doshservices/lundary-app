import 'package:flutter/material.dart';
import 'package:laundry_app/utils/rounded_raisedbutton.dart';

class ReferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Refer & Earn"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    CircleAvatar(
                      radius: 60,
                      child: Image.asset("assets/images/Frame.png",
                          width: 50, height: 50),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Invite Friends",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Enjoy free ",
                        ),
                        Text(
                          "Discount ",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("on every referral")
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "When your friends sign up using your referral, you get  N1,000 per refferal",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "SHARE YOUR INVITE CODE",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Text("5L6I5L4L"),
                      ],
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RoundedRaisedButton(
                title: "Invite",
                onPress: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
