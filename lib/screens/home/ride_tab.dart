import 'package:carpoolapp/data_handler/appData.dart';
import 'package:carpoolapp/models/user.dart';
import 'package:carpoolapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:carpoolapp/Assistants/assistantMethods.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:carpoolapp/screens/search/search_screen.dart';
import 'package:carpoolapp/models/directDetails.dart';

class rideTab extends StatefulWidget {
  @override
  _rideTabState createState() => _rideTabState();
}

class _rideTabState extends State<rideTab> with TickerProviderStateMixin{

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController newController;

  int _currentValue = 2;
  var departureDate;
  String error = '';

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  double rideDetailsContainerHeight = 0;

  DirectionDetails tripDirectionDetails;
  String departure;
  String destination;

  void displayRideDetailsContainer() async{
    await getPlaceDirection();
    print("Working 1");
    setState(() {
      rideDetailsContainerHeight = 300;
      print("Working 2");
    });
  }

  void locatePosition() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLngPosition, zoom: 14.0);
    newController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await AssistantMethods.searchCoordinateAddress(position, context);
    print("This is your Address: " + address);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.582045, 74.329376),
    zoom: 14.4746,
  );


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: _kGooglePlex,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          polylines: polylineSet,
          markers: markersSet,
          circles: circlesSet,
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
            newController = controller;

            setState(() {
              bottomPaddingOfMap = 300.0;
            });

            locatePosition();
          },
        ),

        Positioned(
            left: 100.0,
            right: 100.0,
            bottom: 20.0,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
              ),
              color: Colors.deepOrange,
              onPressed: () async {
                var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=>searchScreen()));

                if(res == "obtainDirection"){
                  displayRideDetailsContainer();
                }
                },
              child: Text("CHALEIN?", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold), ),
            )
        ),

        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: AnimatedSize(
            vsync: this,
            curve: Curves.bounceIn,
            duration: new Duration(milliseconds: 160),
            child: Container(
              height: rideDetailsContainerHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0),),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 16.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7,0.7),
                  ),
                ]
              ),

              child: Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Row(children: <Widget>[
                        Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text("Departure Date:"),
                      ), Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text("Available seats:"),
                      ), Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text("Distance:"),
                      )],),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                color: Colors.deepOrange,
                                child: Text('Choose Date',style: TextStyle(color: Colors.white,)),
                                onPressed: () async {
                                  final selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now().add(Duration(seconds: 1)),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2022),
                                  );
                                  print(selectedDate);
                                  setState(() {
                                    departureDate = selectedDate;
                                  });
                                }
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: new NumberPicker.integer(
                              initialValue: _currentValue,
                              minValue: 1,
                              maxValue: 4,
                              onChanged: (newValue) => setState(() => _currentValue = newValue)
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 50.0),
                            child: Center(
                              child: Text(
                                  ((tripDirectionDetails != null) ? tripDirectionDetails.distanceText : '')
                              ),
                            ),
                          ),
                        ],
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.75,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                            ),
                            color: Colors.deepOrange,
                            child: Text(
                              'Post Ride',
                              style: TextStyle(color: Colors.white,),
                            ),
                            onPressed: () async {
                              if(await DatabaseService(uid: user.uid).getImagePath() == ''){
                                setState(() => error = 'Please upload a profile picture before posting a ride.');
                              }
                              else if(departureDate == null){
                                setState(() => error = 'Please select a date');
                                }
                              else if(await DatabaseService(uid: user.uid).getLimit() == true){
                                setState(() => error = 'You can only post 1 trip at a time');
                              }
                              else if(departureDate != null){
                                print('doing');
                                setState(() => error = '');
                                await DatabaseService(uid: user.uid).updateTripDetails(_currentValue.toString(), departureDate.toString().substring(0,10), tripDirectionDetails.distanceText, true, departure, destination);
                                print('done');
                                setState(() => error = 'Ride Posted!');
                                print('done');
                              }
                              }
                        ),
                      ),
                      SizedBox(height: 12.0,),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ]
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> getPlaceDirection() async{
    var initialPos = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    var details = await AssistantMethods.obtainPlaceDirectionDetails(pickUpLatLng, dropOffLatLng);
    setState(() {
      tripDirectionDetails = details;
    });

    print("This is Encoded Points ::");
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult = polylinePoints.decodePolyline(details.encodedPoints);

    pLineCoordinates.clear();

    if(decodedPolyLinePointsResult.isNotEmpty){
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.pink,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if(pickUpLatLng.latitude > dropOffLatLng.latitude && pickUpLatLng.longitude > dropOffLatLng.longitude){
      latLngBounds = LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    }
    else if(pickUpLatLng.longitude > dropOffLatLng.longitude){
      latLngBounds = LatLngBounds(southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude), northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    }
    else if(pickUpLatLng.latitude > dropOffLatLng.latitude){
      latLngBounds = LatLngBounds(southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude), northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    }
    else{
      latLngBounds = LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    newController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
    
    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      infoWindow: InfoWindow(title: initialPos.placeName, snippet: "My Location"),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId")
    );
    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
        infoWindow: InfoWindow(title: finalPos.placeName, snippet: "DropOff Location"),
        position: dropOffLatLng,
        markerId: MarkerId("dropOffId")
    );

    setState(() {
      departure = initialPos.placeName;
      destination = finalPos.placeName;
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
      fillColor: Colors.yellow,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.yellowAccent,
      circleId: CircleId("pickUpId"),
    );

    Circle dropOffLocCircle = Circle(
      fillColor: Colors.green,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.greenAccent,
      circleId: CircleId("dropOffId"),
    );

    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });
  }
}