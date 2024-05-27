import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool astatus = false;

  Future<Map<String, dynamic>> fetchUserDetails(String staffId) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('Users').doc(staffId).get();

      if (userSnapshot.exists) {
        return userSnapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception('user with ID $staffId not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch user details: $e');
    }
  }
  
  Future<Map<String, dynamic>> fetchOrderDetails(String orderId) async {
    Map<String, dynamic> order = {};
    try {
      // Retrieve order details from Firestore
      DocumentSnapshot orderSnapshot =
          await _firestore.collection('Order').doc(orderId).get();

      if (orderSnapshot.exists) {
        Map<String, dynamic> orderData = orderSnapshot.data() as Map<String, dynamic>;
        order.addAll(orderData); // Use addAll to merge maps
      } else {
        throw Exception('Order with ID $orderId not found');
      }

      // Fetch loading schedule
      Map<String, dynamic> loadingData = await fetchLoadingSchedule(orderId);
      order.addAll(loadingData); // Use addAll to merge maps
    } catch (e) {
      throw Exception('Failed to fetch order details: $e');
    }
    return order;
  }

  Future<Map<String, dynamic>> fetchLoadingSchedule(String orderId) async {
    try {
      QuerySnapshot scheduleSnapshot = await _firestore
          .collection('Order')
          .doc(orderId)
          .collection('LoadingSchedule')
          .limit(1)
          .get();

      if (scheduleSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> loadingSchedule =
            scheduleSnapshot.docs.first.data() as Map<String, dynamic>;
        //format date    
        var date = loadingSchedule['loadingTime_Date'].toDate();
        var loadDate = DateFormat('MMM dd, yyyy').format(date);
        var loadTime = DateFormat('HH:mm a').format(date);
        var loadID = scheduleSnapshot.docs.first.id;
        loadingSchedule['id'] = loadID;
        loadingSchedule['time'] = loadTime;
        loadingSchedule['date'] = loadDate;
        return loadingSchedule;
      } else {
        throw Exception('Loading schedule not found for order with ID $orderId');
      }
    } catch (e) {
      throw Exception('Failed to fetch loading schedule: $e');
    }
  }
 
  
  Future<bool> getDeliveryStatus(String orderId)async{
    bool status = false;

      // Fetch the 'truckTeam' collection for the current order
      QuerySnapshot statusQuery = await _firestore.collection('Order').doc(orderId).collection('truckTeam').get();
      if (statusQuery.docs.isNotEmpty) {
        status = true; // Assigned
      } else {
        status = false; // Not Assigned
      }
    
    
    return status;
  }

  Future<String> getAssignedTruck(String orderId) async {
    String truckId = '';

    DocumentReference orderRef = _firestore.collection('Order').doc(orderId);
    DocumentSnapshot orderSnapshot = await orderRef.get();

    if (orderSnapshot.exists) {
      Map<String, dynamic> orderData = orderSnapshot.data() as Map<String, dynamic>;
      truckId = orderData['assignedTruck'];
    }

    return truckId;
  }


  Future<List<String>> getAvailableTruckDocumentIds(String cargoType) async {
    List<String> trucks = [];
    try {
      if (cargoType == 'fgl'){
        QuerySnapshot snapshot = await _firestore
          .collection('Trucks')
          .where('truckStatus', isEqualTo: 'Available')
          .where('cargoType', isEqualTo: 'frozen')
          .get();

        List<String> docIds = snapshot.docs.map((doc) => doc.id).toList();
        trucks = docIds;
      }else if (cargoType == 'cgl'){
        QuerySnapshot snapshot = await _firestore
          .collection('Trucks')
          .where('truckStatus', isEqualTo: 'Available')
          .where('cargoType', isEqualTo: 'dry')
          .get();

        List<String> docIds = snapshot.docs.map((doc) => doc.id).toList();
        trucks = docIds;
      }
    } catch (e) {
      throw Exception('Failed to fetch available truck document IDs: $e');
    }
    if  (trucks.isEmpty){
      trucks.add('No Available Trucks');
    }
    return trucks;
  }  

  Future<List<String>> getAvailableCrewIds() async{
    try {
      QuerySnapshot snapshot = await _firestore
        .collection('Users')
        .where('position', isEqualTo: 'Helper')
        .where('assignedSchedule', whereIn: ['None', 'none'])
        .get();


      List<String> helpers = [];
      for (var doc in snapshot.docs) {
        // Check if the "staffId" field exists and is not null
        if (doc['firstname'] != null && doc['lastname'] != null) {
          helpers.add(doc['firstname'] + ' ' + doc['lastname']);
        }
      }

      if(helpers.isEmpty){
      helpers.add('No Available Helpers');
      }else{
        helpers.add('None');
      }

      return helpers;
    } catch (e) {
      throw Exception('Failed to fetch helper staff IDs: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableDrivers() async {
    try {
      QuerySnapshot snapshot = await _firestore
        .collection('Users')
        .where('position', isEqualTo: 'Driver')
        .get();

      
      List<Map<String, dynamic>> drivers = [];
      if(snapshot.docs.isNotEmpty){
        print("snapshot exist");
        for (var doc in snapshot.docs) {
          Map<String, dynamic> driver = {};
          var driverDoc = doc.data();
          if(doc['truck'] == ''){
            if (doc['firstname'] != null && doc['lastname'] != null) {
              driver['name'] = doc['firstname'] + ' ' + doc['lastname'];
            }
            driver['staffId'] = doc['staffId'];
            driver['truck'] = doc['truck'];
            drivers.add(driver); // Add each driver to the list
          }
        }
      }


      // If no drivers were found in either case, add a placeholder driver
      if (drivers.isEmpty) {
        Map<String, dynamic> driver = {};
        driver['name'] = 'No Available drivers';
        drivers.add(driver);
      }

      return drivers;
    } catch (e) {
      throw Exception('Failed to fetch helper staff IDs: $e');
    }
  }


  Future<List<String>> getOrderIdsWithAssignedTruck() async {
    List<String> orderIds = [];

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Order')
          .where('assignedTruck', isNull: false)
          .get();

      querySnapshot.docs.forEach((doc) {
        orderIds.add(doc.id);
      });

      return orderIds;
    } catch (e) {
      print('Error retrieving order IDs: $e');
      return [];
    }
  }


  Future<bool> assignSchedule(String orderId, String truck, String crew1, String crew2)async{
    bool status = false;
    try{
      status = true;
      DateTime timestamp = DateTime.now();
      String timestampString = timestamp.toIso8601String(); // Convert DateTime to string
      //Update AssignedTruck
      await _firestore.collection('Order').doc(orderId).set(
        {
          'assignedTruck': truck,
          'assignedTimestamp' : timestampString,
        },
        SetOptions(merge: true), // Merge with existing fields
      );

      //Update Truck Status
      await _firestore.collection('Trucks').doc(truck).set(
        {
          'truckStatus': "Busy",
        },
        SetOptions(merge: true), // Merge with existing fields
      );

      

      DocumentSnapshot truckDoc = await _firestore.collection('Trucks').doc(truck).get();
      if(truckDoc.exists){
        var truckData = truckDoc.data() as Map<String, dynamic>; // Explicit cast to Map<String, dynamic>
        var driver = truckData['driver']; 
        DocumentSnapshot driverDoc = await _firestore
            .collection('Users')
            .where('staffId', isEqualTo: driver)
            .limit(1)
            .get()
            .then((querySnapshot) => querySnapshot.docs.first);
        
        // Check if driverDoc exists before proceeding
        if (driverDoc.exists) {
          // create assignedSchedule in users 
          await _firestore.collection('Users').doc(driverDoc.id).set(
            {
              'assignedSchedule': orderId,
            },
            SetOptions(merge: true), // Merge with existing fields
          );

          var driverData = driverDoc.data() as Map<String,dynamic>;
          String name = driverData['firstname'] + ' ' + driverData['lastname'];

          await _firestore
            .collection('Order')
            .doc(orderId)
            .collection('truckTeam')
            .doc(driver)
            .set({'crewId': name});
        }
      }
      

      // Update assignedTruck and deliveryStatus in LoadingSchedule collection
      QuerySnapshot loadingSnapshot = await _firestore
          .collection('Order')
          .doc(orderId)
          .collection('LoadingSchedule')
          .get();

      for (DocumentSnapshot doc in loadingSnapshot.docs) {
        await doc.reference.update({
          'deliveryStatus': 'On Route',
        });
      }

      // Update deliveryStatus in UnloadingSchedule collection
      final snapshot = await _firestore
          .collection('Order')
          .doc(orderId)
          .collection('LoadingSchedule')
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final firstDocument = snapshot.docs.first;
        final loadingScheduleCollection =
            firstDocument.reference.collection('UnloadingSchedule');        
        final loadingScheduleSnapshot = await loadingScheduleCollection.get();

        loadingScheduleSnapshot.docs.forEach((document) async{
          await document.reference.update({'deliveryStatus': 'On Queue'});
        });
      }

      // Create truckTeam collection and add crew documents if crew1 or crew2 is not 'None'
      if (crew1 != 'None') {
        // Split crew1 name into first name and last name
        List<String> crew1Parts = crew1.split(' ');
        String crew1FirstName = crew1Parts[0];
        String crew1LastName = crew1Parts.length > 1 ? crew1Parts[1] : '';

        // Get crew1's document ID from the Users collection
        DocumentSnapshot crew1Doc = await _firestore
            .collection('Users')
            .where('firstname', isEqualTo: crew1FirstName)
            .where('lastname', isEqualTo: crew1LastName)
            .limit(1)
            .get()
            .then((querySnapshot) => querySnapshot.docs.first);
        
        // create assignedSchedule in users 
         await _firestore.collection('Users').doc(crew1Doc.id).set(
          {
            'assignedSchedule': orderId,
          },
          SetOptions(merge: true), // Merge with existing fields
        );


        String crew1StaffId = crew1Doc['staffId'];

        // Create document in truckTeam collection using crew1's staffId
        await _firestore
            .collection('Order')
            .doc(orderId)
            .collection('truckTeam')
            .doc(crew1StaffId)
            .set({'crewId': crew1});
      }

      if (crew2 != 'None') {
        // Split crew2 name into first name and last name
        List<String> crew2Parts = crew2.split(' ');
        String crew2FirstName = crew2Parts[0];
        String crew2LastName = crew2Parts.length > 1 ? crew2Parts[1] : '';

        // Get crew2's document ID from the Users collection
        DocumentSnapshot crew2Doc = await _firestore
            .collection('Users')
            .where('firstname', isEqualTo: crew2FirstName)
            .where('lastname', isEqualTo: crew2LastName)
            .limit(1)
            .get()
            .then((querySnapshot) => querySnapshot.docs.first);

        // create assignedSchedule in users 
         await _firestore.collection('Users').doc(crew2Doc.id).set(
          {
            'assignedSchedule': orderId,
          },
          SetOptions(merge: true), // Merge with existing fields
        );
        
        String crew2StaffId = crew2Doc['staffId'];

        // Create document in truckTeam collection using crew2's staffId
        await _firestore
            .collection('Order')
            .doc(orderId)
            .collection('truckTeam')
            .doc(crew2StaffId)
            .set({'crewId': crew2});
      }
      status = false;
      return status;
    }catch (error) {
      print('Error updating document: $error');
      status = false;
      return status;      
    }
  }

  void addTruck(
    String truckId, 
    String cargotype,
    String driver,
    int maxCapacity,
    String truckPic,
    String truckType
    )async{
      //int max = maxCapacity.toInt();
      // Create document in truckTeam collection using crew1's staffId
      if(driver == 'No Available drivers' || driver == 'None'){
          await _firestore
        .collection('Trucks')
        .doc(truckId).set({
          'cargoType' : cargotype,
          "driver" : 'none',
          "maxCapacity" : maxCapacity,
          "truckPic" : truckPic,
          "truckType": truckType,
          "truckStatus": "Available"
        });
      }else{
          await _firestore
        .collection('Trucks')
        .doc(truckId).set({
          'cargoType' : cargotype,
          "driver" : driver,
          "maxCapacity" : maxCapacity,
          "truckPic" : truckPic,
          "truckType": truckType,
          "truckStatus": "Available"
        });
        // Split crew1 name into first name and last name
        List<String> driverParts = driver.split(' ');
        String driverFirstName = driverParts[0];
        String driverLastName = driverParts.length > 1 ? driverParts[1] : '';

        // Get driver's document ID from the Users collection
        DocumentSnapshot driverDoc = await _firestore
            .collection('Users')
            .where('firstname', isEqualTo: driverFirstName)
            .where('lastname', isEqualTo: driverLastName)
            .limit(1)
            .get()
            .then((querySnapshot) => querySnapshot.docs.first);
        
        // create assignedSchedule in users 
         await _firestore.collection('Users').doc(driverDoc.id).set(
          {
            'truck': truckId,
          },
          SetOptions(merge: true), // Merge with existing fields
        );

      }     
  }

  Future<List<Map<String, dynamic>>> fetchAllTruckList() async {
    try {
      QuerySnapshot truckSnapshots =
          await _firestore.collection('Trucks').get();

      List<Map<String, dynamic>> allTrucks = [];
      for (var truckSnapshot in truckSnapshots.docs) {
        if (truckSnapshot.exists) {
          Map<String, dynamic> truckData = truckSnapshot.data() as Map<String, dynamic>;
          truckData['id'] = truckSnapshot.id; // Include the document ID
          allTrucks.add(truckData);
        }
      }

      return allTrucks;
    } catch (e) {
      throw Exception('Failed to fetch trucks: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchOPStaffList() async {
    try {
      QuerySnapshot userSnapshots = await _firestore
          .collection('Users')
          .where('position', whereIn: ['Driver', 'Helper'])
          .get();

      List<Map<String, dynamic>> users = [];
      userSnapshots.docs.forEach((DocumentSnapshot userSnapshot) {
        if (userSnapshot.exists) {
          Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
          userData['id'] = userSnapshot.id; // Include the document ID
          users.add(userData);
        
        }
      });

      return users;
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchManagementStaffList() async {
    try {
      QuerySnapshot userSnapshots = await _firestore
          .collection('Users')
          .where('position', whereNotIn: ['Driver', 'Helper'])
          .get();

      List<Map<String, dynamic>> users = [];
      userSnapshots.docs.forEach((DocumentSnapshot userSnapshot) {
        if (userSnapshot.exists) {
          Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
          userData['id'] = userSnapshot.id; // Include the document ID
          users.add(userData);
        }
      });

      return users;
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }


  Future<List<Map<String, dynamic>>> fetchUnloadingSchedules(String orderID) async {
    try {
      List<Map<String, dynamic>> allUnloading = [];
      final snapshot = await _firestore
          .collection('Order')
          .doc(orderID)
          .collection('LoadingSchedule')
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final firstDocument = snapshot.docs.first;
        //final loadData = firstDocument.data();
        //final cargoType = loadData['cargoType'];

        final loadingScheduleCollection =
            firstDocument.reference.collection('UnloadingSchedule');
        
        final loadingScheduleSnapshot = await loadingScheduleCollection.get();
        loadingScheduleSnapshot.docs.forEach((document) {
          final Map<String, dynamic> unloadData =
              document.data() as Map<String, dynamic>;
          unloadData['unloadId'] = document.id;
          allUnloading.add(unloadData);
        });
      }
      
      return allUnloading;
    } catch (e) {
      throw Exception('Failed to fetch unloadings: $e');
    }
  }

  
  Future<List<Map<String, dynamic>>> fetchAllOrderList() async {
    try {
      QuerySnapshot orderSnapshots = await _firestore.collection('Order').get();

      List<Map<String, dynamic>> allOrders = [];
      for (DocumentSnapshot orderSnapshot in orderSnapshots.docs) {
        if (orderSnapshot.exists) {
          Map<String, dynamic> orderData =
              orderSnapshot.data() as Map<String, dynamic>;
          orderData['id'] = orderSnapshot.id; // Include the document ID
          var filedTimeStamp = orderData['date_filed'].toDate();
          var date_filed = DateFormat('MMM dd, yyyy').format(filedTimeStamp);
          var time_filed = DateFormat('HH:mm a').format(filedTimeStamp);
          orderData['filed_date'] = date_filed; // Include
          orderData['filed_time'] = time_filed; //
          //orderData['confirmedTimestamp'] = ;
          //orderData['assignedTimestamp'] =null;
          bool assignStatus = await getDeliveryStatus(orderSnapshot.id);
          if (assignStatus == true) {
            orderData['assignedStatus'] = 'true';
          } else if (assignStatus == false) {
            orderData['assignedStatus'] = 'false';
          }

          Map<String, dynamic> loadingData = await fetchLoadingSchedule(orderSnapshot.id);
          orderData['cargoType'] = loadingData['cargoType'];
          orderData['loadingStatus'] = loadingData['deliveryStatus'];
          orderData['loadingLocation'] = loadingData['loadingLocation'];
          orderData['loadingTime'] = loadingData['time'];
          orderData['loadingDate']=loadingData['date'];
          orderData['route'] = loadingData['route'];
          orderData['totalCartons'] = loadingData['totalCartons'];
          orderData['warehouse'] = loadingData['warehouse'];

          double weight = 0;
          List<Map<String, dynamic>> unloadingList = await fetchUnloadingSchedules(orderSnapshot.id);
          for (Map<String, dynamic> unloadData in unloadingList){
            weight += unloadData['weight'];
          }
          orderData['totalWeight'] = weight;


          allOrders.add(orderData);
        }
      }

      return allOrders;
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  
  // updating confirmation status
  void updateConfirmValue(bool _confirm, String orderId) async {
    try {
      DateTime timestamp = DateTime.now();
      String timestampString = timestamp.toIso8601String(); // Convert DateTime to string
      // Update the value of a document in Firestore
      // ignore: avoid_single_cascade_in_expression_statements
      _firestore..collection('Order').doc(orderId).update({
        'confirmed_status': _confirm,
        'confirmedTimestamp' : timestampString,
      });

      print('Document successfully updated');
    } catch (error) {
      print('Error updating document: $error');
    }
  }

  Future<List<Map<String,dynamic>>> fetchTruckTeam(String orderId) async {
    try {
      QuerySnapshot crewSnapshots = await _firestore
      .collection('Order')
      .doc(orderId)
      .collection('truckTeam')
      .get();

      List<Map<String,dynamic>> crews = [];
      for (DocumentSnapshot crewSnapshot in crewSnapshots.docs) {
        if (crewSnapshot.exists) {
          Map<String,dynamic> crewInfo = {};
          Map<String,dynamic> data = crewSnapshot.data() as Map<String,dynamic>;
          String crewId = crewSnapshot.id;
          crewInfo['crewId'] = crewId;
          crewInfo['name'] = data['crewId'];

          QuerySnapshot querySnapshot = await _firestore.collection('Users').where('staffId', isEqualTo: crewId).get();
          if (querySnapshot.docs.isNotEmpty){
            Map<String,dynamic> data = querySnapshot.docs.first.data() as Map<String,dynamic>;
            crewInfo['position'] = data['position'];
          }

          crews.add(crewInfo);
        }
      }
      return crews;
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  

  void cancelSchedule(String orderId, String truck)async{
    try{
      //Update AssignedTruck
      await _firestore.collection('Order').doc(orderId).set(
        {
          'assignedTruck': 'None',
          'confirmedTimestamp': null,
          'assignedTimestamp' : null
        },
        SetOptions(merge: true), // Merge with existing fields
      );
      

      //Update Truck Status
      await _firestore.collection('Trucks').doc(truck).set(
        {
          'truckStatus': "Available",
        },
        SetOptions(merge: true), // Merge with existing fields
      );

      DocumentSnapshot truckDoc = await _firestore.collection('Trucks').doc(truck).get();
      if(truckDoc.exists){
        var truckData = truckDoc.data() as Map<String, dynamic>; // Explicit cast to Map<String, dynamic>
        var driver = truckData['driver']; 
        DocumentSnapshot driverDoc = await _firestore
            .collection('Users')
            .where('staffId', isEqualTo: driver)
            .limit(1)
            .get()
            .then((querySnapshot) => querySnapshot.docs.first);
        
        // Check if driverDoc exists before proceeding
        if (driverDoc.exists) {
          // create assignedSchedule in users 
          await _firestore.collection('Users').doc(driverDoc.id).set(
            {
              'assignedSchedule': 'none',
            },
            SetOptions(merge: true), // Merge with existing fields
          );
        }
      }

      // Update assignedTruck and deliveryStatus in LoadingSchedule collection
      QuerySnapshot loadingSnapshot = await _firestore
          .collection('Order')
          .doc(orderId)
          .collection('LoadingSchedule')
          .get();

      for (DocumentSnapshot doc in loadingSnapshot.docs) {
        await doc.reference.update({
          'deliveryStatus': '',
        });
      }

      // Update deliveryStatus in UnloadingSchedule collection
      QuerySnapshot unloadingSnapshot = await _firestore
          .collection('Order')
          .doc(orderId)
          .collection('LoadingSchedule')
          .doc(orderId)
          .collection('UnloadingSchedule')
          .get();

      for (QueryDocumentSnapshot doc in unloadingSnapshot.docs) {
        await doc.reference.update({'deliveryStatus': ''});
      }

      List<Map<String,dynamic>> crews = await fetchTruckTeam(orderId);
      for(Map<String,dynamic> crew in crews){
        QuerySnapshot querySnapshot = await _firestore.collection('Users').where('staffId', isEqualTo: crew['crewId']).get();

        // Loop through the documents returned by the query
        querySnapshot.docs.forEach((doc) {
          // Get the document reference
          DocumentReference docRef = _firestore.collection('Users').doc(doc.id);

          // Update the document
          docRef.set(
            {
              'assignedSchedule': 'none',
            },
            SetOptions(merge: true), // Merge with existing fields
          );
        });
      }

        final CollectionReference collectionReference =
        _firestore.collection('Order').doc(orderId).collection('truckTeam');

        // Query for documents in the collection
        final QuerySnapshot snapshot = await collectionReference.get();

        // Create a new batch
        WriteBatch batch = FirebaseFirestore.instance.batch();

        // Add delete operations for each document to the batch
        snapshot.docs.forEach((doc) {
          batch.delete(doc.reference);
        });

        // Commit the batched delete operations
        await batch.commit();     
      
    }catch (error) {
      print('Error updating document: $error');
    }
  }

  Future<List<Map<String,dynamic>>> fetchDeliveryReports(String orderId) async {
    try {
      QuerySnapshot reportSnapshots= await _firestore
      .collection('Order')
      .doc(orderId)
      .collection('Delivery Reports')
      .get();

      List<Map<String, dynamic>> allReports = [];
      reportSnapshots.docs.forEach((DocumentSnapshot reportSnapshot) {
        if (reportSnapshot.exists) {
          Map<String, dynamic> reportData = reportSnapshot.data() as Map<String, dynamic>;
          reportData['id'] = reportSnapshot.id; // Include the document ID
          allReports.add(reportData);
        }
        
      });

      return allReports;
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAttendance(String reportId, String orderId, String truck) async {
  try {
    QuerySnapshot attendanceSnapshots = await _firestore
        .collection('Order')
        .doc(orderId)
        .collection('Delivery Reports')
        .doc(reportId)
        .collection('Attendance')
        .get();

    List<Map<String, dynamic>> attendance = [];

    for (DocumentSnapshot attendanceSnapshot in attendanceSnapshots.docs) {
      if (attendanceSnapshot.exists) {
        var staffId = attendanceSnapshot.id; // Include the document ID

        Map<String, dynamic> crewInfo = {};
        QuerySnapshot querySnapshot = await _firestore.collection('Users').where('staffId', isEqualTo: staffId).get();
        querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            var crewData = documentSnapshot.data() as Map<String, dynamic>; // Cast to the appropriate type
            crewInfo['name'] = (crewData['firstname'] ?? '') + ' ' + (crewData['lastname'] ?? '');
            crewInfo['position'] = crewData['position'];
            crewInfo['pictureUrl'] = crewData['pictureUrl'];
          }
        });
        attendance.add(crewInfo);
      }
    }

    

    return attendance;
  } catch (e) {
    throw Exception('Failed to fetch attendance: $e');
  }
}

}


