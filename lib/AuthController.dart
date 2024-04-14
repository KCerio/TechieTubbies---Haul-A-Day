import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haul_a_day_mobile/shared.dart';

import 'main.dart';

class AuthController extends GetxController {
  // Method to log out the user
  Future<void> logout(BuildContext context) async {
    try {
      // Clear login status
      await Shared.saveLoginSharedPreference(false);
      // Clear staff ID
      await Shared.saveStaffId('');
      // Navigate to login screen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
    } catch (e) {
      print("Error logging out: $e");
      // Handle any errors, such as failed to clear data or navigate
    }
  }
}
