import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> fetchOrderDetails(String orderId) async {
    try {
      DocumentSnapshot orderSnapshot =
          await _firestore.collection('Order').doc(orderId).get();

      if (orderSnapshot.exists) {
        return orderSnapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception('Order with ID $orderId not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch order details: $e');
    }
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

  Future<List<DataRow>> fetchUnloadingSchedule(String orderId,) async {
    try {
      List<DataRow> rows =[];

    await _firestore
    .collection('Order')
    .doc(orderId)
    .collection('LoadingSchedule')
    .limit(1)
    .get()
    .then((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        var firstDocument = snapshot.docs.first;
        //var loadData = firstDocument.data();
        //var cargoType = loadData['cargoType'];

        var loadingScheduleCollection = firstDocument.reference
            .collection('UnloadingSchedule'); // Accessing the subcollection
        // Now you can work with the "UnloadingSchedule" collection
        loadingScheduleCollection.get().then((snapshot) async {
        for (var document in snapshot.docs) {
          //var unloadId = document.id;
          var unloadData = document.data();
          var recipient = unloadData['recipient'];
          var refNo = unloadData['reference_num'];
          var weight = unloadData['weight'];
          var quantity = unloadData['quantity'];
          var location = unloadData['unloadingLocation'];
          var date = unloadData['unloadingTimestamp'].toDate();
          var unloadDate = DateFormat('MMM dd, yyyy').format(date);
          var time = DateFormat('HH:mm a').format(date);
        print('recipient: '  + recipient);
        // Add a DataRow with the retrieved data
        rows.add(DataRow(cells: [
          DataCell(
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [Text(recipient, textAlign: TextAlign.center,)]
                )
              )
            ),
          DataCell(
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [Text(refNo.toString(), textAlign: TextAlign.center)]
                )
              )
            ),
          
          DataCell(
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [Text(weight.toString(), textAlign: TextAlign.center)]
                )
              )
            ),
            DataCell(
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [Text(quantity.toString(), textAlign: TextAlign.center)]
                )
              )
            ),
            DataCell(
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [Text(location, textAlign: TextAlign.center)]
                )
              )
            ),
            DataCell(
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [Text(unloadDate.toString(), textAlign: TextAlign.center)]
                )
              )
            ),
            DataCell(
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [Text(time.toString(), textAlign: TextAlign.center)]
                )
              )
            ),
        ]
        ));
        
      }});
    }});

    print('rows ' + rows.toString());
    return rows;
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
          .where('assignedSchedule', isEqualTo: 'none')
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


  Future<List<String>> getOrderIdsWithAssignedTruck() async {
    List<String> orderIds = [];

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Order')
          .where('assigned truck', isNull: false)
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

  void assignSchedule(String orderId, String truck, String crew1, String crew2)async{
    try{
      //Update AssignedTruck
      await _firestore.collection('Order').doc(orderId).set(
        {
          'assignedTruck': truck,
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
      QuerySnapshot unloadingSnapshot = await _firestore
          .collection('Order')
          .doc(orderId)
          .collection('LoadingSchedule')
          .doc(orderId)
          .collection('UnloadingSchedule')
          .get();

      for (QueryDocumentSnapshot doc in unloadingSnapshot.docs) {
        await doc.reference.update({'deliveryStatus': 'On Queue'});
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
      
    }catch (error) {
      print('Error updating document: $error');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllTruckList() async {
    try {
      QuerySnapshot truckSnapshots =
          await _firestore.collection('Trucks').get();

      List<Map<String, dynamic>> allTrucks = [];
      truckSnapshots.docs.forEach((DocumentSnapshot truckSnapshot) {
        if (truckSnapshot.exists) {
          Map<String, dynamic> truckData = truckSnapshot.data() as Map<String, dynamic>;
          truckData['id'] = truckSnapshot.id; // Include the document ID
          allTrucks.add(truckData);
        }
      });

      return allTrucks;
    } catch (e) {
      throw Exception('Failed to fetch trucks: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchStaffList() async {
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

  Future<List<Map<String, dynamic>>> fetchUnloadingSchedules(String orderID, String loadID) async {
    try {
      QuerySnapshot unloadingSnapshots =
          await _firestore
          .collection('Order')
          .doc(orderID)
          .collection('LoadingShedule')
          .doc(loadID)
          .collection('UnloadingSchedule')
          .get();

      List<Map<String, dynamic>> allUnloading = [];
      unloadingSnapshots.docs.forEach((DocumentSnapshot unloadingSnapshot) {
        if (unloadingSnapshot.exists) {
          Map<String, dynamic> unloadingData = unloadingSnapshot.data() as Map<String, dynamic>;
          unloadingData['id'] = unloadingSnapshot.id; // Include the document ID
          allUnloading.add(unloadingData);
        }
      });

      return allUnloading;
    } catch (e) {
      throw Exception('Failed to fetch unloadings: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllOrderList() async {
    try {
      QuerySnapshot orderSnapshots =
          await _firestore.collection('Orders').get();

      List<Map<String, dynamic>> allOrders = [];
      orderSnapshots.docs.forEach((DocumentSnapshot orderSnapshot) {
        if (orderSnapshot.exists) {
          Map<String, dynamic> orderData = orderSnapshot.data() as Map<String, dynamic>;
          orderData['id'] = orderSnapshot.id; // Include the document ID
          allOrders.add(orderData);
        }
      });

      return allOrders;
    } catch (e) {
      throw Exception('Failed to fetch trucks: $e');
    }
  }


}
