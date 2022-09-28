import 'package:flutter/material.dart';
import 'package:laundry_app/constants.dart';
import 'package:laundry_app/models/address_model.dart';
import 'package:laundry_app/providers/auth.dart';
import 'package:provider/provider.dart';

class MyLocationsScreen extends StatefulWidget {
  @override
  _MyLocationsScreenState createState() => _MyLocationsScreenState();
}

class _MyLocationsScreenState extends State<MyLocationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Locations"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          dynamic value = await Navigator.of(context)
              .pushNamed(kEditLocation, arguments: {"type": "add"});
          if (value == true) {
            setState(() {});
          }
        },
      ),
      body: Container(
          child: FutureBuilder(
        future: Provider.of<Auth>(context, listen: false).fetchAddresses(),
        builder: (ctx, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapShot.hasData) {
            return snapShot.data.length <= 0
                ? Center(
                    child: Image.asset("assets/images/empty_state_card.png"),
                  )
                : ListView.builder(
                    itemBuilder: (ctx, index) {
                      return LocationItem(
                        address: snapShot.data[index],
                        onEdit: () async {
                          dynamic value = await Navigator.of(context)
                              .pushNamed(kEditLocation, arguments: {
                            "address": snapShot.data[index],
                            "type": "edit"
                          });
                          if (value == true) {
                            setState(() {});
                          }
                        },
                      );
                    },
                    itemCount: snapShot.data.length,
                  );
          } else {
            return Center(
              child: Image.asset("assets/images/empty_state_card.png"),
            );
          }
        },
      )),
    );
  }
}

class LocationItem extends StatelessWidget {
  final AddressModel address;
  final Function onEdit;
  LocationItem({this.address, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${address.deliverTo} Address",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: onEdit,
                    child: Image.asset("assets/images/Combined shape 588.png",
                        height: 15, width: 15),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "${address.address}, ${address.city}, ${address.state}.",
                style: TextStyle(),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Icon(
                    Icons.phone_android,
                    size: 18,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "${address.contact}",
                    style: TextStyle(),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider()
      ],
    );
  }
}
