import 'package:carpoolapp/models/rideDetails.dart';
import 'package:carpoolapp/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:carpoolapp/models/chatdata.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  final Reference firebaseStorageRef = FirebaseStorage.instance.ref();

  // images
  File _image;
  String _uploadedFileURL;


  Future updateUserData(String name) async {
    return await usersCollection.doc(uid).set({
      'name': name,
    },SetOptions(merge: true));
  }

  Future updateImagePath(String path) async {
    return await usersCollection.doc(uid).update({
      'path': path,
    });
  }

  Future getImagePath() async {
    return await usersCollection.doc(uid).get().then<dynamic>((DocumentSnapshot snapshot) async {
      if(snapshot.data()['path'] == null){
        return '';
      }
      else {
        return snapshot.data()['path'];
      }
    });
  }

  Future updateTripDetails(String seats, String date, String distance, bool limit, String departure, String destination) async {
    return await usersCollection.doc(uid).update({
      'seats': seats,
      'date' : date,
      'distance' : distance,
      'limit' : limit,
      'departure' : departure,
      'destination' : destination,
      'uid' : uid,
    },);
  }

  Future updateLimit(bool limit) async {
    return await usersCollection.doc(uid).update({
      'limit': limit,
    });
  }

  Future updatePhone(String phone) async {
    return await usersCollection.doc(uid).update({
      'phone': phone,
    });
  }

  Future getPhoneNumber() async {
    return await usersCollection.doc(uid).get().then<dynamic>((DocumentSnapshot snapshot) async {
      if(snapshot.data()['phone'] == null){
        print('No phone number exists');
      }
      else {
        return snapshot.data()['phone'];
      }
    });
  }

  
  Future createMessagesCollection() async {
    return await usersCollection.doc(uid).collection('messages').add({'placeholder' : 'placeholder'});
  }

  Future getLimit() async {
    return await usersCollection.doc(uid).get().then<dynamic>((DocumentSnapshot snapshot) async {
      if(snapshot.data()['limit'] == false){
        return false;
      }
      else {
        return true;
      }
    });
  }

  Future getProfile() async {
    return await usersCollection.doc(uid).get().then<dynamic>((DocumentSnapshot snapshot) async {
      if(snapshot.data()['name'] == null){
        print("No name exists");
      }
      else {
        return snapshot.data()['name'];
      }
    });
  }

  // userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      name: snapshot.data()['name'],
    );
  }

  // upload profile picture to firebase
  Future uploadPic(BuildContext context, File image) async{
    if(image != null) {
      String fileName = Path.basename(image.path);
      UploadTask uploadTask = firebaseStorageRef.child(uid).putFile(image);
    } else{
      return null;
    }
  }

  // ride list from snapshot
  List<RideDetails> _rideDetailsListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return RideDetails(
        name: doc.data()['name'],
        date: doc.data()['date'],
        departure: doc.data()['departure'],
        destination: doc.data()['destination'],
        distance: doc.data()['distance'],
        seats: doc.data()['seats'],
        limit: doc.data()['limit'],
        uid: doc.data()['uid'],
        path: doc.data()['path'],
      );
    }
    ).toList();
  }

  // chat list from snapshot
  List<ChatData> _chatDataListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return ChatData(
        name: doc.data()['name'],
        date: doc.data()['date'],
        departure: doc.data()['departure'],
        destination: doc.data()['destination'],
        distance: doc.data()['distance'],
        seats: doc.data()['seats'],
        limit: doc.data()['limit'],
        uid: doc.data()['uid'],
        path: doc.data()['path'],
      );
    }
    ).toList();
  }

  Stream<List<ChatData>> get chatData{
    return usersCollection.snapshots().map(_chatDataListFromSnapshot);
  }


  Stream<List<RideDetails>> get rideDetails{
    return usersCollection.snapshots().map(_rideDetailsListFromSnapshot);
  }

  // get user doc stream
Stream<UserData> get userData{
    return usersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
}

}