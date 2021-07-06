import 'package:flutter/material.dart';
import 'package:carpoolapp/models/rideDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carpoolapp/services/database.dart';
import 'package:carpoolapp/shared/loading.dart';
import 'package:carpoolapp/screens/home/messages_tab.dart';
import 'package:getflutter/components/rating/gf_rating.dart';

class RideTile extends StatelessWidget {

  User user = FirebaseAuth.instance.currentUser;

  final RideDetails ride;
  RideTile({this.ride});

  @override
  Widget build(BuildContext context) {

    double _rating = 3.5;

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 25.0,
                backgroundColor: Colors.deepOrangeAccent,
                child: ClipOval(
                  child: SizedBox(
                    width: 180.0,
                    height: 180.0,
                    child: (ride.path == '') ? Loading() : Image.network(ride.path,fit: BoxFit.cover,),
                  ),
                ),
              ),
              title: Text('From: ' + ride.departure + ' To: ' + ride.destination),
              subtitle: Text('Date: ' + ride.date + ' Distance: ' + ride.distance + ' Available Seats: ' + ride.seats + ' Poster: ' + ride.name),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: GFRating(
                    size: 25.0,
                    color: Colors.deepOrangeAccent,
                    value: _rating,
                  ),
                ),
                ((ride.uid == user.uid) ? Padding(
                  padding: const EdgeInsets.only(left: 120.0),
                  child: FlatButton(
                      color: Colors.red,
                      onPressed: () async {
                        await DatabaseService(uid: user.uid).updateLimit(false);
                        print('done');
                      },
                      child: Text('Delete',  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))
                  ),
                ) : Padding(
                  padding: const EdgeInsets.only(left: 120.0),
                  child: FlatButton(
                      color: Colors.blue,
                      onPressed: () async { await Navigator.push(context, MaterialPageRoute(builder: (context)=>messagesTab(temp: ride.uid, tempName: ride.name, tempPath: ride.path,))); },
                      child: Text('Chat Now',  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}