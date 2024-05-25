
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class InciReport {
  final String reportId;
  final String currentSchedule;
  final String documentation;
  final String incidentDescription;
  final Timestamp incidentTimeDate;
  final String incidentType;
  final String mechanicName;

  InciReport(
      this.reportId,
      this.currentSchedule,
      this.documentation,
      this.incidentDescription,
      this.incidentTimeDate,
      this.incidentType,
      this.mechanicName);

  InciReport.nullReport()
    :reportId ='none',
    currentSchedule='',
    documentation='',
    incidentDescription='',
    incidentTimeDate=Timestamp.now(),
    incidentType='',
    mechanicName='';

  factory InciReport.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return InciReport(
      snapshot.id,
      data['currentSchedule'] ?? '',
      data['documentation'] ?? '',
      data['incidentDescription'] ?? '',
      data['incidentTimeDate'] ?? Timestamp.now(),
      data['incidentType'] ?? '',
      data['mechanicName'] ?? '',
    );
  }
}

Future<List<InciReport>> fetchIncidentReports (String truckId) async {
  List<InciReport> incidentReports = [];
  try{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Trucks')
        .doc(truckId)
        .collection('Incident Reports')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      print("YES");

      for (var doc in querySnapshot.docs) {
        incidentReports.add(InciReport.fromSnapshot(doc));
      }
    }else{
      incidentReports.add(InciReport.nullReport());
    }
  }catch (e){
    print('error: ${e}');
    incidentReports.add(InciReport.nullReport());
    return incidentReports;
  }

  return incidentReports;
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



