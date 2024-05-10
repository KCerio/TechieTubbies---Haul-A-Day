import 'package:cloud_firestore/cloud_firestore.dart';

class LoadingDelivery {
  final String loadingId;
  String deliveryStatus;
  final String cargoType;
  final String loadingLocation;
  final Timestamp loadingTimeDate;
  final int totalCartons;
  final String warehouse;

  LoadingDelivery({
    required this.loadingId,
    required this.deliveryStatus,
    required this.cargoType,
    required this.loadingLocation,
    required this.loadingTimeDate,
    required this.totalCartons,
    required this.warehouse,

  });

}

class UnloadingDelivery{
  final String unloadingId;
  String deliveryStatus;
  final String recipient;
  final String unloadingLocation;
  final Timestamp unloadingTimeDate;
  final int quantity;
  final int weight;
  final int referenceNum;

  UnloadingDelivery({
    required this.unloadingId,
    required this.deliveryStatus,
    required this.recipient,
    required this.unloadingLocation,
    required this.unloadingTimeDate,
    required this.quantity,
    required this.weight,
    required this.referenceNum});

  factory UnloadingDelivery.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UnloadingDelivery(
      unloadingId: doc.id,
      deliveryStatus: data['deliveryStatus'] ?? '',
      recipient: data['recipient'] ?? '',
      unloadingLocation: data['unloadingLocation'] ?? '',
      unloadingTimeDate: data['unloadingTimestamp']??'',
      quantity: data['quantity'] ?? 0,
      weight: data['weight'] ?? 0,
      referenceNum: data['reference_num'] ?? 0,
    );
  }


}

// Retrieving loading deliveries
Future<LoadingDelivery?> retrieveLoadingDelivery(String userAssignedSchedule) async {
  QuerySnapshot loadSnapshot = await FirebaseFirestore.instance
      .collection('Order')
      .doc(userAssignedSchedule) // Access the specific order document
      .collection('LoadingSchedule')
      .get();

  if (loadSnapshot.docs.isNotEmpty) {
    // Assuming there's only one document, retrieve the first one
    DocumentSnapshot firstDocument = loadSnapshot.docs.first;
    return LoadingDelivery(
      loadingId: firstDocument.id,
      deliveryStatus: firstDocument['deliveryStatus'] ?? '',
      cargoType: firstDocument['cargoType'] ?? '',
      loadingLocation: firstDocument['loadingLocation'] ?? '',
      loadingTimeDate: firstDocument['loadingTime_Date'] ?? '',
      totalCartons: firstDocument['totalCartons'] ?? 0,
      warehouse: firstDocument['warehouse'] ?? '',
    );
  } else {
    // If there are no documents, return null
    return null;
  }
}

// Retrieving unloading deliveries
Future<List<UnloadingDelivery>> retrieveUnloadingDeliveries(String userAssignedSchedule, String loadingId) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Order')
      .doc(userAssignedSchedule)
      .collection('LoadingSchedule')
      .doc(loadingId)
      .collection('UnloadingSchedule')
      .get();

  List<UnloadingDelivery> unloadingDeliveries = [];

  if (querySnapshot.docs.isNotEmpty) {
    // Map the documents to UnloadingDelivery objects and add them to the list
    unloadingDeliveries = querySnapshot.docs
        .map((doc) => UnloadingDelivery.fromSnapshot(doc))
        .toList();
  }

  return unloadingDeliveries;
}

//Retrieve number of completed deliveries for the counter
Future<int> retrieveDelivered(String userAssignedSchedule) async {
  LoadingDelivery? loadingDelivery;
  List<UnloadingDelivery> unloadingDeliveries;

  loadingDelivery = await retrieveLoadingDelivery(userAssignedSchedule);
  unloadingDeliveries = await retrieveUnloadingDeliveries(userAssignedSchedule, loadingDelivery!.loadingId);

  //Check number of done deliveries
  int loadedDelivery = (loadingDelivery?.deliveryStatus=="Loaded!")?1:0;
  int totalUndelivered = unloadingDeliveries
      .where((delivery) => delivery.deliveryStatus == 'Delivered!')
      .length;



  return loadedDelivery + totalUndelivered;

}

//Retrieve single Unloading
Future<UnloadingDelivery?> retrieveUnloadingDelivery(String orderId, String deliveryId) async {
  String loadingId = getLoading(deliveryId);

  DocumentSnapshot unloadingSnapshot = await FirebaseFirestore.instance
      .collection('Order')
      .doc(orderId)
      .collection('LoadingSchedule')
      .doc(loadingId)
      .collection('UnloadingSchedule')
      .doc(deliveryId)
      .get();

  if (unloadingSnapshot.exists) {
    return UnloadingDelivery(
      unloadingId: unloadingSnapshot.id,
      deliveryStatus: unloadingSnapshot['deliveryStatus'] ?? '',
      recipient: unloadingSnapshot['recipient'] ?? '',
      unloadingLocation: unloadingSnapshot['unloadingLocation'] ?? '',
      unloadingTimeDate: unloadingSnapshot['unloadingTimestamp']??'',
      quantity: unloadingSnapshot['quantity'] ?? 0,
      weight: unloadingSnapshot['weight'] ?? 0,
      referenceNum: unloadingSnapshot['reference_num'] ?? 0,
    );
  }

  // If the document does not exist or data is null, return null
  return null;
}

String getLoading(String unloadingId){
  List<String> parts = unloadingId.split("-");
  String extractedNumber = parts[1];
  String loadingId = 'LS-$extractedNumber';

  return loadingId;
}

Future<void> haltStatus(String orderId) async {
  LoadingDelivery? loadingDelivery = await retrieveLoadingDelivery(orderId);
  List<UnloadingDelivery> unloadingDeliveries = await retrieveUnloadingDeliveries(orderId, loadingDelivery!.loadingId);

  if(loadingDelivery.deliveryStatus!="Loaded!"){
    //change the loadingDeliveryStatus in the Firebase

    final documentReference = FirebaseFirestore.instance
        .collection('Order')
        .doc(orderId)
        .collection('LoadingSchedule')
        .doc(loadingDelivery.loadingId);

    await documentReference.update({'deliveryStatus': 'Halted'});


  }

  for (UnloadingDelivery unloadingDelivery in unloadingDeliveries) {
    if (unloadingDelivery.deliveryStatus != "Delivered!") {

      final documentReference = FirebaseFirestore.instance
          .collection('Order')
          .doc(orderId)
          .collection('LoadingSchedule')
          .doc(loadingDelivery.loadingId)
          .collection('UnloadingSchedule')
          .doc(unloadingDelivery.unloadingId);


      await documentReference.update({'deliveryStatus': 'Halted'});

    }

  }



}

Future<String> getOnRouteDelivery(String orderId) async {
  try {
    LoadingDelivery? loadingDelivery = await retrieveLoadingDelivery(orderId);

    if (loadingDelivery != null && loadingDelivery.deliveryStatus == "On Route") {
      return loadingDelivery.loadingId;
    } else {
      List<UnloadingDelivery> unloadingDeliveries = await retrieveUnloadingDeliveries(orderId, loadingDelivery!.loadingId);
      for (UnloadingDelivery unloadingDelivery in unloadingDeliveries) {
        if (unloadingDelivery.deliveryStatus == "On Route") {
          return unloadingDelivery.unloadingId;
        }
      }
    }
  } catch (e) {
    // Handle any errors that occur during the retrieval process

    return "none"; // Return null to indicate failure
  }

  return "none"; // Return null if no delivery is found on route
}