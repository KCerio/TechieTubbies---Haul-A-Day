
import 'dart:io';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:haul_a_day_mobile/bottomTab.dart';
import 'package:haul_a_day_mobile/deliveryTab/delivery_tab.dart';
import 'package:haul_a_day_mobile/deliveryTab/loading_successful_reports/loading_delivery_report_successful.dart';
import 'package:haul_a_day_mobile/deliveryTab/loading_successful_reports/send_loading_delivery_report_successful.dart';
import 'package:image_picker/image_picker.dart';


class NextLoadingDeliveryReportSuccessful extends StatefulWidget {

final LoadingDelivery loadingDelivery;
final String orderId;
final List<teamMember> team;
final Timestamp arrivalTimeAndDate;
final bool completeCartons;
final String reasonIncomplete;
final int numberCartons;

const NextLoadingDeliveryReportSuccessful({Key? key,
  required this.loadingDelivery,
  required this.orderId,
  required this.team,
  required this.arrivalTimeAndDate,
  required this.completeCartons,
  required this.reasonIncomplete,
  required this.numberCartons}) : super(key: key);

@override
_NextLoadingDeliveryReportSuccessfulState createState() =>
    _NextLoadingDeliveryReportSuccessfulState();
}



class _NextLoadingDeliveryReportSuccessfulState extends State<NextLoadingDeliveryReportSuccessful> {
  int _currentIndex = 1;
  int progress = 40;

  DateTime? _selectedDate = null;
  TimeOfDay? _selectedTime = null;

  TextEditingController recipientName = TextEditingController();
  XFile? _signatory = null;
  XFile? _documentation = null;

  void updateProgress() {
    int newProgress = 40;

    if(_selectedTime!=null) newProgress+=10;
    if(_selectedDate!=null) newProgress+=10;
    if(_signatory!=null) newProgress+=10;
    if(_documentation!=null) newProgress+=10;
    if(recipientName.text.trim().isNotEmpty) newProgress+=10;


    // Add more conditions for other fields
    setState(() {
      progress = newProgress;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.blue[700],
          title: Text(
            'Create Successful Delivery Report',
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeliveryTab()),
              );
            },
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Column(
                children: [

                  //Delivery ID
                  Center(
                    child: Container(
                      color: Colors.blue[100],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 10),
                          Column(
                            children: [
                              SizedBox(height: 10),
                              Text(
                                widget.orderId,
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.loadingDelivery.loadingId,
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ),

                  //progressBar
                  Container(
                    child: LinearProgressIndicator(
                      value: progress / 100,
                      minHeight: 20,
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue[900]!),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    SizedBox(height: 10,),
                    //enter name of recipient
                    RecipientName(),


                    //Signatory
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Text(
                          'Signatory',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if(_signatory==null)
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
                          tooltip: 'Upload the signature of the recipient', onPressed: () {  },
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Signatory(),
                    SizedBox(height: 20),

                    //Documentation
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Text(
                          'Documentation',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if(_documentation==null)
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
                          tooltip: 'Upload some documentation during loading', onPressed: () {  },
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Documentation(),
                    SizedBox(height: 20),




                    //departure date and time
                    DepartureDateAndTime(),

                    //Back And Next Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);

                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  // return light blue when pressed
                                  return Colors.blue[700]!;
                                }
                                // return blue when not pressed
                                return Colors.blue[700]!;
                              },
                            ),
                            minimumSize: MaterialStateProperty.all<Size>(Size(150, 40)),
                          ),
                          child: Text(
                            'Back',
                            style: TextStyle(color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold), // Set text color
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            if(progress==90){
                              nextPage();
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
                                  return Colors.blue[700]!;
                                }
                                // return blue when not pressed
                                return Colors.blue[700]!;
                              },
                            ),
                            minimumSize: MaterialStateProperty.all<Size>(Size(150, 40)),
                          ),
                          child: Text(
                            'Continue',
                            style: TextStyle(color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold), // Set text color
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),


                    SizedBox(height: 20),


                  ],
                ),
              ),
            ),


          ],
        ),
        bottomNavigationBar: BottomTab(currIndex: _currentIndex)
    );
  }

