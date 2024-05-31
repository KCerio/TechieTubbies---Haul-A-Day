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

  Future<bool> updateProfile(String staffId, String firstname, String lastname, String email, String contact, String image)async{
    bool updated = false;
    try{
      QuerySnapshot staffQuery = await _firestore
        .collection('Users')
        .where('staffId', isEqualTo: staffId)
        .get();
      
      if(staffQuery.docs.isNotEmpty){
        DocumentReference docRef = staffQuery.docs.first.reference;
        await docRef.update({
          'firstname': firstname,
          'lastname' : lastname,
          'email' : email,
          'contactNumber' : contact,
          'pictureUrl' : image     
        });
        updated = true;
      }

    }catch(e){
      print("Failed to update: $e");
    }
    return updated;
  }


  Future<bool> updatePassword(String newpass, String staffId)async{
    bool updated = false;
    try{
      QuerySnapshot staffQuery = await _firestore
        .collection('Users')
        .where('staffId', isEqualTo: staffId)
        .get();
      if(staffQuery.docs.isNotEmpty){
        DocumentReference docRef = staffQuery.docs.first.reference;
        await docRef.update({
          'password': newpass,
          
        });
        updated = true;
      }
    } catch(e){
      print('Failed to update password: $e');
      
    }
    return updated;
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
        Map<String, dynamic> userData = userDocSnapshot.data() as Map<String, dynamic>;

        // Add the timestamp field
        userData['timestamp'] = timestamp;

        // Create a new document in the 'Archive' collection with the same data
        await FirebaseFirestore.instance.collection('Archive').doc(docName).set(userData);
        
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

  Future<void> removeTruck(String truckId) async {
    try {
      // Get reference to the document in the 'Users' collection
      DocumentReference truckDocRef = FirebaseFirestore.instance.collection('Trucks').doc(truckId);
      
      // Get the document data
      DocumentSnapshot truckDocSnapshot = await truckDocRef.get();
      
      // Check if the document exists
      if (truckDocSnapshot.exists) {
        // Add the document to the 'Archive' collection
        DateTime timestamp = DateTime.now();
        String dateDeleted = DateFormat('MMM dd, yyyy').format(timestamp);
        String docName = '$truckId - $dateDeleted (Trucks)';
        Map<String, dynamic> truckData = truckDocSnapshot.data() as Map<String, dynamic>;

        // Add the timestamp field
        truckData['timestamp'] = timestamp;

        // Create a new document in the 'Archive' collection with the same data
        await FirebaseFirestore.instance.collection('Archive').doc(docName).set(truckData);
        
        // Delete the document from the 'trucks' collection
        await truckDocRef.delete();
        
        print('Document moved to Archive and deleted from Trucks successfully');
      } else {
        print('Document does not exist in Trucks collection');
      }
    } catch (e) {
      // Handle errors
      print('Error moving document to Archive: $e');
    }
  }

  Future<void> removeOrder(String orderId) async {
    try {
      // Get reference to the document in the 'Users' collection
      DocumentReference orderDocRef = FirebaseFirestore.instance.collection('Order').doc(orderId);
      
      // Get the document data
      DocumentSnapshot orderDocSnapshot = await orderDocRef.get();
      
      // Check if the document exists
      if (orderDocSnapshot.exists) {
        // Add the document to the 'Archive' collection
        DateTime timestamp = DateTime.now();
        String dateDeleted = DateFormat('MMM dd, yyyy').format(timestamp);
        String docName = '$orderId - $dateDeleted (Order)';
        Map<String, dynamic> orderData = orderDocSnapshot.data() as Map<String, dynamic>;

        // Add the timestamp field
        orderData['timestamp'] = timestamp;

        // Create a new document in the 'Archive' collection with the same data
        await FirebaseFirestore.instance.collection('Archive').doc(docName).set(orderData);
        
        // Delete the document from the 'orders' collection
        await orderDocRef.delete();
        
        print('Document moved to Archive and deleted from orders successfully');
      } else {
        print('Document does not exist in orders collection');
      }
    } catch (e) {
      // Handle errors
      print('Error moving document to Archive: $e');
    }
  }


}