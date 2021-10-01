import 'package:PhilosophyToday/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'dataManager.dart';

final FirebaseAnalytics _analytics = FirebaseAnalytics();
class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // create user object based on firebase user
  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }
  // auth change user stream
  Stream<User> get user{
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }
  // sign in anon
  Future signInAnon() async{
    try{
      AuthResult result = await FirebaseAuth.instance.signInAnonymously();
      FirebaseUser user = result.user;
      _analytics.logSignUp(signUpMethod: "Signed In anonymous");
      return _userFromFirebaseUser(user);
    }catch(e){
      return null;
    }
  }

  //sign in with google sign in
  Future googleSignIn() async{
    try{
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken:googleAuth.accessToken,
        idToken:googleAuth.idToken,
      );
      final AuthResult result = await _auth.signInWithCredential(credential);
      final FirebaseUser user = result.user;
      await saveUserData(user);
      _analytics.logLogin(loginMethod: "Login by google");
      return _userFromFirebaseUser(user);
    }catch(e){
      debugPrint(e);
      return null;
    }
  }

  //sign in with email password
  Future signInWithEmailAndPassword(String email,String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      _analytics.logLogin(loginMethod: "Login by email and password");
      return _userFromFirebaseUser(user);
    }catch(e){
      return null;
    }
  }

  //register
  Future registerWithEmailAndPassword(String email,String password) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      _analytics.logSignUp(signUpMethod: "Signed up  with email and password");
      return _userFromFirebaseUser(user);
    }catch(e){
      return null;
    }
  }
  //sign out
  Future signOut() async{
    try{
      _analytics.logSignUp(signUpMethod: "Signing out");
      return await _auth.signOut();
    } catch(e){
      return null;
    }
  }
}