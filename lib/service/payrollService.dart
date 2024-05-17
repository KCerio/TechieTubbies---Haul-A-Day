import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:intl/intl.dart';

class PayrollService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DatabaseService _databaseService = DatabaseService();
  List<String> cebuRoutes = [
    'Tuburan',
    'Bantayan Island',
    'Barili',
    'Ronda',
  ];

  List<String> nonCebuRoutes = [
    'Tacloban',
    'Tagbilaran',
    'Dumaguete',
    'MCR Dumaguete',
    'Tubigon',
  ];

  Future<Map<String,dynamic>> getPayRate()async{
    Map<String,dynamic> rates = {};
    try {
      DocumentSnapshot ratesDoc = await _firestore.collection('Payroll').doc('Rate').get();
      if(ratesDoc.exists){
        Map<String,dynamic> ratesData = ratesDoc.data() as Map<String,dynamic>;
        rates = ratesData;
      }

      return rates;
    } catch (e) {
      print('Error fetching rates: $e');
      return rates;
    }
  }

  Future<Map<String, dynamic>> computeNoOfDays(String order)async{
    Map<String,dynamic> orderData = await _databaseService.fetchOrderDetails(order);
    String route = orderData['route'];
    Map<String,dynamic> rates = await getPayRate();
    double days = rates['loadingRate'];
    print(route);
    if(cebuRoutes.contains(route)){
      print('cenbuRoutes');
      days += rates['cebuRate'];
    }else if(nonCebuRoutes.contains(route)){
      print('noncenbuRoutes');
      days += rates['noncebuRate'];
    }
    Map<String,dynamic> numDays = {'order': '$order - $route', 'days': days};
    return numDays;
  }

  void updatePayRate(int driverRate, int helperRate, int cebuRate, int loadingRate, int otherRate){
    try {

      _firestore..collection('Payroll').doc('Rate').update({
        'driverRate': driverRate,
        'helperRate': helperRate,
        'cebuRate': cebuRate,
        'loadingRate': loadingRate,
        'noncebuRate': otherRate,
      });

      print('Document successfully updated');
    } catch (error) {
      print('Error updating document: $error');
    }
  }

  Future<Map<String, dynamic>> getDeduction(String staffId) async {
    Map<String, dynamic> staffDeduction = {};
    try {
      DocumentSnapshot staffquery = await _firestore.collection('Payroll').doc(staffId).get();
      // Handle the document snapshot
      if (staffquery.exists) {
        Map<String, dynamic> document = staffquery.data() as Map<String, dynamic>;
        staffDeduction['staffId'] = staffquery.id;
        staffDeduction.addAll(document);
      } else {
        print('no document');
        // Set default values and create new document
        await _firestore
            .collection('Payroll')
            .doc(staffId)
            .set({
              'SSS': 0,
              'PhilHealth': 0, 
              'Pagibig': 0,
              'ClaimedStatus' : false,
              'NetSalary': 0, 
            });

        // Fetch newly created document
        DocumentSnapshot newStaffquery = await _firestore.collection('Payroll').doc(staffId).get();
        Map<String, dynamic> newDocument = newStaffquery.data() as Map<String, dynamic>;
        staffDeduction['staffId'] = newStaffquery.id;
        staffDeduction.addAll(newDocument);
      }
    } catch (e) {
      // Handle errors
      print('Error fetching document: $e');
    }
    return staffDeduction;
  }


  void updateDeduction(String staffId, String name, double amount)async{
    try {
      DocumentSnapshot staffquery = await _firestore.collection('Payroll').doc(staffId).get();
      // Handle the document snapshot
      if(staffquery.exists){
        if(name == 'Pag-ibig'){
          name = 'Pagibig';
        }
        await _firestore
            .collection('Payroll')
            .doc(staffId)
            .update({
             name : amount,
            });
      }
    } catch (e) {
      // Handle errors
      print('Error fetching document: $e');
    }
  }

  void updatePayroll(String path, //Payroll/2024_01/1/CUC-007
  String staffId,
  double netSalary,
  double numDays,
  Map<String, dynamic> staffInfo
  )async{
    try {
      double SSS = staffInfo['SSS'];
      double PhilHealth = staffInfo['PhilHealth'];
      double Pagibig = staffInfo['Pagibig'];
      _firestore..collection(path).doc(staffId).update({
        'netSalary' : netSalary,
        'numDays' : numDays,
        'SSS' : SSS,
        'PhilHealth' : PhilHealth,
        'Pagibig' : Pagibig
      });
      
    } catch (e) {
      // Handle errors
      print('Error updating payroll: $e');
    }
  }


  Future<List<String>> accomplishedDeliveries(String staffId) async {
    List<String> deliveries = [];

    // Query for the staff document based on the staffId field
    QuerySnapshot staffQuerySnapshot = await _firestore
        .collection('Users')
        .where('staffId', isEqualTo: staffId)
        .get();

    // Check if any documents were found
    if (staffQuerySnapshot.docs.isNotEmpty) {
      // Get the first document (assuming staffId is unique)
      DocumentSnapshot staffDocSnapshot = staffQuerySnapshot.docs.first;

      // Get accomplished deliveries collection
      QuerySnapshot accomplishedDeliveriesSnapshot = await staffDocSnapshot.reference.collection('Accomplished Deliveries').get();

      // Iterate through accomplished deliveries documents
      for (var doc in accomplishedDeliveriesSnapshot.docs) {
        // Extract delivery details from each document
        String deliveryDetails = doc.id; 
        deliveries.add(deliveryDetails);
        //getWeekNumber(deliveryDetails); 
      }

      // Print deliveries (optional)
      //print('Accomplished Deliveries: $deliveries');
    } else {
      print('Staff document with staffId $staffId not found');
    }

    return deliveries;
  }

  Future<List<Map<String, dynamic>>> weekPayroll(int year, int month, int week) async {
    List<Map<String, dynamic>> weekPayroll = [];
    print('Week: $week');

    try {
      // Convert the month into a two-digit number
      String numberString = month.toString();
      if (numberString.length == 1) {
        numberString = '0$numberString';
      }

      // Construct the Firestore path
      String path = 'Payroll/$year' + '_' + numberString + '/$week';
      print(path);
      QuerySnapshot payrollSnapshots = await _firestore.collection(path).get();

      for (DocumentSnapshot payrollSnapshot in payrollSnapshots.docs) {
        if (payrollSnapshot.exists) {
          Map<String, dynamic> payrollData = payrollSnapshot.data() as Map<String, dynamic>;
          payrollData['staffId'] = payrollSnapshot.id;

          QuerySnapshot staffInfo = await _firestore.collection('Users').where('staffId', isEqualTo: payrollSnapshot.id)
          .get();
          if (staffInfo.docs.isNotEmpty) {
            Map<String, dynamic> staffInfoData = staffInfo.docs.first.data() as Map<String, dynamic>;
            payrollData['position'] = staffInfoData['position'];
            payrollData['firstname'] = staffInfoData['firstname'];
            payrollData['lastname']= staffInfoData['lastname'];
            payrollData['pictureUrl'] = staffInfoData['pictureUrl'] ?? '';
          }
          weekPayroll.add(payrollData);
        }
      }
    } catch (e) {
      print('Payroll error: $e');
    }

    return weekPayroll;
  }



  Future<List<Map<String, dynamic>>> fetchAccomplished() async {
    try {
      QuerySnapshot userSnapshots = await _firestore.collection('Users').get();
      List<Map<String, dynamic>> accomplished = [];

      for (DocumentSnapshot userSnapshot in userSnapshots.docs) {
        // Get the reference to the "accomplished deliveries" subcollection
        CollectionReference deliveriesRef = userSnapshot.reference.collection('Accomplished Deliveries');
        
        // Query the subcollection to check if it exists
        QuerySnapshot deliveriesSnapshots = await deliveriesRef.get();
        
        // If the subcollection exists, process the user document
        if (deliveriesSnapshots.docs.isNotEmpty) {
          Map<String, dynamic> accomplishedMap = userSnapshot.data() as Map<String, dynamic>;
          
          if (accomplishedMap.containsKey('staffId')) {
            String staffId = accomplishedMap['staffId'];

            Map<String, dynamic> staffAccomplished = {};
            staffAccomplished['staffId'] = staffId;

            List<String> deliveries = await accomplishedDeliveries(staffId);
            if (deliveries.isEmpty) {
              staffAccomplished['accomplished'] = 'No deliveries';
            } else {
              staffAccomplished['accomplished'] = deliveries;
            }
            accomplished.add(staffAccomplished);
          }
        } else {
          //print('No accomplished deliveries for user: ${userSnapshot.id}');
        }
      }

      return accomplished;
    } catch (e) {
      throw Exception('Failed to fetch accomplished: $e');
    }
  }



  Future<int> getWeekNumber(String loadDate)async {
    DateTime date = DateFormat('MMM dd, yyyy').parse(loadDate);

    // Convert the date to UTC+8 timezone
    DateTime utcPlus8Date = date.add(Duration(hours: 8));

    // Find the first Monday of the year
    DateTime firstDayOfYear = DateTime(utcPlus8Date.year, 1, 1);
    int firstMondayOffset = 8 - firstDayOfYear.weekday;
    DateTime firstMonday = firstDayOfYear.add(Duration(days: firstMondayOffset));

    // Calculate the difference in weeks between the loading date and the first Monday of the year
    int weekDifference = (utcPlus8Date.difference(firstMonday).inDays / 7).floor();

    //print('$orderId: ${weekDifference + 1}');
    // Week number is the difference plus one
    return weekDifference + 1;
  }

  void computePay()async{
    try{

    } catch(e){
      print('Failed to compute: $e');
    }
  }

  Future<bool> claimPayroll(String path, String name, String picture, String staffId)async{
    try{
      DateTime today = DateTime.now();
      _firestore..collection(path).doc(staffId).update({
        'ClaimedBy' : name,
        'ClaimedPicture' : picture,
        'ClaimedStatus': 'Claimed',
        'ClaimedDate': today,
      });
      return true;
    }catch(e){
      print('Failed to claim: $e');
      return false;
    }

  }

  Future<Map<String, int>> getWeekClass(String order)async{
    Map<String, int> weekClass = {};
    
    return weekClass;
  }

  Future<Map<int, List<Map<String, dynamic>>>> groupOrders(List<Map<String, dynamic>> orders) async {
    Map<int, List<Map<String, dynamic>>> groupedOrders = {};

    for (Map<String, dynamic> order in orders) {
      String loadDate = order['loadingDate']; // Assuming 'loadingDate' is the key for the loading date
      DateTime dateTime = DateFormat('MMM dd, yyyy').parse(loadDate);
      int year = dateTime.year;
      int month = dateTime.month;
      int week = await getWeekNumber(loadDate);

      // Calculate a unique key combining year, month, and week
      int key = year * 10000 + month * 100 + week;

      // Check if the key exists in the map, if not, create a new list
      if (!groupedOrders.containsKey(key)) {
        groupedOrders[key] = [];
      }

      // Add the order to the list corresponding to its year, month, and week
      groupedOrders[key]!.add(order);
    }
    // Print group
    // groupedOrders.forEach((key, value) {
    //   print('Year: ${key ~/ 10000}, Month: ${(key % 10000) ~/ 100}, Week: ${key % 100}, Orders: $value');
    // });
    
    return groupedOrders;
  }

  // void addPayroll() async {
  //   String loadDate = order['loadingDate'];
  //   DateTime dateTime = DateFormat('MMM dd, yyyy').parse(loadDate);
  //   int year = dateTime.year;
  //   int month = dateTime.month;
  //   int week = await getWeekNumber(loadDate);

  //   String documentId = '$year-$month'; // Form document ID
  //   String documentPath = 'Payroll/$documentId/$week/$staffId';

  //   DocumentSnapshot staff = await _firestore.doc(documentPath).get();

  //   if (staff.exists) {
  //     Map<String, dynamic> staffDoc = staff.data() as Map<String, dynamic>;
  //     if (staffDoc.containsKey('accomplishedDeliveries')) {
  //       List<String> accomplishedDeliveries = List.from(staffDoc['accomplishedDeliveries']);
  //       accomplishedDeliveries.add(orderId);
  //       await _firestore.doc(documentPath).update({
  //         'accomplishedDeliveries': accomplishedDeliveries,
  //       });
  //     }
  //   } else {
  //     await _firestore.doc(documentPath).set({
  //       'accomplishedDeliveries': [orderId],
  //     });
  //   }
  // }




 
}






