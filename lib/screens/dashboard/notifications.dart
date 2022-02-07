import 'package:flutter/material.dart';
import 'package:laundry_app/models/notifications.dart';
import 'package:laundry_app/providers/service_provider.dart';
import 'package:laundry_app/utils/custom_textformfield.dart';
import 'package:laundry_app/utils/rounded_raisedbutton.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Notification"),
          centerTitle: true,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder(
            future: Provider.of<ServiceProvider>(context, listen: false)
                .fetchNotifications(),
            builder: (ctx, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapShot.hasData) {
                return ListView.builder(
                  itemBuilder: (ctx, index) {
                    return NotificationItem(
                      notification: snapShot.data[index],
                    );
                  },
                  itemCount: snapShot.data.length,
                );
              } else {
                return Center(
                  child: Image.asset("assets/images/no_data.png"),
                );
              }
            },
          ),
        ));
  }
}

class NotificationItem extends StatelessWidget {
  NotificationModel notification;
  NotificationItem({this.notification});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  notification.orderStatus == "COMFIRMED"
                      ? Image.asset(
                          "assets/images/Object (1).png",
                          height: 30,
                          width: 30,
                        )
                      : Container(),
                  notification.orderStatus == "PICKED_UP"
                      ? Image.asset(
                          "assets/images/Object (2).png",
                          height: 30,
                          width: 30,
                        )
                      : Container(),
                  notification.orderStatus == "IN_PROCESS"
                      ? Image.asset(
                          "assets/images/Object (3).png",
                          height: 30,
                          width: 30,
                        )
                      : Container(),
                  notification.orderStatus == "SHIPPED"
                      ? Image.asset(
                          "assets/images/Object (4).png",
                          height: 30,
                          width: 30,
                        )
                      : Container(),
                  notification.orderStatus == "DELIVERED"
                      ? Image.asset(
                          "assets/images/Object (5).png",
                          height: 30,
                          width: 30,
                        )
                      : Container(),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${notification.title}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${notification.message}",
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Row(
                children: [Text("${notification.createdAt.substring(0, 10)}")],
              ),
            ],
          ),
        ),
        Divider()
      ],
    );
  }
}
