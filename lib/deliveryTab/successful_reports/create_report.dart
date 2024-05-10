import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haul_a_day_mobile/components/bottomTab.dart';
import 'package:haul_a_day_mobile/deliveryTab/delivery_tab.dart';
import 'package:haul_a_day_mobile/deliveryTab/successful_reports/send_report.dart';


import 'package:image_picker/image_picker.dart';

import '../../components/dateThings.dart';
import '../../components/data/teamMembers.dart';



class CreateSuccessfulReport extends StatefulWidget {

  final String deliveryId;
  final String orderId;
  final String nextDeliveryId;

  const CreateSuccessfulReport({Key? key,
    required this.deliveryId,
    required this.orderId,
    required this.nextDeliveryId}) : super(key: key);

  @override
  _CreateSuccessfulReportState createState() =>
      _CreateSuccessfulReportState();
}

class _CreateSuccessfulReportState extends State<CreateSuccessfulReport> {
  int _currentIndex = 1;
  int page=1;

  int progress = 0;
  Color defaultColor = Colors.grey; // Default color
  Color pressedColor = Colors.blue[700]!; // Color when pressed

  //First Page Stuff
  List<teamMember> teamList = [];
  List<teamMember> selectedMembers = [];

  DateTime? _arrivalSelectedDate = null;
  TimeOfDay? _arrivalSelectedTime = null;

  String completeCargo='';
  TextEditingController _missingCartonsController = TextEditingController();
  TextEditingController _numberCartonsController = TextEditingController();

  //second page stuff
  DateTime? _departedSelectedDate = null;
  TimeOfDay? _departedSelectedTime = null;

  TextEditingController recipientName = TextEditingController();
  XFile? _signatory = null;
  XFile? _documentation = null;

  late int numberCartons;




  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    teamList = await getTeamList(widget.orderId);
    numberCartons= (await getNumberofCartons())!;

    setState(() {}); // Update the UI with the retrieved data
  }

  void updateProgress() {
    int newProgress = 0;

    if (selectedMembers.isNotEmpty) newProgress += 10;
    if (_arrivalSelectedTime != null) newProgress += 10;
    if (_arrivalSelectedDate != null) newProgress += 10;
    if(completeCargo=='No'){
      newProgress+=5;
      if(_missingCartonsController.text.trim().isNotEmpty){
        newProgress+=3;
      }
      if(_numberCartonsController.text.trim().isNotEmpty){
        newProgress+=2;
      }
    }else if(completeCargo=='Yes'){
      newProgress += 10;
    }

    if(page==2){
      if(_departedSelectedTime!=null) newProgress+=10;
      if(_departedSelectedDate!=null) newProgress+=10;
      if(_signatory!=null) newProgress+=10;
      if(_documentation!=null) newProgress+=10;
      if(recipientName.text.trim().isNotEmpty) newProgress+=10;

    }


    // Add more conditions for other fields
    setState(() {
      progress = newProgress;
    });

  }
  Future<int?> getNumberofCartons() async {
    if(widget.deliveryId.startsWith('L')){
      QuerySnapshot loadSnapshot = await FirebaseFirestore.instance
          .collection('Order')
          .doc(widget.orderId) // Access the specific order document
          .collection('LoadingSchedule')
          .get();

      if (loadSnapshot.docs.isNotEmpty) {
        // Assuming there's only one document, retrieve the first one
        DocumentSnapshot firstDocument = loadSnapshot.docs.first;
        return firstDocument['totalCartons']as int?;
      }else{
        return 0;
      }

    }else{
      List<String> parts = widget.deliveryId.split("-");
      String extractedNumber = parts[1];
      String loadingId = 'LS-$extractedNumber';

      DocumentSnapshot unloadingSnapshot = await FirebaseFirestore.instance
          .collection('Order')
          .doc(widget.orderId)
          .collection('LoadingSchedule')
          .doc(loadingId)
          .collection('UnloadingSchedule')
          .doc(widget.deliveryId)
          .get();

      if (unloadingSnapshot.exists){
        return unloadingSnapshot['quantity']as int?;
      }else{
        return 0;
      }

    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.blue[700],
          title:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Create Successful Delivery',
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
        body: _buildBody(),
        bottomNavigationBar: BottomTab(currIndex: _currentIndex)
    );
  }

  Widget _buildBody() {
    if (page == 1) {
      return firstPage();
    } else {
      return secondPage();
    }
  }

  //PAGES
  Widget firstPage(){
    if(teamList.isEmpty){
      return Center(
        child: CircularProgressIndicator(color: Colors.blue),
      );
    }else{
      return Column(
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
                  ArrivalDateAndTime(),

                  //TruckTeam
                  TruckTeamWidget(),

                  //number of Cartons
                  numberOfCartons(),

                  //Continue Button
                  ElevatedButton(
                    onPressed: () {
                      if(validate()){
                        page = 2;
                        setState(() {
                          updateProgress();
                        });
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
      );
    }

  }
  Widget secondPage(){
    return Column(
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
                        page =1;
                        setState(() {
                          updateProgress();
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
    );
  }



  //First Page Widgets
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
  Widget ArrivalDateAndTime() {
    return Column(
      children: [
        SizedBox(height: 20),
        Row(
          children: [
            SizedBox(width: 10),
            Text(
              'Arrival Date and Time',
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if(_arrivalSelectedTime == null || _arrivalSelectedDate == null)
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
                      hintText: (_arrivalSelectedDate==null)
                      ?'Enter date arrived at location'
                      :DateToString(_arrivalSelectedDate!),
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
                      _arrivalSelectedDate = value;
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
                      hintText: (_arrivalSelectedTime==null)
                      ?'Enter time arrived at location'
                      :TimeToString(_arrivalSelectedTime!),
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
                        _arrivalSelectedTime = null;
                      } else {
                        _arrivalSelectedTime =
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
  Widget numberOfCartons(){
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 10),
            Text(
              'Cartons',
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if(completeCargo=='')
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
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
                color: Colors.black, width: 1.5), // Add border
          ),
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (widget.deliveryId.startsWith("L"))? '${numberCartons} cartons loaded?':'${numberCartons} cartons delivered?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [

                      //YES
                      ElevatedButton(
                        onPressed: () {
                          completeCargo = 'Yes';
                          setState(() {
                            updateProgress();
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty
                              .resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(
                                  MaterialState.pressed)) {
                                // return light blue when pressed
                                return Colors.blue[200]!;
                              }
                              // return blue when not pressed
                              return completeCargo=='Yes'
                                  ? Colors.blue[700]!
                                  : Colors.blue[200]!;
                            },
                          ),
                          minimumSize:
                          MaterialStateProperty.all<Size>(
                              Size(30, 30)),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                            ),
                          ),
                        ),
                        child: Text(
                          'Yes',
                          style: TextStyle(
                              color:
                              Colors.white), // Set text color
                        ),
                      ),

                      //NO
                      ElevatedButton(
                        onPressed: () {
                          completeCargo = 'No';
                          setState(() {
                            updateProgress();
                          });

                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty
                              .resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(
                                  MaterialState.pressed)) {
                                // return light blue when pressed
                                return Colors.blue[200]!;
                              }
                              // return blue when not pressed
                              return completeCargo == 'No'
                                  ? Colors.blue[700]!
                                  : Colors.blue[200]!;
                            },
                          ),
                          minimumSize:
                          MaterialStateProperty.all<Size>(
                              Size(30, 30)),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Text(
                            'No',
                            style: TextStyle(
                              color: Colors.white, // Set text color
                            ),
                            textAlign: TextAlign
                                .center, // Center text horizontally
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        if (completeCargo=='No') // Show text field if showTextField is true
          incompleteCargo(),


        SizedBox(height: 20),
      ],
    );
  }
  Widget incompleteCargo(){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 20),
                  Text(
                    (widget.deliveryId.startsWith("L"))?
                    'Cartons Loaded': 'Cartons Delivered',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontStyle: FontStyle.italic),
                  ),
                  if(_numberCartonsController.text.trim().isEmpty)
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
                      left: 20.0, right: 20.0),
                  child: TextField(
                    controller: _numberCartonsController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Only numbers allowed
                    ],
                    maxLines:1, // Allow text to wrap to the next line
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: (widget.deliveryId.startsWith("L"))?'Enter actual number of cartons loaded':
                      'Enter actual number of cartons delivered',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(5.0),
                          // Adjust the top border radius
                          bottom: Radius.circular(0),
                        ),
                      ),// Add border
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
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 20),
                  Text(
                    'Why is the number of cartons incomplete?',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontStyle: FontStyle.italic),
                  ),
                  if(_missingCartonsController.text.trim().isEmpty)
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
                      left: 20.0, right: 20.0),
                  child: TextField(
                    controller: _missingCartonsController,
                    maxLines:
                    null, // Allow text to wrap to the next line
                    textInputAction: TextInputAction
                        .newline, // Enable Return key to insert a newline
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(5.0),
                          // Adjust the top border radius
                          bottom: Radius.circular(0),
                        ),
                      ),// Add border
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
          ),
        ),

      ],
    );
  }





