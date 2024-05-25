
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

class AccomplishedReport{
  final String id;
  final String customer;
  final Timestamp dateAssigned;

  AccomplishedReport(this.id, this.customer, this.dateAssigned);

  AccomplishedReport.nullReport()
    :id ='none',
    customer ='',
    dateAssigned = Timestamp.now();

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

Future<List<AccomplishedReport>> fetchDeliveryReports(String truckId) async {
  List<AccomplishedReport> deliveryList = [];

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Trucks')
        .doc(truckId)
        .collection('Accomplished Deliveries')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        print("YUH: ${doc.id}");
        String orderId = doc.id;

        String company = '';
        Timestamp assignedDate = Timestamp.now();

        DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
            .collection('Order')
            .doc(orderId)
            .get();

        if (orderSnapshot.exists) {
          company = orderSnapshot['company_name'];
          assignedDate = Timestamp.now();
          
        }

        AccomplishedReport accomplishedReport =
        AccomplishedReport(orderId, company, assignedDate);
        print("PERFECT: ${accomplishedReport.id}, ${accomplishedReport.customer}, ${intoDate(accomplishedReport.dateAssigned)}");
        deliveryList.add(accomplishedReport);
      }
    } else {
      // No delivery reports found, add a null report
      AccomplishedReport noAccomplished = AccomplishedReport.nullReport();
      deliveryList.add(noAccomplished);
    }
  } catch (e) {
    print("Error fetching delivery reports: $e");
    // Add a null report in case of error
    AccomplishedReport noAccomplished = AccomplishedReport.nullReport();
    deliveryList.add(noAccomplished);
  }

  return deliveryList;
}

String intoDate (Timestamp timeStamp)  {
  DateTime dateTime = timeStamp.toDate(); // Convert Firebase Timestamp to DateTime
  String formattedDate = DateFormat('MMM d,yyyy').format(dateTime); // Format DateTime into date string
  return formattedDate; // Return the formatted date string
}

String intoTime (Timestamp stampTime)  {
  DateTime dateTime =  stampTime.toDate();  // Convert Firebase Timestamp to DateTime
  String formattedTime = DateFormat('h:mm a').format(dateTime); // Format DateTime into time string
  return formattedTime; // Return the formatted time string
}