class Delivery {
  String assignedTruck;
  String companyName;
  String confirmedStatus;
  String customerEmail;
  DateTime dateFiled;
  String loadingId;
  String note;
  String phone;
  String pointPerson;
  String cargoType;
  String deliveryStatus;
  String loadingLocation;
  String loadingTime;
  String loadingDate;
  String route;
  int totalCartons; // Total weight
  String warehouse;

  Delivery({
    required this.assignedTruck,
    required this.companyName,
    required this.confirmedStatus,
    required this.customerEmail,
    required this.dateFiled,
    required this.loadingId,
    required this.note,
    required this.phone,
    required this.pointPerson,
    required this.cargoType,
    required this.deliveryStatus,
    required this.loadingLocation,
    required this.loadingTime,
    required this.loadingDate,
    required this.route,
    required this.totalCartons,
    required this.warehouse,
  });
}

class WeeklyPayroll {
  int weekNumber;
  DateTime startDate;
  DateTime endDate;
  double totalPay;
  List<Delivery> deliveries;

  WeeklyPayroll({
    required this.weekNumber,
    required this.startDate,
    required this.endDate,
    required this.totalPay,
    required this.deliveries,
  });
}


int getISOWeekNumberFromFormattedString(String formattedDate) {
  DateFormat formatter = DateFormat('MMM dd, yyyy');
  DateTime date = formatter.parse(formattedDate);
  return getISOWeekNumber(date);
}

