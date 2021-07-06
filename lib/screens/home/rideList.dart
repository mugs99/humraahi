import 'package:carpoolapp/models/rideDetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ride_tile.dart';
import 'package:carpoolapp/shared/loading.dart';

class rideList extends StatefulWidget {
  @override
  _rideListState createState() => _rideListState();
}

class _rideListState extends State<rideList> {

  final _formKey = GlobalKey<FormState>();
  String search = '';

  @override
  Widget build(BuildContext context) {

    final rides = Provider.of<List<RideDetails>>(context);
    int count = 0;



    if (rides != null) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                validator: (val)  => val.length < 3 ? 'Search something with more than 3 letters' : null,
                cursorColor: Colors.lightBlueAccent,
                style: TextStyle(color: Colors.white),
                decoration: new InputDecoration(
                    fillColor: Colors.deepOrangeAccent,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none
                      ),
                    ),
                    contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "Search..",
                    hintStyle: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic)
                ),
                onChanged: (val){
                  setState(() => search = val);
                },
              ),
            ),
          ),
          SizedBox(height: 10.0,),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: rides.length,
              itemBuilder: (context, index) {
                print('Rides: ${rides.length}');
                if (rides[index].limit == true) {
                  if(search == null) {
                    return RideTile(ride: rides[index]);
                  }
                  else{
                    if(rides[index].name.toLowerCase().contains(search.toLowerCase()) || rides[index].destination.toLowerCase().contains(search.toLowerCase()) || rides[index].departure.toLowerCase().contains(search.toLowerCase())){
                      return RideTile(ride: rides[index],);
                    }
                  }
                }
                else if(rides[index].limit == false){
                  ++count;
                  if(rides.length == count){
                    print('no rides');
                    return Center(child: Text('No rides posted yet. Be the first to post a ride!'));
                  }
                  else{
                    return SizedBox(height: 0.0,);
                  }
                }
                return SizedBox(height: 0.0,);
              },
            ),
          ),
        ],
      );
    }
    else {
      return Loading();
    }
  }
}
