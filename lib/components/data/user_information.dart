//getting user schedule
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountInfo {
  final String pictureUrl;
  final String staffID;
  final String fullName;
  final String position;
  final String registeredDate;
  final String contactNumber;

  AccountInfo({
    required this.pictureUrl,
    required this.staffID,
    required this.fullName,
    required this.position,
    required this.registeredDate,
    required this.contactNumber,
  });
}

Future<AccountInfo> getUserDetails(String staffId) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Users')
      .where('staffId', isEqualTo: staffId)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    final firstName = querySnapshot.docs.first['firstname'];
    final lastName = querySnapshot.docs.first['lastname'];
    final fullName = '$firstName $lastName';
    final position = querySnapshot.docs.first['position'];
    final staffID = querySnapshot.docs.first['staffId'];
    final registeredDate = querySnapshot.docs.first['registeredDate'];
    final contactNumber = querySnapshot.docs.first['contactNumber'];
    final pictureUrl = querySnapshot.docs.first['pictureUrl'];;

    return AccountInfo(
      pictureUrl: pictureUrl,
      staffID: staffID,
      fullName: fullName,
      position: position,
      registeredDate: registeredDate,
      contactNumber: contactNumber,
    );
  } else {
    throw Exception('No user found with staff ID: $staffId');
  }
}

Future<String> getSchedule(String staffId) async {
  String userAssignedSchedule = '';

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Users')
      .where('staffId', isEqualTo: staffId)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    // Retrieve the schedule from the document
    userAssignedSchedule = querySnapshot.docs.first['assignedSchedule'];


  }

  return userAssignedSchedule;
}

Future<String> getFirstName(String staffId)async{
  String firstName = '';

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Users')
      .where('staffId', isEqualTo: staffId)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    // Retrieve the firstName from the document
    firstName = querySnapshot.docs.first['firstname'];
  }
  return firstName;
}

Future<String> getPosition(String staffId)async{
  String position = '';

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Users')
      .where('staffId', isEqualTo: staffId)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    // Retrieve the firstName from the document
    position = querySnapshot.docs.first['position'];
  }
  return position;
}