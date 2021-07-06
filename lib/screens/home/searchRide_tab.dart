import 'package:carpoolapp/models/rideDetails.dart';
import 'package:carpoolapp/screens/home/rideList.dart';
import 'package:carpoolapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class searchRideTab extends StatefulWidget {
  @override
  _searchRideTabState createState() => _searchRideTabState();
}

class _searchRideTabState extends State<searchRideTab> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<RideDetails>>.value(
      value: DatabaseService().rideDetails,
      child: Scaffold(
        body: rideList(),
      ),
    );
  }
}