int getISOWeekNumber(DateTime date) {
  int january4thWeekday = DateTime(date.year, 1, 4).weekday;
  DateTime january4th = DateTime(date.year, 1, 4 + (1 - january4thWeekday));
  Duration difference = date.difference(january4th);
  int days = difference.inDays;
  int weekNumber = (days / 7).ceil() + 1;
  return weekNumber;
}



List<WeeklyPayroll> generateWeeklyPayroll(List<Delivery> deliveries) {
  // Group deliveries by week
  Map<int, List<Delivery>> deliveriesByWeek = {};

  deliveries.forEach((delivery) {
    int weekNumber = getISOWeekNumberFromFormattedString(delivery.loadingDate);
    if (!deliveriesByWeek.containsKey(weekNumber)) {
      deliveriesByWeek[weekNumber] = [];
    }
    deliveriesByWeek[weekNumber]!.add(delivery);
  });

  // Calculate total pay for each week
  List<WeeklyPayroll> weeklyPayrolls = [];
  deliveriesByWeek.forEach((weekNumber, weekDeliveries) {
    double totalPay = 0;
    weekDeliveries.forEach((delivery) {
      // Calculate pay based on totalCartons (or total weight) or any other relevant information
      totalPay += calculatePay(delivery.totalCartons);
    });

    // Determine start and end dates of the week
    // DateTime startDate = weekDeliveries.first.loadingTimeDate.subtract(Duration(days: weekDeliveries.first.loadingTimeDate.weekday - 1));
    // DateTime endDate = startDate.add(Duration(days: 6));

    // WeeklyPayroll payroll = WeeklyPayroll(
    //   weekNumber: weekNumber,
    //   startDate: startDate,
    //   endDate: endDate,
    //   totalPay: totalPay,
    //   deliveries: weekDeliveries,
    // );
    // weeklyPayrolls.add(payroll);
  });

  return weeklyPayrolls;
}

double calculatePay(int totalCartons) {
  // Implement your logic to calculate pay based on totalCartons (or total weight) or any other relevant information
  // For example, you can use a pay rate per carton or weight
  // This is just a placeholder implementation
  return totalCartons * 5.0; // Assuming $5 per carton
}
