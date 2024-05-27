import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/newUI/components/dialogs/addTruckDialog.dart';
import 'package:haul_a_day_web/newUI/truckPage/editTruckDialog.dart';
import 'package:haul_a_day_web/newUI/truckPage/truckInfo.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:haul_a_day_web/service/userService.dart';

import 'truckPage/deliveryHistory.dart';
import 'truckPage/incidentReport.dart';

class TruckList extends StatefulWidget {
  const TruckList({super.key});

  @override
  State<TruckList> createState() => _TruckListState();
}

class _TruckListState extends State<TruckList> {

  bool selectaTruck = false;
  Map<String, dynamic> selectedTruck = {};
  List<Map<String, dynamic>> _trucks = [];

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
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void selectTruck(Map<String, dynamic> truckSelect)  {
    truckPanel(truckSelect);

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
                    padding: EdgeInsets.fromLTRB(50, 16, 16, 20),
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
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                    fillColor: const Color.fromRGBO(199, 196, 196, 0.463),
                                    filled: true,
                                    hintText: "Search Truck",
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
                        Container(
                          width:200,
                          alignment: Alignment.centerLeft,
                          padding:
                          const EdgeInsets.fromLTRB(
                              25, 2, 30, 0),
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    contentPadding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0), // Set the border radius for the dialog
                                    ),
                                    content: AddTruckDialog(),
                                  );
                                },
                              );
                            },
                            child: Row(
                              children: [
                                Icon(Icons.add_box, color: Colors.white,),
                                SizedBox(width: 5,),
                                Text('Add truck', style: TextStyle(color: Colors.white))
                              ],
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
                        //const SizedBox(height: 20),
                        Container(
                            height: size.height*0.68,
                            child: _trucks.isEmpty
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
                              content:  Text('Do you wish to remove this truck?'),
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
    print('YUH :${aTruck['id']}');

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
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.cover, // Adjust the fit as needed
                  )
                      : Image.asset(
                    'images/truck.png',
                    width: 200.0,
                    height: 200.0,
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

                  TextButton(onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return EditTruck(truck: aTruck, onUpdate: update);
                      },
                    );
                  },

                      child: Text(
                        'Edit Details',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.red,
                            fontSize: 16),
                      ))

                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              height: 2,
              color: Colors.black,
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: Container(
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Staff History',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
            staffHistoryContainer(),
            staffHistoryContainer(),

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

  Widget staffHistoryContainer() {
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: const BorderRadius.horizontal(),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('images/user_pic.png'),
            radius: 30.0,
          ),
          const SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Employee Name',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const Text(
                'Staff ID',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Text(
                'Position',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Text(
                'Date',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                height: 2,
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void update(){
    setState(() {

    });
  }

}