import 'package:flutter/material.dart';
import 'package:haul_a_day_web/web_Pages/truckList/truckInfoPanel/incidentReportDialog.dart';
import 'package:haul_a_day_web/web_Pages/truckList/truckInfoPanel/truckInfo.dart';


class IncidentReport extends StatefulWidget {
  final String truckId;

  IncidentReport({Key? key, required this.truckId}) : super(key: key);

  @override
  State<IncidentReport> createState() => _IncidentReportState();
}

class _IncidentReportState extends State<IncidentReport> {
  List<InciReport> incidentReportList = [];

  @override
  void initState() {
    super.initState();
    _initializeTruckData();
  }

  Future<void> _initializeTruckData() async {
    try {
      incidentReportList = await fetchIncidentReports(widget.truckId);
      setState(() {});
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.only(left: 30),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Incident Report',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(height: 7),
          Expanded(
            child: incidentReportList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : (incidentReportList[0].reportId=='none')
                  ?Center(
                    child: Text(
                      'No Incidents so far',
                      style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),)
                  :ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              itemCount: incidentReportList.length,
              itemBuilder: (context, index) {
                InciReport report = incidentReportList[index];
                return Column(
                  children: [
                    incidentReport(report),
                    SizedBox(height: 5),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget incidentReport(InciReport report) {
    return GestureDetector(
      onTap: (){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return IncidentReportDialog(report: report);
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical:10),
        decoration: BoxDecoration(
          color: Color(0xffF1FFED),
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              report.reportId,
              style: TextStyle(
                  fontSize: 20, color: Colors.grey[800], fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Text(
              intoDate(report.incidentTimeDate),
              style: TextStyle(
                  fontSize: 16, color: Colors.grey[400], fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