//second page widgets
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
            if(_departedSelectedTime == null || _departedSelectedDate == null)
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
                      hintText: (_departedSelectedDate==null)
                        ?'Enter date departed from location'
                        :DateToString(_departedSelectedDate!),
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
                      _departedSelectedDate = value;
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
                      hintText: (_departedSelectedTime==null)
                      ?'Enter time departed location'
                      :TimeToString(_departedSelectedTime!),
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
                        _departedSelectedTime = null;
                      } else {
                        _departedSelectedTime =
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


  //validation
  bool validate(){
    bool complete =false;
    if(selectedMembers.isNotEmpty && _arrivalSelectedTime != null && _arrivalSelectedDate != null){
      if(completeCargo=='No'){
        if(_missingCartonsController.text.trim().isNotEmpty&&_numberCartonsController.text.trim().isNotEmpty){
          complete = true;
        }
      }
      else if(completeCargo=='Yes'){
        complete = true;
      }
    }
    return complete;

  }
  void nextPage() {
    Timestamp arrivalTimeDate = changeTimestamps(_arrivalSelectedDate!, _arrivalSelectedTime!);
    Timestamp departedTimeDate = changeTimestamps(_departedSelectedDate!, _departedSelectedTime!);

    int numberCartonsController = int.tryParse(_numberCartonsController.text)??0;



    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SendSuccessfulReport(
          deliveryId: widget.deliveryId,
          orderId:  widget.orderId,
          team:  selectedMembers,
          arrivalTimeAndDate: arrivalTimeDate,
          completeCartons: (completeCargo=='Yes')?true:false,
          reasonIncomplete: _missingCartonsController.text.trim(),
          numberCartons: (completeCargo=='Yes')?numberCartons:numberCartonsController,
          recipientName: recipientName.text.trim(),
          signatory: _signatory?? XFile(''),
          documentation: _documentation?? XFile(''),
          departureTimeAndDate: departedTimeDate,
        nextDeliveryId: widget.nextDeliveryId,)),
    );
  }


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


