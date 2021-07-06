import 'package:carpoolapp/models/address.dart';
import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier{
  userAddress pickUpLocation, dropOffLocation;

  void updatePickUpLocationAddress(userAddress pickUpAddress){
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(userAddress dropOffAddress){
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}