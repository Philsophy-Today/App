import 'package:PhilosophyToday/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'dataManager.dart';
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
      return _userFromFirebaseUser(user);
    }catch(e){
      return null;
    }
  }
  //sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    } catch(e){
      return null;
    }
  }
}