//Widgets
  Widget RecipientName(){
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 10),
            Text(
              'Recipient Name',
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),

            ),
            if(recipientName.text.trim().isEmpty)
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
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextFormField(
              controller: recipientName,
              decoration: InputDecoration(//
                hintText: 'Enter Name of Recipient',// Placeholder text
                border: OutlineInputBorder(),

                filled: true,focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.person),
                prefixIconColor: Colors.blue[700]


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
      ],
    );
  }

  Widget DepartureDateAndTime() {
    return Column(
      children: [

        Row(
          children: [
            SizedBox(width: 10),
            Text(
              'Departure Date and Time',
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if(_selectedTime == null || _selectedDate == null)
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
              padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 30,
                  right: 30
              ),
              child: Column(
                children: [
                  DateTimeFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.blue[700],
                      ),
                      hintText: 'Enter date departed from location',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(5.0),
                          // Adjust the top border radius
                          bottom: Radius.circular(0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(5.0),
                          // Adjust the top border radius
                          bottom: Radius.circular(0),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    mode: DateTimeFieldPickerMode.date,
                    onChanged: (value) {
                      _selectedDate = value;
                      setState(() {
                        updateProgress();
                      });
                    },
                  ),
                  DateTimeFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.access_time,
                        color: Colors.blue[700],
                      ),
                      hintText: 'Enter time departed location',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(0),
                          bottom: Radius.circular(5.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(0.0),
                          bottom: Radius.circular(5.0),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    mode: DateTimeFieldPickerMode.time,
                    onChanged: (value) {
                      if (value == null) {
                        _selectedTime = null;
                      } else {
                        _selectedTime =
                            TimeOfDay.fromDateTime(value);
                      }
                      setState(() {
                        updateProgress();
                      });
                    },
                  )

                ],
              )
          ),
        ),

        SizedBox(height: 20),
      ],
    );
  }

  Widget Signatory(){
    if(_signatory==null){
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  selectPhotoSignatory().then((_) {
                    setState(() {
                      updateProgress();
                    });
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blue[700]!;
                      }
                      return Colors.blue[200]!;
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
                  takePhotoSignatory().then((_) {
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
                        return Colors.blue[700]!;
                      }
                      // return blue when not pressed
                      return Colors.blue[200]!;
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
    }else{
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
                                File(_signatory!.path),
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
                                  _signatory!.name,
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
                            _signatory = null;
                            setState(() {
                              updateProgress();
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.blue[700]!;
                                }
                                return Colors.blue[200]!;
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
                            selectPhotoSignatory().then((_) {
                              setState(() {
                                updateProgress();
                              });
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.blue[700]!;
                                }
                                return Colors.blue[200]!;
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
                            takePhotoSignatory().then((_) {
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
                                  return Colors.blue[700]!;
                                }
                                // return blue when not pressed
                                return Colors.blue[200]!;
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

  Widget Documentation(){
    if(_documentation==null){
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  selectPhotoDocumentation().then((_) {
                    setState(() {
                      updateProgress();
                    });
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blue[700]!;
                      }
                      return Colors.blue[200]!;
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
                  takePhotoDocumentation().then((_) {
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
                        return Colors.blue[700]!;
                      }
                      // return blue when not pressed
                      return Colors.blue[200]!;
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
    }else{
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
                                File(_documentation!.path),
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
                                  _documentation!.name,
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
                            _documentation = null;
                            setState(() {
                              updateProgress();
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.blue[700]!;
                                }
                                return Colors.blue[200]!;
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
                            selectPhotoDocumentation().then((_) {
                              setState(() {
                                updateProgress();
                              });
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.blue[700]!;
                                }
                                return Colors.blue[200]!;
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
                            takePhotoDocumentation().then((_) {
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
                                  return Colors.blue[700]!;
                                }
                                // return blue when not pressed
                                return Colors.blue[200]!;
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

  //nextPage

  void nextPage(){
    if (_selectedDate != null && _selectedTime != null) {
      DateTime selectedDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      Timestamp departureDateAndTime = Timestamp.fromDate(selectedDateTime);

      Navigator.push(context, MaterialPageRoute(builder: (context)=> SendLoadingSuccess(
          loadingDelivery: widget.loadingDelivery,
          orderId: widget.orderId, team: widget.team,
          arrivalTimeAndDate: widget.arrivalTimeAndDate,
          completeCartons: widget.completeCartons,
          reasonIncomplete: widget.reasonIncomplete,
          recipientName: recipientName.text.trim(),
          signatory: _signatory?? XFile(''),
          documentation: _documentation?? XFile(''),
          departureTimeAndDate: departureDateAndTime, numberCartons: widget.numberCartons,)));


    }

  }



//Selecting Photos
  Future selectPhotoSignatory() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _signatory = image!;
    });
  }

  Future takePhotoSignatory() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      _signatory = image!;
    });
  }

  Future selectPhotoDocumentation() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _documentation = image!;
    });
  }

  Future takePhotoDocumentation() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      _documentation = image!;
    });
  }



}
