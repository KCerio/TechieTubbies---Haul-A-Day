import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haul_a_day_web/models/user_model.dart';

class UserRepository extends GetxController{
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance; 

  // function for creating a new user to the database
  createUser(UserModel user) async{
    await _db.collection("Users").add(user.toJson()).whenComplete(
      () => Get.snackbar("Success", "Account has been created.",  // ignore snackbar since walay snackbar
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green
      )
      
    )
    // ignore: body_might_complete_normally_catch_error
    .catchError((error, StackTrace){
      Get.snackbar("Error", "Something went wrong. Try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red
        );
      print("ERROR - $error");
    });
  }

  // get data of a single user
  Future<UserModel> getUserDetails(String staffId) async{
    final snapshot = await _db.collection("Users").where("staffId", isEqualTo: staffId).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  //get data of all users
  Future<List<UserModel>> allUser() async{
    final snapshot = await _db.collection("Users").get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }

  
}