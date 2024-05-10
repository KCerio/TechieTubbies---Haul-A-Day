
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:haul_a_day_mobile/components/bottomTab.dart';
import 'package:haul_a_day_mobile/truckTeamTab/truckteam_incidentreportnext.dart';
import 'package:image_picker/image_picker.dart';



class IncidentReport extends StatefulWidget {
  final String truckId;
  final String assignedSchedule;

  const IncidentReport({Key? key,
    required this.truckId,
    required this.assignedSchedule}) : super(key: key);

  @override
  _IncidentReportState createState() => _IncidentReportState();
}


class _IncidentReportState extends State<IncidentReport> {
  int _currentIndex = 0;
  int progress = 0;

  //single select list for incidentType
  List<String> incidentType =['Accident', 'Mechanical Failure', 'Others'];
  late String? selectedIncidentType;


  TextEditingController mechanicName = TextEditingController();
  TextEditingController incidentDescription = TextEditingController();

  XFile? _image =null;

  @override
  void initState() {
    super.initState();
    selectedIncidentType = null; // Set default selection
  }



  void updateProgress() {
    int newProgress = 0;

    if(incidentDescription.text.trim().isNotEmpty)newProgress+=25;
    if (selectedIncidentType != null) newProgress += 25;
    if (_image != null) {
      newProgress += 25;
    }


    // Add more conditions for other fields
    setState(() {
      progress = newProgress;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEEEEE),
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        title: Text(
          'Create Incident Report',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body:Column(
        children: [
          //ProgressBar
          Container(
            child: LinearProgressIndicator(
              value: progress / 100,
              minHeight: 20,
              backgroundColor: Color(0xFFD9D9D9),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ReportForm(),
                ],
              ),
            ),
          ),
        ],
      ),
        bottomNavigationBar: BottomTab(currIndex: _currentIndex)
    );
  }

  Widget ReportForm(){
    return SingleChildScrollView(
      child: Column(
        children: [

          SizedBox(height: 10),

          //type of incident
          Row(
            children: [
              SizedBox(width: 10),
              Text(
                'Type of Incident',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if(selectedIncidentType==null)
                Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Spacer(),
              IconButton(
                icon:Icon(Icons.info_outline) ,
                tooltip: 'Select the type of incident', onPressed: () {  },
              )


            ],
          ),
          //SizedBox(height: 5),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(incidentType.length, (index) {
                final incident = incidentType[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4), // Add horizontal spacing
                  child: Container(
                    width: 135,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedIncidentType = incident == selectedIncidentType ? null : incident;
                          updateProgress(); // Call updateProgress when incident selection changes
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              // return light blue when pressed
                              return Colors.green[200]!;
                            }
                            // return blue when not pressed
                            return selectedIncidentType == incident ? Colors.green[700]! : Colors.green[300]!;
                          },
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(Size(30, 50)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                          ),
                        ),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 8), // Add horizontal padding
                        child: Text(
                          incident,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center, // Align text to the center
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 25),

          //name
          Row(
            children: [
              SizedBox(width: 10),
              Text(
                'Name of Mechanic or Repair Shop',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 16),
              child: TextFormField(
                controller: mechanicName,
                decoration: InputDecoration(//
                  hintText: 'Enter Name of Shop or Mechanic',// Placeholder text
                  border: OutlineInputBorder(),
                  // Add border
                  filled: true,focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                ),
                  fillColor: Colors.white,

                ),

              ),
            ),
          ),
          SizedBox(height: 20),


          //DOCUMENTATION
          Row(
            children: [
              SizedBox(width: 10),
              Text(
                'Documentation',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if(_image == null || _image!.path == '')
                Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          SizedBox(height: 10),

          if(_image==null)
            noDocumentation(),
          if(_image!=null)
          withDocumentaion(),
          SizedBox(height: 20),


          //description
          Row(
            children: [
              SizedBox(width: 10),
              Text(
                'Description of Incident',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if(incidentDescription.text.trim().isEmpty)
              Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 16),
              child: TextField(
                controller:incidentDescription,
                maxLines: null, // Allow text to wrap to the next line
                textInputAction: TextInputAction
                    .newline, // Enable Return key to insert a newline
                decoration: InputDecoration(
                  hintText: 'Enter detailed description as to what happened', // Placeholder text
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),// Add border
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 20, horizontal: 12.0), // Adjust padding
                ),
                onChanged: (value) {
                  setState(() {
                    updateProgress();
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 20),


          ElevatedButton(
            onPressed: () {
              if(_validateForm()){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IncidentReportNext(
                      truckId: widget.truckId,
                      currentSchedule: widget.assignedSchedule,
                      incidentType: selectedIncidentType ?? '', // Handle null case
                      mechanicName: mechanicName.text,
                      documentation: _image ?? XFile(''), // Handle null case
                      incidentDescription: incidentDescription.text,
                    ),
                  ),
                );
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.sim_card_alert_outlined, color: Colors.red,),
                        SizedBox(width: 5),
                        Text('Enter all necessary fields to continue'),
                      ],
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    // return light blue when pressed
                    return Colors.green[200]!;
                  }
                  // return blue when not pressed
                  return Colors.green[700]!;
                },
              ),
              minimumSize: MaterialStateProperty.all<Size>(Size(200, 50)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius as needed
                ),
              ),
            ),
            child: Text(
              'Continue',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ), // Set text color
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  bool _validateForm() {

    if(progress==75){
      return true;
    }else{
      return false;
    }
  }

  Future selectPhoto() async {
      final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print(_image?.path);
    });
  }

  Future takePhoto() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
      print(_image?.path);
    });
  }

  Widget noDocumentation(){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                selectPhoto().then((_) {
                  setState(() {
                    updateProgress();
                  });
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.green[200]!;
                    }
                    return Colors.green[300]!;
                  },
                ),
                minimumSize: MaterialStateProperty.all<Size>(Size(60, 50)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10.0),
                  ),
                ),
              ),
              icon: Icon(Icons.cloud_upload_outlined, color: Colors.white,), // Icon widget
              label: Text(
                'Upload a Photo',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold), // Set text color
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () {
                takePhoto().then((_) {
                  setState(() {
                    updateProgress();
                  });
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      // return light blue when pressed
                      return Colors.green[200]!;
                    }
                    // return blue when not pressed
                    return Colors.green[300]!;
                  },
                ),
                minimumSize: MaterialStateProperty.all<Size>(Size(60, 50)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // Adjust the radius as needed
                  ),
                ),
              ),
              icon: Icon(Icons.camera_alt_outlined, color: Colors.white,), // Icon widget
              label: Text(
                'Take a Photo',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold), // Set text color
              ),
            ),
          ],
        ),

      ],
    );
  }

  Widget withDocumentaion(){
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),

          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                //image and name
                Column(
                  children: [
                    Center(
                      child:Container(
                        width: MediaQuery.of(context).size.width *0.40,
                        height: MediaQuery.of(context).size.width *0.40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                          child: Image.file(
                            File(_image!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Center(
                      child: Container(
                        width:MediaQuery.of(context).size.width *0.40,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,

                          child: Text(
                            _image!.name,
                          ),

                        ),
                      )
                    )
                  ],
                ),

                Spacer(),
                //buttons
                Column(

                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _image = null;
                        setState(() {
                          updateProgress();
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.green[200]!;
                            }
                            return Colors.green[300]!;
                          },
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width *0.40, 36)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0),
                          ),
                        ),
                      ),
                      icon: Icon(Icons.cancel_outlined, color: Colors.white,size: 16), // Icon widget
                      label: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), // Set text color
                      ),
                    ),

                    SizedBox(height: 5),

                    ElevatedButton.icon(
                      onPressed: () {
                        selectPhoto().then((_) {
                          setState(() {
                            updateProgress();
                          });
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.green[200]!;
                            }
                            return Colors.green[300]!;
                          },
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width *0.40, 36)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0),
                          ),
                        ),
                      ),
                      icon: Icon(Icons.cloud_upload_outlined, color: Colors.white,size: 16), // Icon widget
                      label: Text(
                        'Upload another Photo',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), // Set text color
                      ),
                    ),

                    SizedBox(height: 5),

                    ElevatedButton.icon(
                      onPressed: () {
                        takePhoto().then((_) {
                          setState(() {
                            updateProgress();
                          });
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              // return light blue when pressed
                              return Colors.green[200]!;
                            }
                            // return blue when not pressed
                            return Colors.green[300]!;
                          },
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width *0.40, 36)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Adjust the radius as needed
                          ),
                        ),
                      ),
                      icon: Icon(Icons.camera_alt_outlined, color: Colors.white, size: 16,), // Icon widget
                      label: Text(
                        'Take another Photo',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), // Set text color
                      ),
                    ),
                  ],

                )
              ],
            ),
          )
        ),
      ),
    );
  }



}
