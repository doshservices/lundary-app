import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:laundry_app/constants.dart';
import 'package:laundry_app/screens/dashboard/home.dart';
import 'package:laundry_app/screens/dashboard/orders.dart';
import 'package:laundry_app/screens/dashboard/profile.dart';
import 'package:laundry_app/screens/dashboard/request.dart';

//pages

class Dashboard extends StatefulWidget {
  int initialIndex;

  Dashboard({this.initialIndex = 2});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  List<Map<String, dynamic>> _pages;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedPageIndex = widget.initialIndex;

    _pages = [
      {"title": "Home", "screen": HomeScreen()},
      {"title": "Trip", "screen": RequestScreen()},
      {"title": "Chat", "screen": OrdersScreen()},
      {"title": "Profile", "screen": ProfileScreen()},
    ];
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Exit",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              "Are you sure you want to exit the App?",
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              FlatButton(
                child: Text("NO"),
                onPressed: () {
                  return Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text("YES"),
                onPressed: () {
                  return Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(
        //     Icons.add,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Theme.of(context).primaryColor,
        //   onPressed: () {
        //     Navigator.of(context).pushNamed(kDryCleaning);
        //   },
        // ),
        bottomNavigationBar: Container(
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            onTap: _selectPage,
            currentIndex: _selectedPageIndex,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/Group 3.png",
                  height: 16,
                  fit: BoxFit.contain,
                ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    "Home",
                  ),
                ),
                activeIcon: Image.asset("assets/images/Group 3.png",
                    height: 20,
                    fit: BoxFit.contain,
                    color: Theme.of(context).primaryColor),
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/ArrowsLeftRight.png",
                  height: 16,
                  fit: BoxFit.contain,
                  color: Colors.grey,
                ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    "Request",
                  ),
                ),
                activeIcon: Image.asset("assets/images/ArrowsLeftRight.png",
                    height: 20,
                    fit: BoxFit.contain,
                    color: Theme.of(context).primaryColor),
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/Combined shape 1807.png",
                  height: 16,
                  fit: BoxFit.contain,
                  color: Colors.grey,
                ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    "Bookings",
                  ),
                ),
                activeIcon: Image.asset("assets/images/Combined shape 1807.png",
                    height: 20,
                    fit: BoxFit.contain,
                    color: Theme.of(context).primaryColor),
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/Combined shape 927.png",
                  height: 16,
                  fit: BoxFit.contain,
                  color: Colors.grey,
                ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    "Profile",
                  ),
                ),
                activeIcon: Image.asset("assets/images/Combined shape 927.png",
                    height: 20,
                    fit: BoxFit.contain,
                    color: Theme.of(context).primaryColor),
              ),
            ],
          ),
        ),
        body: _pages[_selectedPageIndex]["screen"],
      ),
    );
  }
}

class BottomItem extends StatelessWidget {
  BottomItem(
      {Key key, @required int page, this.index, this.iconUrl, this.title})
      : _page = page,
        super(key: key);

  int index, _page;
  String iconUrl;
  String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          "$iconUrl",
          width: 25,
          height: 25,
          color: _page == index ? Colors.white : Colors.black,
        ),
        Text(
          "$title",
          style: TextStyle(
            color: _page == index ? Colors.white : Colors.black,
          ),
        )
      ],
    );
  }
}
