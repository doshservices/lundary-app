import 'package:flutter/material.dart';
import 'package:laundry_app/constants.dart';
import 'package:laundry_app/providers/auth.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isNotification = true;
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    return Container(
      child: Column(
        children: [
          Container(
            height: 130,
            width: MediaQuery.of(context).size.width,
            color: Color(0xff161D66),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 50,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        radius: 30,
                        backgroundImage: NetworkImage(
                            "${authProvider.user.profilePhoto != null ? authProvider.user.profilePhoto : ''}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${authProvider.user.firstName} ${authProvider.user.lastName}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                Text(
                                  "Abuja, Nigeria",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 8,
                      shadowColor: Colors.grey.withOpacity(0.2),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Image.asset("assets/images/Object.png",
                                height: 20, width: 20),
                            minLeadingWidth: 20,
                            title: Text("Account Info"),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(kAccountInfoScreen);
                            },
                          ),
                          Divider(),
                          ListTile(
                            leading: Image.asset(
                              "assets/images/Combined shape 1811.png",
                              width: 20,
                              height: 20,
                            ),
                            minLeadingWidth: 20,
                            title: Text("My Locations"),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(kMyLocationsScreen);
                            },
                          ),
                          Divider(),
                          ListTile(
                            leading: Image.asset("assets/images/Object.png",
                                height: 20, width: 20),
                            minLeadingWidth: 20,
                            title: Text("Privacy Policy"),
                            onTap: () {
                              Navigator.of(context).pushNamed(kPrivacyPolicy);
                            },
                          ),
                          Divider(),
                          ListTile(
                            leading: Image.asset(
                              "assets/images/Combined shape 1034.png",
                              height: 20,
                              width: 20,
                            ),
                            minLeadingWidth: 20,
                            title: Text("Change Password"),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(kChangePasswordScreen);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 8,
                      shadowColor: Colors.grey.withOpacity(0.2),
                      child: Column(
                        children: [
                          // ListTile(
                          //   leading: Image.asset(
                          //       "assets/images/ant-design_star-outlined.png",
                          //       height: 20,
                          //       width: 20),
                          //   minLeadingWidth: 20,
                          //   title: Text("Report & Feedback"),
                          //   onTap: () {
                          //     Navigator.of(context).pushNamed(kFeedbackScreen);
                          //   },
                          // ),
                          // Divider(),
                          // ListTile(
                          //   leading: Image.asset(
                          //     "assets/images/Forma 1.png",
                          //     width: 20,
                          //     height: 20,
                          //   ),
                          //   minLeadingWidth: 20,
                          //   title: Text("Refer & Earn"),
                          //   onTap: () {
                          //     Navigator.of(context).pushNamed(kReferScreen);
                          //   },
                          // ),
                          // Divider(),
                          ListTile(
                            leading: Image.asset(
                              "assets/images/Combined shape 1012.png",
                              width: 20,
                              height: 20,
                            ),
                            minLeadingWidth: 20,
                            title: Text("App Notification"),
                            trailing: Switch(
                              onChanged: (value) {
                                setState(() {
                                  isNotification = value;
                                });
                              },
                              value: isNotification,
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 8,
                      shadowColor: Colors.grey.withOpacity(0.2),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Image.asset(
                              "assets/images/codicon_sign-out.png",
                              height: 20,
                              width: 20,
                            ),
                            minLeadingWidth: 20,
                            title: Text("Sign Out"),
                            onTap: () {
                              authProvider.logout();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  kLoginScreen, (route) => false);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
