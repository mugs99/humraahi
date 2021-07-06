import 'dart:io';
import 'package:carpoolapp/models/user.dart';
import 'package:carpoolapp/services/database.dart';
import 'package:carpoolapp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();

  // form values
  String _currentName;
  File _image;

  Future getImage() async{
    PickedFile image = await ImagePicker().getImage(source:ImageSource.gallery);
    setState(() {
      _image = File(image.path);
      print('Image Path $_image');
    });
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {

          UserData userData = snapshot.data;
          bool _updated = true;
          String _textHolder = 'sa';

          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Update Profile Settings',
                  style: TextStyle(fontSize: 15.0),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  initialValue: userData.name,
                  validator: (val) =>
                  val.isEmpty
                      ? 'Please enter a name'
                      : val.length<3 ? 'Name must be atleast 3 characters long' : null,
                  onChanged: (val) => setState(() {_currentName = val; _updated = false;}),
                  decoration: new InputDecoration(
                      fillColor: Colors.lightBlueAccent,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none
                        ),
                      ),
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Enter new name",
                      hintStyle: TextStyle(
                          color: Colors.white70, fontStyle: FontStyle.italic)
                  ),
                ),
                SizedBox(height: 20.0),
                CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Colors.deepOrangeAccent,
                  child: GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: ClipOval(
                      child: SizedBox(
                      width: 180.0,
                      height: 180.0,
                        child: (_image != null) ? Image.file(_image,fit: BoxFit.cover,) : Image.asset("images/avatar.png",fit: BoxFit.cover,),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                  color: Colors.deepOrange,
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await DatabaseService(uid: user.uid).updateUserData(
                          _currentName ?? userData.name,
                      );
                      await DatabaseService(uid: user.uid).uploadPic(context,_image);
                      await Navigator.pop(context);
                    }
                  }
                ),
              ],
            ),
          );
        } else {
          return Loading();
        }
      }
    );
  }
}
