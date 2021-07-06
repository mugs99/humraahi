import 'package:carpoolapp/models/user.dart';
import 'package:carpoolapp/screens/authenticate/authenticate.dart';
import 'package:carpoolapp/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authenticate/verify.dart';
import 'authenticate/verifyPhone.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // accessing user data from provider everytime we get a new value
    final user = Provider.of<AppUser>(context);

    //user not signed in
    if(user == null){
      return Authenticate();
    }else{
      return VerifyPhone();
    }
  }
}
