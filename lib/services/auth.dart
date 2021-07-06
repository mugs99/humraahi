import 'package:carpoolapp/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on FireBase User
  AppUser _appUser(User user){
    return user != null ? AppUser(uid: user.uid) : null;
  }

  //auth change user stream, tells if user signed in or signed out
  Stream<AppUser> get user {
    return _auth.authStateChanges().map(_appUser);
  }

  //sign in anonimously
Future signInAnon() async{
  try{
    UserCredential result = await _auth.signInAnonymously();
    User user = result.user;
    return _appUser(user);
  }catch(e){
    print(e.toString());
    return null;
  }
}

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user= result.user;
      return _appUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(String email, String password, String name, String phone) async {
    try{

      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user= result.user;
      phone = '+92' + phone.trim();

      await DatabaseService(uid: user.uid).updateUserData(name);
      await DatabaseService(uid: user.uid).updatePhone(phone);
      await DatabaseService(uid: user.uid).updateTripDetails('0', '0', '0', false, '0', '0');
      await DatabaseService(uid: user.uid).updateImagePath('');
      await DatabaseService(uid: user.uid).createMessagesCollection();
      return _appUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }



  //verify the email
  Future verifyEmail(User user) async {
    try{
      if(!user.emailVerified) {
        user.sendEmailVerification();
      }
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign out
Future signOutUser() async{
    try{
      return await _auth.signOut();  //built-in method
    }catch(e){
      print(e.toString());
      return null;
    }
}

}