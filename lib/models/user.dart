class AppUser {
  final String uid;

  AppUser({this.uid});

}

class UserData{
  final String uid;
  final String name;

  UserData({this.uid, this.name});

}

class rideDetails{

  final String name;
  final String seats;
  final String distance;
  final String departure;
  final String destination;
  final String date;
  final bool limit;

  rideDetails({this.name,this.seats,this.distance,this.departure,this.destination,this.date,this.limit});

}