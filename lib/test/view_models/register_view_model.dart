import 'package:aquabuildr/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier{

  String message = "";
  bool isRegistered = false;

  Future<bool> register(String email, String password) async{

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, 
      password: password);
      isRegistered = userCredential != null;
    } on FirebaseAuthException catch(e){
      if(e.code == "weak-password"){
        message = Constants.WEAK_PASSWORD;
      }else if ( e.code == "email-already-in-use"){
        message = Constants.EMAIL_ALREADY_IN_USE;
      }
      notifyListeners();
    }catch(e){
      print(e);
    }
    return isRegistered;
  }


}