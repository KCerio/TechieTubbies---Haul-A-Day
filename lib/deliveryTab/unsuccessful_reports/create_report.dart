import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haul_a_day_mobile/components/bottomTab.dart';
import 'package:haul_a_day_mobile/deliveryTab/delivery_tab.dart';

import 'package:haul_a_day_mobile/deliveryTab/unsuccessful_reports/send_report.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/data/teamMembers.dart';




class CreateUnsuccessfulReport extends StatefulWidget {

  final String deliveryId;
  final String orderId;

  const CreateUnsuccessfulReport({Key? key,
    required this.deliveryId,
    required this.orderId}) : super(key: key);

  @override
  _CreateUnsuccessfulReportState createState() =>
      _CreateUnsuccessfulReportState();
}



class _CreateUnsuccessfulReportState extends State<CreateUnsuccessfulReport> {
  int _currentIndex = 1;
  int page=1;

  int progress = 0;
  Color defaultColor = Colors.grey; // Default color
  Color pressedColor = Colors.blue[700]!; // Color when pressed

  List<teamMember> teamList = [];
  List<teamMember> selectedMembers = [];

  DateTime? _selectedDate = null;
  TimeOfDay? _selectedTime = null;



  List<String> reasons = [
    'Road Condition',
    'Mechanical Failure',
    'Delivery Refused',
    'Location Inaccessible',
    'Staff Shortage',
    'Cargo Damaged',
    'Others'];
  late String? selectedReason;

  TextEditingController reasonSpec = TextEditingController();

  XFile? _documentation = null;


  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    teamList = await getTeamList(widget.orderId);
    selectedReason =null;

    setState(() {}); // Update the UI with the retrieved data
  }

  void updateProgress() {
    int newProgress = 0;

    if (selectedMembers.isNotEmpty) newProgress += 18;
    if (_selectedTime != null) newProgress += 18;
    if (_selectedDate != null) newProgress += 18;
    if(_documentation!=null)newProgress += 18;
    if(selectedReason!=null){
      if(selectedReason=='Others'){
        newProgress += 9;
        if(reasonSpec.text.trim().isNotEmpty){
          newProgress += 9;
        }
      }else{
        newProgress += 18;
      }
    }


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
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Create Unsuccessful Delivery',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Report',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
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
        body: (teamList.isEmpty)
            ? Center(
          child: CircularProgressIndicator(color: Colors.blue),
        ) //
            : Column(
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
                                widget.deliveryId,
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
                    //date and time
                    DateAndTime(),

                    //TruckTeam
                    TruckTeamWidget(),

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

                    //reason
                    ReasonWidget(),
                    SizedBox(height: 20),

                    //Continue Button
                    ElevatedButton(
                      onPressed: () {
                        if(progress==90){
                          moveToNextPage();
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
                        backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              // return light blue when pressed
                              return Colors.blue[200]!;
                            }
                            // return blue when not pressed
                            return Colors.blue[700]!;
                          },
                        ),
                        minimumSize:
                        MaterialStateProperty.all<Size>(Size(200, 50)),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
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
              ),
            ),


          ],
        ),
        bottomNavigationBar: BottomTab(currIndex: _currentIndex)
    );
  }


  Widget displayMember(teamMember member) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            member.isSelected = !member.isSelected;
            updateSelection(member);
          });
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              // Return pressed color when pressed
              if (states.contains(MaterialState.pressed)) {
                return pressedColor;
              }
              // Return default color based on selected state
              return member.isSelected ? pressedColor : defaultColor;
            },
          ),
          minimumSize: MaterialStateProperty.all<Size>(
            Size(100, 100),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 10),
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(member.pictureUrl),
            ),
            SizedBox(height: 10),
            Text(
              member.fullname,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              member.position,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void updateSelection(teamMember member) {
    setState(() {
      if (member.isSelected) {
        selectedMembers.add(member);
      } else {
        selectedMembers.remove(member);
      }
      updateProgress();
    });
  }


  Widget DateAndTime() {
    return Column(
      children: [
        SizedBox(height: 20),
        Row(
          children: [
            SizedBox(width: 10),
            Text(
              'Date and Time',
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
                      hintText: 'Enter the date',
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
                      hintText: 'Enter the time',
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
                      }
                      else {
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

        SizedBox(height: 10),
      ],
    );
  }

  Widget TruckTeamWidget() {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(
                  'Truck Team',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if(selectedMembers.isEmpty)
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
                  icon: Icon(Icons.info_outline),
                  tooltip: 'Select the Members present during the Loading',
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 5),
        //build a list of displayMember from the list
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: teamList.map((member) => displayMember(member)).toList(),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget ReasonWidget(){
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 10),
            Text(
              'Reason',
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if(selectedReason==null)
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
        Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black, // Specify the border color here
                width: 1, // Adjust the border width as needed
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          child: DropdownButton<String>(
            value: selectedReason == '' ? null : selectedReason,
            onChanged: (String? newValue) {
              setState(() {
                selectedReason = newValue ?? '';
                updateProgress();
              });
            },
            items: reasons.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(), // Convert to Set to remove duplicates, then back to List
            hint: Text(
              'Enter reason of unsuccessful delivery',
            ),
            isExpanded:true,
          ),

        ),

        if(selectedReason=='Others')
          ReasonSpecified(),
      ],

    );
  }

  Widget ReasonSpecified(){
    return Column(
      children: [
        SizedBox(height: 20),
        Row(
          children: [
            SizedBox(width: 30),
            Text(
              'If "Others," please specify:',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontStyle: FontStyle.italic),
            ),
            if(reasonSpec.text.trim().isEmpty)
              Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 30.0, right: 30.0),
            child: TextField(
              controller: reasonSpec,
              maxLines:
              null, // Allow text to wrap to the next line
              textInputAction: TextInputAction
                  .newline, // Enable Return key to insert a newline
              decoration: InputDecoration(
                hintText: 'Enter reason of unsuccessful delivery', // Placeholder text
                border: OutlineInputBorder(), // Add border
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 12.0),
                // Adjust padding
              ),
              onChanged: (value) {
                setState(() {
                  updateProgress();
                });
              },
            ),
          ),
        ),

      ],
    );
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

  void moveToNextPage() {
    if (_selectedDate != null && _selectedTime != null) {
      DateTime selectedDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      Timestamp DateAndTime = Timestamp.fromDate(selectedDateTime);

      //navigate

      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          SendUnsuccessfulReport(
              deliveryId: widget.deliveryId,
              orderId: widget.orderId,
              team: selectedMembers,
              documentation: _documentation ?? XFile(''),
              TimeAndDate: DateAndTime,
              reason: selectedReason ?? '',
              reasonSpec: reasonSpec.text.trim())));
    }

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


