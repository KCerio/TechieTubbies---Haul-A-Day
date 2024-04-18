import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haul_a_day_mobile/bottomTab.dart';
import 'package:haul_a_day_mobile/deliveryTab/delivery_tab.dart';
import 'package:haul_a_day_mobile/deliveryTab/unloading_successful_reports/next_unloading_delivery_report_successful.dart';

class teamMember{
  final String staffId;
  final String fullname;
  final String position;
  final String pictureUrl;
  bool isSelected;

  teamMember(this.staffId, this.fullname, this.position, this.pictureUrl, this.isSelected) {
  }


}

class UnloadingDeliveryReportSuccessful extends StatefulWidget {

  final UnloadingDelivery unloadingDelivery;
  final String orderId;
  final UnloadingDelivery? nextDelivery;
  final String loadingDeliveryId;

  const UnloadingDeliveryReportSuccessful({Key? key,
    required this.unloadingDelivery,
    required this.orderId,
    required this.nextDelivery, required this.loadingDeliveryId,
  }) : super(key: key);

  @override
  _UnloadingDeliveryReportSuccessfulState createState() =>
      _UnloadingDeliveryReportSuccessfulState();
}



class _UnloadingDeliveryReportSuccessfulState extends State<UnloadingDeliveryReportSuccessful> {
  int _currentIndex = 1;
  int progress = 0;
  Color defaultColor = Colors.grey; // Default color
  Color pressedColor = Colors.blue[700]!; // Color when pressed


  List<teamMember> teamList = [];
  List<teamMember> selectedMembers = [];

  DateTime? _selectedDate = null;
  TimeOfDay? _selectedTime = null;

  String completeCargo='';
  TextEditingController _missingCartonsController = TextEditingController();
  TextEditingController _numberCartonsController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await getTeamList(widget.orderId);

    setState(() {}); // Update the UI with the retrieved data
  }

  void updateProgress() {
    int newProgress = 0;

    if (selectedMembers.isNotEmpty) newProgress += 10;
    if (_selectedTime != null) newProgress += 10;
    if (_selectedDate != null) newProgress += 10;
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
                                widget.unloadingDelivery.unloadingId,
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
                        if(progress==40){
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


  Future<void> getTeamList(String orderId) async {
    try {
      // Query the Firestore collection "Orders/orderId/truckTeam"
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Order/${widget.orderId}/truckTeam')
          .get();

      // Iterate through the documents to extract staffIds and other information
      List<String> staffIds = querySnapshot.docs.map((doc) => doc.id).toList();

      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('staffId', whereIn: staffIds)
          .get();

      // Create teamMember objects with fullname and position and add them to the list
      userSnapshot.docs.forEach((userDoc) {
        String staffId = userDoc['staffId'];
        String firstname = userDoc['firstname'];
        String lastname = userDoc['lastname'];
        String fullname = '$firstname $lastname';
        String position = userDoc['position'];
        String pictureUrl = userDoc['pictureUrl'];
        bool isSelected = false; // Assuming 'position' is a field in the Users collection

        teamMember member = teamMember(
            staffId, fullname, position, pictureUrl, isSelected);
        teamList.add(member);
      });
    } catch (e) {
      print('Error fetching team members: $e');
      // Hand
    }
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
                      hintText: 'Enter date arrived at location',
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
                      hintText: 'Enter time arrived at location',
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
                    '${widget.unloadingDelivery.quantity} cartons delivered?',
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
                    'Cartons Delivered',
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
                      hintText: 'Enter actual number of cartons delivered',
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

  void moveToNextPage() {
    if (_selectedDate != null && _selectedTime != null) {
      DateTime selectedDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      Timestamp arrivalDateAndTime = Timestamp.fromDate(selectedDateTime);

      int numberCartons = int.tryParse(_numberCartonsController.text)??0;

      // numberCartons: (completeCargo=='Yes')?widget.loadingDelivery.totalCartons:numberCartons,

      Navigator.push(context, MaterialPageRoute(builder: (context)=> NextUnloadingDeliveryReportSuccessful(
          unloadingDelivery: widget.unloadingDelivery,
          orderId: widget.orderId,
          team: selectedMembers,
          nextDelivery: widget.nextDelivery,
          arrivalTimeAndDate: arrivalDateAndTime,
          completeCartons: (completeCargo=='Yes')?true:false,
          reasonIncomplete: _missingCartonsController.text.trim(), loadingDeliveryId: widget.loadingDeliveryId,
        numberCartons: (completeCargo=='Yes')?widget.unloadingDelivery.quantity:numberCartons,)));
    }




  }
}


