import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

  void createUser(Map<String, dynamic> newUser)async{
    try {
      DocumentSnapshot staffquery = await _firestore.collection('Users').doc(newUser['id']).get();
      // Handle the document snapshot
      if (staffquery.exists) {
        print('User already exists');
        
      } else {
        DateTime timestamp = DateTime.now();
        print('no document');
        // Set default values and create new document
        await _firestore
            .collection('Users')
            .doc(newUser['id'])
            .set({
              'firstname': newUser['firstname'],
              'lastname': newUser['lastname'], 
              'password': newUser['password'],
              'position' : newUser['position'],
              'userName': newUser['userName'],
              'registeredDate' : timestamp,
              'staffId': newUser['id'],
              'contactNumber' : newUser['contactNumber'],
              'pictureUrl' : newUser['pictureUrl'],
            });
      }
    } catch (e) {
      // Handle errors
      print('Error adding user: $e');
    }
  }

  Future<void> approveAccount(String staffId, String accessKey) async {
    try {
      QuerySnapshot staffQuery = await _firestore
        .collection('Users')
        .where('staffId', isEqualTo: staffId)
        .get();
      
      // Check if any documents match the query
      if (staffQuery.docs.isNotEmpty) {
        // Get the reference for the first document in the query result
        DocumentReference docRef = staffQuery.docs.first.reference;
        DateTime timestamp = DateTime.now();
        
        // Update the document with the new fields
        await docRef.update({
          'accessKey': accessKey,
          'approvedDate': timestamp,
          // Add additional fields here if needed
          // 'fieldName': value,
        });
        
        print('Account approved successfully');
      } else {
        print('No document found matching the query');
      }
    } catch (e) {
      // Handle errors
      print('Error approving account: $e');
    }
  }


  Future<bool> confirmation(String staffId, String password)async {
    bool confirmed = false;
    QuerySnapshot staffIdQuerySnapshot = await _firestore
    .collection('Users')
    .where(FieldPath.documentId, isEqualTo: staffId)
    .where('password', isEqualTo: password)
    .get();

    if (staffIdQuerySnapshot.docs.isNotEmpty){
      confirmed = true;
    }
    return confirmed;
  }

  Future<void> removeAccount(String userId) async {
    try {
      // Get reference to the document in the 'Users' collection
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('Users').doc(userId);
      
      // Get the document data
      DocumentSnapshot userDocSnapshot = await userDocRef.get();
      
      // Check if the document exists
      if (userDocSnapshot.exists) {
        // Add the document to the 'Archive' collection
        DateTime timestamp = DateTime.now();
        String dateDeleted = DateFormat('MMM dd, yyyy').format(timestamp);
        String docName = '$userId - $dateDeleted (Users)';
        await FirebaseFirestore.instance.collection('Archive').doc(docName).set(userDocSnapshot.data() as Map<String, dynamic>);
        
        // Delete the document from the 'Users' collection
        await userDocRef.delete();
        
        print('Document moved to Archive and deleted from Users successfully');
      } else {
        print('Document does not exist in Users collection');
      }
    } catch (e) {
      // Handle errors
      print('Error moving document to Archive: $e');
    }
  }


}