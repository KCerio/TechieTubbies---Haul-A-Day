import 'package:flutter/material.dart';
import 'package:haul_a_day_web/service/database.dart';

class StaffList extends StatefulWidget {
  const StaffList({super.key});

  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {

  List<Map<String, dynamic>> _staffs = [];
  Map<String, dynamic> selectedStaff = {};
  bool selectaStaff = false;

  @override
  void initState() {
    super.initState();
    _initializeStaffData();
    
  }

  Future<void> _initializeStaffData() async {
    try {
      DatabaseService databaseService = DatabaseService();
      List<Map<String, dynamic>> staffs = await databaseService.fetchStaffList();
      setState(() {
        _staffs = staffs;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              // Left side
              Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(50, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding:
                                EdgeInsets.only(
                                    left: 10.0),
                            child: Text(
                              'Staff List',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontFamily: 'Itim',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          const Spacer(),

                          //Search Bar
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                fillColor: const Color.fromRGBO(199, 196, 196, 0.463),
                                filled: true,
                                hintText: "Search Staff",
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                suffixIcon: InkWell(
                                  onTap:(){},
                                  child:const Icon(Icons.search, color: Colors.black,)
                                )                    
                              ),                    
                            ),
                          ),
                          SizedBox(width: 20,)
                        ],
                      ),
                      //const SizedBox(height: 10,),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(
                                25, 2, 0, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Add truck functionality here
                          },
                          style:
                              ElevatedButton.styleFrom(
                            shape:
                                const RoundedRectangleBorder(
                              borderRadius: BorderRadius
                                  .horizontal(
                                left:
                                    Radius.circular(2),
                                right:
                                    Radius.circular(2),
                              ),
                            ),
                            backgroundColor: Colors
                                    .grey[
                                300], // Background color of the button
                            elevation: 0,
                          ),
                          child: const Text(
                            'Add New Staff',
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: size.height*0.68,
                        child: _staffs.isEmpty 
                          ? Container(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator()
                            ) 
                        : Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                //thy list creates the containers for all the trucks
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(), // you can try to delete this
                                  itemCount: _staffs.length,
                                  itemBuilder: (context, index) {
                                    return buildStaffContainer(_staffs[index]);
                                  },
                                ),
                              ],
                            )
                          ),
                        )
                      ),
                      //const SizedBox(height: 20),
                                          
                    ],
                  ),
                ),
              ),
              // Right panel for Truck
              Expanded(
                flex: 4,
                child: selectaStaff == true 
                ? Container(
                  height: size.height*0.87,
                  color: Colors.green.shade50,
                  child: staffPanel(selectedStaff)
                  )
                :Container(
                  height: size.height*0.87,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical:50),
                  child: unselectedRightPanel()
                  )
              ),
            ],
          );
        }
      ),
    );
                      
  }

  //for the list
  Widget buildStaffContainer(Map<String, dynamic> aStaff){
    return InkWell(
      onTap: (){
        setState(() {
          if(selectaStaff == false){
            selectedStaff = aStaff;
            selectaStaff = true;
          }
          else if(selectaStaff == true && selectedStaff == aStaff){
            selectedStaff = {};
            selectaStaff = false;
          } else if(selectaStaff == true && selectedStaff != aStaff){
            selectaStaff = false;
            selectedStaff = aStaff;
            selectaStaff = true;
          }
        });
      },
      child: Container(
        width: 500,
        margin: const EdgeInsets.fromLTRB(
            40, 10, 40, 10),
        padding: const EdgeInsets.fromLTRB(
            10, 0, 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Colors.black),
        ),
        child: Row(
          children: [
            //truckPicture
            CircleAvatar(
              radius: 40,
              backgroundColor:
              Colors.white,
              backgroundImage: aStaff['pictureUrl'] != null ? NetworkImage(aStaff['pictureUrl']): Image.asset('images/user_pic.png').image,
            ),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  '${aStaff['firstname']} ${aStaff['lastname']}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Colors.black),
                ),
                Text(
                  'Staff ID: ${aStaff['staffId']}',
                  style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Colors.black),
                ),
                Text(
                  'Position: ${aStaff['position']}',
                  style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Colors.black),
                ),
              ],
            ),
            const Spacer(),
            Column(
                crossAxisAlignment:
                CrossAxisAlignment.end,
                children: [
                  Text(
                    aStaff['assignedSchedule'] == 'none' || aStaff['assignedSchedule'] == null
                        ? 'Available'        
                          : 'Busy',
                    style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        color:
                            Colors.green,
                        fontSize: 20
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    aStaff['assignedSchedule'] == 'none' || aStaff['assignedSchedule'] == null
                        ? ''        
                          : aStaff['assignedSchedule'] ,
                    style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        color:
                            Colors.black),
                  ),
                  const SizedBox(height: 10),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: (){},
                  ),
                ]),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }

  // unselected Right Panel
  Widget unselectedRightPanel(){
    return Expanded(
      child: Container(                              
        //height: 450,                              
        //margin: const EdgeInsets.fromLTRB(20, 50, 20, 20),
        //padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
        color: Colors.yellow[100],
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.face_4_rounded,
                size: 50, color: Colors.black),
            SizedBox(height: 10),
            Text(
              'Select an Employee',
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // selected staff right panel
  Widget staffPanel(Map<String, dynamic> aStaff){
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width *0.5,
      color: Colors.green.shade50,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back,
                    size: 35, color: Colors.black),
                onPressed: () {
                  setState(() {
                    if(selectaStaff == false){
                      selectedStaff = aStaff;
                      selectaStaff = true;
                    }
                    else if(selectaStaff == true){
                      selectedStaff = {};
                      selectaStaff = false;
                    }
                  });
                },
              ),
              // Add other widgets to the app bar as needed
            ],
          ),
            SizedBox(height: 40),
            Positioned(
              left: 100,
              child: Container(
                width: 150.0,
                height: 150.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: aStaff['pictureUrl'] != null ? Image.network(aStaff['pictureUrl'],
                    fit: BoxFit.cover,)
                  : Image.asset(
                    'images/user_pic.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '${aStaff['firstname']} ${aStaff['lastname']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 250,
              color: Colors.grey.shade400,
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text('Staff ID: ${aStaff['staffId']}',
                          style:
                              TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('Username: ${aStaff['userName']}',
                          style:
                              TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('Position: ${aStaff['position']}',
                          style:
                              TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('Registered Date: ${aStaff['registeredDate']}',
                          style:
                              TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('Contact Number: ${'contactNumber'}',
                          style:
                              TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('Email',
                          style:
                              TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(100, 50, 0, 30),
                child: ElevatedButton(
                  onPressed: () {
                    // Remove truck functionality here
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(2),
                        right: Radius.circular(2),
                      ),
                    ),
                    backgroundColor: Colors
                        .grey[300], // Background color of the button
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  }