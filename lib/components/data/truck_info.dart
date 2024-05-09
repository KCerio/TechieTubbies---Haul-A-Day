import 'package:cloud_firestore/cloud_firestore.dart';

class TruckInfo {
  final String cargoType;
  final int maxCapacity;
  String truckStatus;
  final String truckType;
  final String driver;
  final String truckPic;


  TruckInfo({
    required this.cargoType,
    required this.maxCapacity,
    required this.truckStatus,
    required this.truckType,
    required this.driver,
    required this.truckPic,
  });
}

Future<String> getTruckIdByStaffId(String staffId) async {
  String position = '';
  String assignedSchedule='';

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Users')
      .where('staffId', isEqualTo: staffId)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    // Retrieve the position from the document
    position = querySnapshot.docs.first['position'];
  }

  if (position == 'Driver') {
    String truckId;
    try {
      truckId = querySnapshot.docs.first['truck'];
      if(truckId=='')
        truckId = 'no truck';
    } catch (e) {
      truckId = 'no truck';
      print('truckId: ${truckId}');
    }
    return truckId;
  }
  else {
    if (querySnapshot.docs.isNotEmpty) {
      // Retrieve the assignedSchedule from the document
      assignedSchedule = querySnapshot.docs.first['assignedSchedule'];
    }

    if (assignedSchedule == 'none') {
      return "none";
    } else {
      DocumentSnapshot truckQuerySnapshot = await FirebaseFirestore.instance
          .collection('Order')
          .doc(assignedSchedule)
          .get();

      if (truckQuerySnapshot.exists) {
        // Retrieve the assigned truck from the document
        return truckQuerySnapshot['assignedTruck'];
      } else {
        // Handle the case where the document doesn't exist
        throw Exception("Truck document not found for assigned schedule: $assignedSchedule");
      }
    }
  }


}

Future<TruckInfo> getTruckInfoByTruckId(String truckId) async {
  DocumentSnapshot truckSnapshot = await FirebaseFirestore.instance
      .collection('Trucks')
      .doc(truckId)
      .get();

  if (truckSnapshot.exists) {
    // Retrieve truck information from the document
    return TruckInfo(
        cargoType: truckSnapshot['cargoType'],
        maxCapacity: truckSnapshot['maxCapacity'],
        truckStatus: truckSnapshot['truckStatus'],
        truckType: truckSnapshot['truckType'],
        driver: truckSnapshot['driver'],
        truckPic: truckSnapshot['truckPic']
    );
  } else {
    // Handle the case where the document doesn't exist
    throw Exception("Truck document not found for truck ID: $truckId");
  }
}
