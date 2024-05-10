import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AccomplishedDelivery {
  final String orderId;
  final Timestamp dateCompleted;
  final List<Delivery> deliveries;
  bool isSelected;

  AccomplishedDelivery(this.orderId, this.dateCompleted, this.deliveries, this.isSelected){

  }

  static AccomplishedDelivery noAccomplishedDelivery() {
    return AccomplishedDelivery(
      "null",
      Timestamp.now(), // Set a placeholder date or any default value
      [], // An empty list of deliveries
      false, // isSelected set to false
    );
  }
}

class Delivery{
  final String deliveryId;
  final bool hasDelivered;
  final Timestamp dateCompleted;

  Delivery(this.deliveryId, this.hasDelivered, this.dateCompleted){

  }
}

Future<List<AccomplishedDelivery>> retrieveAccomplishedDeliveries(String staffId) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('staffId', isEqualTo: staffId)
        .get();

    List<AccomplishedDelivery> accomplishedList = [];

    if (querySnapshot.size >= 1) {
      DocumentSnapshot userDoc = querySnapshot.docs.first;

      // Fetch the 'Accomplished Deliveries' subcollection
      QuerySnapshot accomplishedDeliveriesSnapshot = await userDoc.reference
          .collection('Accomplished Deliveries')
          .get();

      if(accomplishedDeliveriesSnapshot.docs.isEmpty){
        return [AccomplishedDelivery.noAccomplishedDelivery()];
      }else{
        for (QueryDocumentSnapshot doc in accomplishedDeliveriesSnapshot.docs) {
          String orderId = doc.id;

          List<Delivery> deliveries = await fetchDeliveryIds(orderId, staffId);

          Timestamp dateCompleted = deliveries.last.dateCompleted;

          AccomplishedDelivery accomplishedDelivery = AccomplishedDelivery(orderId, dateCompleted, deliveries,false);


          bool isPresent = isPresentInAtLeastOne(accomplishedDelivery.deliveries);

          if(accomplishedDelivery.deliveries.length!=0&&isPresent)
            accomplishedList.add(accomplishedDelivery);


        }
      }


      // Iterate through each document in the subcollection

    }

    return accomplishedList;
  } catch (e) {
    print('Error retrieving accomplished deliveries: $e');
    return [];
  }
}

bool isPresentInAtLeastOne(List<Delivery> deliveries){
  for (Delivery delivery in deliveries) {
    if (delivery.hasDelivered) {
      return true;
    }
  }
  return false;
}

Future<List<Delivery>> fetchDeliveryIds(String orderId, String staffId) async {
  List<Delivery> deliveryList = [];

  try {
    // Fetch documents from the 'Delivery Reports' subcollection under the specified orderId
    QuerySnapshot deliveryReportsSnapshot = await FirebaseFirestore.instance
        .collection('Order/$orderId/Delivery Reports')
        .get();

    // Use for loop to iterate over documents
    for (DocumentSnapshot doc in deliveryReportsSnapshot.docs) {
      // Extract document ID
      String docId = doc.id;

      // Extract field 'hasDelivered' and 'dateCompleted'
      bool isPresent = await checkAttendance(docId, orderId, staffId);
      bool isSuccessful = doc['isSuccessful'];
      Timestamp dateCompleted = isSuccessful?doc['departureTimeDate']:doc['TimeDate'];

      // Create a Delivery object and add it to the list
      Delivery delivery = Delivery(docId, isPresent, dateCompleted);

      print("Deliver: ${delivery.deliveryId}, ${delivery.hasDelivered}, ${delivery.dateCompleted}");

      if(isSuccessful)
        deliveryList.add(delivery);
    }
  } catch (e) {
    print('Error fetching delivery IDs: $e');
  }

  return deliveryList;
}


Future<bool> checkAttendance (String deliveryId, String orderId, String staffId) async{
  List<String> attendance = [];
  try {
    // Fetch documents from the 'Attendance' subcollection under the specified delivery ID
    QuerySnapshot attendanceSnapshot = await FirebaseFirestore.instance
        .collection('Order/$orderId/Delivery Reports/$deliveryId/Attendance')
        .get();

    // Extract staff IDs from the fetched documents
    List<String> attendance = attendanceSnapshot.docs.map((doc) => doc.id).toList();

    // Check if your staff ID is present in the attendance records
    return attendance.contains(staffId);
  } catch (e) {
    print('Error checking attendance: $e');
    return false; // Return false in case of any error
  }

}

