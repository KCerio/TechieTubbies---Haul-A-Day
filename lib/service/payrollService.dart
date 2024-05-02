import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:intl/intl.dart';

class PayrollService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<double> computeNoOfDays(String route)async{
    Map<String,dynamic> rates = await getPayRate();
    double days = rates['loadingRate'];
    if(cebuRoutes.contains(route)){
      days += rates['cebuRate'];
    }else if(nonCebuRoutes.contains(route)){
      days += rates['noncebuRate'];
    }
    return days;
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
