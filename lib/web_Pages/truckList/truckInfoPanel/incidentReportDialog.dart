import 'package:flutter/material.dart';
import 'package:haul_a_day_web/web_Pages/truckList/truckInfoPanel/truckInfo.dart';

class IncidentReportDialog extends StatelessWidget {
  final InciReport report;

  IncidentReportDialog({required this.report});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(60.0), // Adjust border radius as needed
        side: BorderSide(
            color: Colors.green[500]!,
            width: 4.0), // Top border color and thickness
      ),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.green[500], // Title background color
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60.0),
                topRight: Radius.circular(60.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 10),
                Center(
                  child: Text(
                    'INCIDENT REPORT ${report.reportId}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(60.0, 60.0, 30.0, 60.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    height: 275,
                    width: 275,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 3.0),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(26.0), // Adjust for padding
                        child: Image.network(
                          report.documentation,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 60.0, 60.0, 10.0),
                    child: Container(
                      height: 60,
                      width: 400,
                      decoration: BoxDecoration(
                        color: Colors.green[500],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          report.incidentType,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 60.0, 10.0),
                    child: Container(
                      height: 125,
                      width: 400,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.grey[600]!, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: SingleChildScrollView(
                          child: Text(
                            report.incidentDescription,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            softWrap: true, // Enable text wrapping
                            maxLines: null, // Allow unlimited number of lines
                            overflow: TextOverflow.clip, // Clip overflowed text
                          ),
                        ),
                      ),
                    ),
                  ),
                  if(report.mechanicName!='')
                    Row(
                    mainAxisAlignment: MainAxisAlignment
                        .start, // Align children to the start of the main axis
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Align children to the start of the cross axis
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 10.0),
                        child: Container(
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(
                            color: Colors.green[500],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              'Mechanic:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 0.0, 60.0, 10.0),
                        child: Container(
                          height: 40,
                          width: 285,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.grey[600]!, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                                report.mechanicName,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 340,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${intoTime(report.incidentTimeDate)} ${intoDate(report.incidentTimeDate)}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
