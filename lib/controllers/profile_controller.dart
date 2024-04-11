import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haul_a_day_web/repository/user_repository.dart';

class ProfileController extends GetxController{
  static ProfileController get instance => Get.find();

  final _userRepo = Get.put(UserRepository());

  getUserData(String userId){
    //final userID = FirebaseFirestore.instance.collection
    return _userRepo.getUserDetails(userId);
  }
}