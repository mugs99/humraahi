import 'package:carpoolapp/services/auth.dart';
import 'package:carpoolapp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carpoolapp/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

import 'settings_form.dart';

class profileTab extends StatefulWidget {
  @override
  _profileTabState createState() => _profileTabState();
}

class _profileTabState extends State<profileTab> {

  final AuthService _auth = AuthService();

  User user = FirebaseAuth.instance.currentUser;
  String _image;

  Reference picRef = FirebaseStorage.instance.ref().child(FirebaseAuth.instance.currentUser.uid);

  Future<Widget> getProfilePic(String path) async {
    await picRef.getDownloadURL().then((fileURL){
      print("set hone wala");
      DatabaseService(uid: user.uid).updateImagePath(fileURL);
      print("set hogaya");
      if(_image != fileURL || _image == null) {
        setState(() {
          _image = fileURL;
        });
      }
    });
  }

  void _showSettingsPanel(){
    showModalBottomSheet(context: context, builder: (context){
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
        child: SettingsForm(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.active){
          getProfilePic(snapshot.data.data()['path']);
          return Scaffold(
            backgroundColor: Colors.orangeAccent[100],
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/profile_background3.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
              child: ListView(
                  children: <Widget>[
                    SizedBox(height: 100.0,),
                    CircleAvatar(
                      radius: 100.0,
                      backgroundColor: Colors.deepOrangeAccent,
                      child: ClipOval(
                        child: SizedBox(
                          width: 180.0,
                          height: 180.0,
                          child: (_image == null) ? Image.asset("images/avatar.png",fit: BoxFit.contain,) : (snapshot.data.data()['path'] == null) ? Loading() : Image.network(snapshot.data.data()['path'],fit: BoxFit.cover,),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0,),
                    Center(child: Text("Name: " + snapshot.data.data()['name'],textScaleFactor: 3.0, style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                    SizedBox(height: 20,),
                    FractionallySizedBox(
                      widthFactor: 0.3,
                      child: FlatButton.icon(
                        color: Colors.blue,
                        icon: Icon(Icons.settings),
                        label: Text('Settings',  style: TextStyle(color: Colors.white)),
                        onPressed: () => _showSettingsPanel(),
                      ),
                    ),
                    SizedBox(height: 10,),
                    FractionallySizedBox(
                      widthFactor: 0.3,
                      child: RaisedButton(
                        color: Colors.red,
                          onPressed: () async {
                            await _auth.signOutUser();
                          },
                          child: Text('logout', style: TextStyle(color: Colors.white))),
                    ),
                  ]
              ),
            ),
          );
        }
        else {
          return Loading();
        }
      },
    );
  }
}