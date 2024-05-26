import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Timestamp changeTimestamps(DateTime date, TimeOfDay time ){
  DateTime selectedDateTime = DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );
  return Timestamp.fromDate(selectedDateTime);


}

String intoDate (Timestamp timeStamp)  {
  DateTime dateTime = timeStamp.toDate(); // Convert Firebase Timestamp to DateTime
  String formattedDate = DateFormat('MMM d,yyyy').format(dateTime); // Format DateTime into date string
  return formattedDate; // Return the formatted date string
}

String intoTime (Timestamp stampTime) {
  DateTime dateTime =  stampTime.toDate();  // Convert Firebase Timestamp to DateTime
  String formattedTime = DateFormat('h:mm a').format(dateTime); // Format DateTime into time string
  return formattedTime; // Return the formatted time string
}

String DateToString (DateTime date){
  String formattedDate = DateFormat('MMM d,yyyy').format(date); // Format DateTime into time string
  return formattedDate;
}

String TimeToString (TimeOfDay time){
  Timestamp temp = changeTimestamps(DateTime(1970, 1, 1), time);
  return intoTime(temp);
}

Timestamp getTimeDate(){
  // Get the current date and time
  DateTime now = DateTime.now();

// Convert DateTime to Timestamp
  return Timestamp.fromDate(now);

}

String forLoadDate(Timestamp timestamp){
  DateTime dateTime = timestamp.toDate(); // Convert Firebase Timestamp to DateTime
  String formattedDate = DateFormat('MMM dd, yyyy').format(dateTime); // Format DateTime into date string
  return formattedDate;
}
