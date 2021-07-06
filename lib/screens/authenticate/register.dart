import 'package:flutter/material.dart';
import 'package:carpoolapp/services/auth.dart';
import 'package:carpoolapp/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'verify.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String name = '';
  String phone = '';
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 150.0,horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Image.asset('images/AppLogo.png', fit: BoxFit.contain, scale: 2.0,),
                  SizedBox(height: 40.0),
                  TextFormField(
                    validator: (val)  => val.length < 3 ? 'Name must be atleast 3 characters long' : null,
                    cursorColor: Colors.redAccent,
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
                        contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                        hintText: "Enter your Name",
                        hintStyle: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic)
                    ),
                    onChanged: (val){
                      setState(() => name = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    validator: (val)  => val.length != 10 ? 'Number must be 10 digits long' : null,
                    cursorColor: Colors.redAccent,
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
                        contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                        hintText: "Enter your Phone Number e.g. 317xxxxxx1",
                        hintStyle: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic)
                    ),
                    onChanged: (val){
                      setState(() => phone = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    validator: (val)  => val.isEmpty ? 'Enter an email' : null,
                    cursorColor: Colors.redAccent,
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
                        contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                        hintText: "Enter your E-mail",
                        hintStyle: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic)
                    ),
                    onChanged: (val){
                      setState(() => email = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    validator: (val)  => val.isEmpty ? 'Enter a password' : null,
                    cursorColor: Colors.redAccent,
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
                        contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                        hintText: "Enter a Password",
                        hintStyle: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic)
                    ),
                    obscureText: true,
                    onChanged: (val){
                      setState(() => password = val);
                    },
                  ),
                  SizedBox(height: 20.0,),
                  RaisedButton(
                    color: Colors.deepOrange,
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState.validate()){
                        setState(() => loading = true);
                        dynamic result = await _auth.registerWithEmailAndPassword(email, password, name, phone);
                        if(result == null){
                          setState(() => loading = false);
                          setState(() => error = 'please use valid details');
                        }
                      }
                    },
                  ),
                  SizedBox(height: 12.0,),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                  FlatButton.icon(onPressed: () => widget.toggleView(), icon: Icon(Icons.person), label: Text('Already have an account?')),
                ],
              ),
            )//symmetric padding
        ),
      ),
    );
  }
}