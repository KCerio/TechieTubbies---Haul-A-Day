import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:haul_a_day_web/service/userService.dart';
import 'package:haul_a_day_web/web_Pages/truckList/addTruckDialog.dart';
import 'package:haul_a_day_web/web_Pages/truckList/truckInfoPanel/deliveryHistory.dart';
import 'package:haul_a_day_web/web_Pages/truckList/truckInfoPanel/editTruckDialog.dart';
import 'package:haul_a_day_web/web_Pages/truckList/truckInfoPanel/incidentReport.dart';
import 'package:haul_a_day_web/web_Pages/truckList/truckInfoPanel/truckTeam.dart';



class TruckList extends StatefulWidget {
  const TruckList({super.key});

  @override
  State<TruckList> createState() => _TruckListState();
}

class _TruckListState extends State<TruckList> {

  bool selectaTruck = false;
  Map<String, dynamic> selectedTruck = {};
  List<Map<String, dynamic>> _trucks = [];
  List<Map<String, dynamic>> alltrucks = [];
  String searchQuery = '';
  TextEditingController _searchcontroller = TextEditingController();
  bool notExist = false;

  @override
  void initState() {
    super.initState();
    _initializeTruckData();

  }

  Future<void> _initializeTruckData() async {
    try {
      DatabaseService databaseService = DatabaseService();
      List<Map<String, dynamic>> trucks = await databaseService.fetchAllTruckList();
      setState(() {
        _trucks = trucks;
        alltrucks = _trucks;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void selectTruck(Map<String, dynamic> truckSelect)  {
    truckPanel(truckSelect);

  }

  void searchStaff(List<Map<String, dynamic>> originalList, String searchQuery) {
    List<Map<String, dynamic>> filteredList = [];
    if(searchQuery != ''){
      // Convert the search query to lowercase for case-insensitive matching
      final query = searchQuery.toLowerCase();

      // Filter the original list based on the search query
      filteredList = originalList.where((map) {
        // Iterate through each key-value pair in the map
        // and check if any value contains the search query
        return map.values.any((value) {
          if (value is String) {
            // If the value is a string, check if it contains the search query
            return value.toLowerCase().contains(query);
          }
          // If the value is not a string, convert it to a string and check if it contains the search query
          return value.toString().toLowerCase().contains(query);
        });
      }).toList();
      print("Searched List: $filteredList");
      
    }

    if(filteredList.isEmpty){
      setState(() {
        notExist = true;
      });
    }
    else{
      setState(() {
        _trucks = filteredList;
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              child: Row(
                children: [
                  // Left side
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(50, 16, 16, 20),
                      child: LayoutBuilder(
                        builder: (context,constraints) {
                          double width = constraints.maxWidth;
                          return Column(
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
                                      'Truck List',
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontFamily: 'Itim',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  const Spacer(),
                                        
                                  //Search Bar
                                  Row(
                                    children: [
                                      Container(
                                        width: width*0.35,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 232, 227, 227), // White background color
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: TextField(
                                          controller: _searchcontroller,
                                          onSubmitted: (_){
                                            searchStaff(_trucks, _searchcontroller.text);
                                          },
                                          onChanged: (value){
                                            if(value == ''){
                                              setState(() {
                                                //if(_selectedFilter == ''){_selectedFilter = 'All';}
                                                _trucks = alltrucks;
                                                notExist = false;
                                              });
                                            }
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Search...',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: BorderSide.none, // Hide border
                                            ),
                                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 87, 189, 90), // Blue color for the search icon button
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            // Implement search functionality here
                                            searchStaff(_trucks, _searchcontroller.text);
                                          },
                                          icon: Icon(Icons.search),
                                          color: Colors.white, // White color for the search icon
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20,)
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Container(
                                width:width,
                                alignment: Alignment.centerRight,
                                padding:
                                    const EdgeInsets.fromLTRB(
                                        25, 2, 30, 0),                                
                                child: ElevatedButton(
                                  onPressed: () async{
                                    Map<String, dynamic>? newTruck = await showDialog<Map<String, dynamic>>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          contentPadding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                          ),
                                          content: AddTruckDialog(
                                            newTruck: (value) {
                                              Navigator.of(context).pop(value); // Close the dialog and return the assigned value
                                            },
                                          ),
                                        );
                                      },
                                    );
                          
                                    if(newTruck != null){
                                      setState(() {
                                        _trucks.add(newTruck);
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 100,
                                    
                                    child: Row(
                                      children: [
                                        Icon(Icons.add_box, color: Colors.white,),
                                        SizedBox(width: 5,),
                                        Text('Add truck', style: TextStyle(color: Colors.white))
                                      ],
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(76, 175, 80, 1)),
                                    foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 0, 0, 0)),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5), // Set the border radius for the button
                                      ),
                                    ),
                                  ),
                                ),
                                        
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: size.height*0.68,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                ),
                                child: _trucks.isEmpty && notExist == false
                                  ? Container(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator()
                                    )
                                : notExist == true 
                                ? Container(
                                  alignment: Alignment.topCenter,
                                  padding: EdgeInsets.only(top: 50),
                                  width: width,
                                  child: Text('Truck does not exist.',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                      ), 
                                    ),
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
                                          itemCount: _trucks.length,
                                          itemBuilder: (context, index) {
                                            return buildTruckContainer(_trucks[index]);
                                          },
                                        ),
                                      ],
                                    )
                                  ),
                                )
                              ),
                              //const SizedBox(height: 20),
                                        
                            ],
                          );
                        }
                      ),
                    ),
                  ),
                  // Right panel for Truck
                  Expanded(
                    flex: 4,
                    child: selectaTruck == true
                    ? Container(
                      height: size.height*0.87,
                      color: Colors.white,
                      child: truckPanel(selectedTruck)
                      )
                    :Container(
                      height: size.height*0.87,
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical:50),
                      child: unselectedRightPanel()
                      )
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );

  }

  //for the list
  Widget buildTruckContainer(Map<String, dynamic> aTruck){
    return InkWell(
      onTap:(){
        setState(()  {
          if(selectaTruck == false){
            selectedTruck = aTruck;
            selectaTruck = true;
          }
          else if(selectaTruck == true && selectedTruck == aTruck){
            selectedTruck = {};
            selectaTruck = false;
          }
          else if(selectaTruck == true && selectedTruck != aTruck){
            selectaTruck = false;
            selectedTruck = aTruck;
            selectaTruck = true;

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
              backgroundImage: aTruck['truckPic'] != null ? NetworkImage(aTruck['truckPic']) : Image.asset('images/truck.png').image,
            ),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  aTruck['id'],
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight:
                      FontWeight.bold,
                      color:
                      Colors.black),
                ),
                Text(
                  'Cargo Type: ${aTruck['cargoType']}',
                  style: const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                      color:
                      Colors.black),
                ),
                Text(
                  'Truck Type: ${aTruck['truckType']}',
                  style: const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                      color:
                      Colors.black),
                ),
                Text(
                  'Max Capacity: ${aTruck['maxCapacity']} kgs',
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
                    aTruck['truckStatus'],
                    style:TextStyle(
                        fontWeight: FontWeight.bold,
                        color: aTruck['truckStatus'] == 'Available' ? Colors.green
                        : Colors.grey,
                        fontSize:20
                      ),
                  ),
                  const SizedBox(height: 10),

                  const SizedBox(height: 10),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content:  Text('Do you wish to remove ${aTruck['id']}?'),
                            actions: [
                              TextButton(
                                onPressed: () async{
                                  //confirmApproval();
                                  setState(() {
                                    selectaTruck = false;
                                    selectedTruck = {};
                                    _trucks.remove(aTruck);
                                  });
                                  UserService userService = UserService();
                                  userService.removeTruck(aTruck['id']);
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                child: Text('Yes'),
                              ),
                              const SizedBox(width: 8,),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                child: Text('No'),
                              ),
                            ]
                          );
                        },
                      );
                    },
                  ),
                ]),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }

  Widget unselectedRightPanel(){
    return Container(
      //height: 450,
      //margin: const EdgeInsets.fromLTRB(50, 100, 50, 100),
      //padding: const EdgeInsets.fromLTRB(50, 100, 50, 100),
      color: Colors.yellow[100],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_shipping,
              size: 50, color: Colors.black),
          SizedBox(height: 10),
          Text(
            'Select a Truck',
            style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  //truckPanel Side
  Widget truckPanel(Map<String, dynamic> aTruck) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 35, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      selectedTruck = {};
                      selectaTruck = false;
                    });
                  },
                ),
                // Add other widgets to the app bar as needed
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(100, 10, 100, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: aTruck['truckPic'] != null
                      ? Image.network(
                    aTruck['truckPic'],
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover, // Adjust the fit as needed
                  )
                      : Image.asset(
                    'images/truck.png',
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover, // Adjust the fit as needed
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    aTruck['id'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                  ),
                  InkWell(
                    onTap: ()async {
                      Map<String, dynamic>? updates = await showDialog<Map<String, dynamic>>(
                        context: context,
                        builder: (BuildContext context) {
                          return EditTruck(
                            truck: aTruck, 
                            onUpdate: (value){
                               Navigator.of(context).pop(value);
                            }
                          );
                        },
                      );

                      if(updates != null){
                        setState(() {
                          aTruck = updates;
                          selectaTruck = false;
                          selectedTruck = {};
                          //aTruck['driver'] = updates['driver'];
                        });
                      }
                    },
                    child: Text(
                      'Edit Details',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.red,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              height: 2,
              color: Colors.black,
            ),

            Container(
              height: MediaQuery.sizeOf(context).height*0.3,
              child: TruckTeamList(driver: aTruck['driver']),
            ),

            Container(
              height: MediaQuery.sizeOf(context).height*0.3,
              child: IncidentReport(truckId: aTruck['id']),
            ),
            const SizedBox(height: 20),
            Container(
              height: MediaQuery.sizeOf(context).height*0.3,
              color: Colors.white,
              child: DeliveryHistory(truckId: aTruck['id']),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }


}