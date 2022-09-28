import 'package:flutter/material.dart';
import 'package:laundry_app/screens/dashboard/home.dart';
import 'package:laundry_app/screens/dashboard/orders.dart';
import 'package:laundry_app/screens/dashboard/profile.dart';
import 'package:laundry_app/screens/dashboard/request.dart';

//pages

class Dashboard extends StatefulWidget {
  final int initialIndex;

  Dashboard({this.initialIndex = 2});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  List<Map<String, dynamic>> _pages;
  // GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
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
              TextButton(
                onPressed: () {
                  return Navigator.of(context).pop(false);
                },
                child: Text('NO'),
              ),
              TextButton(
                onPressed: () {
                  return Navigator.of(context).pop(true);
                },
                child: Text('YES'),
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
                label: 'Home',
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
                label: 'Request',
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
                label: 'Bookings',
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
                label: 'Profile',
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

  final int index, _page;
  final String iconUrl;
  final String title;

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
