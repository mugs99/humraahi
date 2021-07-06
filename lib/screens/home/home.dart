import 'package:flutter/material.dart';
import 'package:carpoolapp/services/auth.dart';
import 'package:carpoolapp/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'searchRide_tab.dart';
import 'package:carpoolapp/screens/home/prepre_message_tab.dart';
import 'profile_tab.dart';
import 'ride_tab.dart';
import 'pre_message_tab.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  int _currentIndex = 0;
  final List<Widget> _children = [
    rideTab(),
    searchRideTab(),
    prepreMessageTab(),
    profileTab(),
  ];

  User user = FirebaseAuth.instance.currentUser;

  DatabaseService db = DatabaseService(uid: FirebaseAuth.instance.currentUser.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.lightBlueAccent,Colors.lightBlue,Colors.lightBlue,Colors.lightBlue]
              ),
            ),
          ),
          title: Center(child: Image.asset('images/Banner2.png', fit: BoxFit.fitWidth, scale: 3.0,)),
          backgroundColor: Colors.greenAccent, //no drop shadow
          actions: <Widget>[

          ],
        ),
        body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        backgroundColor: Colors.black, // this will be set when a new tab is tapped
      items: [
        BottomNavigationBarItem(
          icon: new Icon(Icons.directions_car),
          label: 'Post',
        ),
        BottomNavigationBarItem(
          icon: new Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: new Icon(Icons.message_outlined),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile'
        ),
      ],
    ),// body: UserTile(user: FirebaseAuth.instance().getCurrentUser()),
    );
  }

  // Switch between tabs
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

}
