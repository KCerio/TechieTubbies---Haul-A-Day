import 'package:flutter/material.dart';
import 'package:haul_a_day_web/newUI/components/addTruckDialog.dart';
import 'package:haul_a_day_web/service/database.dart';

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

  void selectTruck(Map<String, dynamic> truckSelect){
    truckPanel(truckSelect);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print('Trucks: ${_trucks.length}');

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
                  color: Colors.green.shade50,
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
        setState(() {
          if(selectaTruck == false){
            selectedTruck = aTruck;
            selectaTruck = true;
          }
          else if(selectaTruck == true && selectedTruck == aTruck){
            selectedTruck = {};
            selectaTruck = false;
          } else if(selectaTruck == true && selectedTruck != aTruck){
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
                    onPressed: (){},
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
  Widget truckPanel(Map<String, dynamic> aTruck){
    //Size size = MediaQuery.of(context).size;
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                size: 35, color: Colors.black),
                            onPressed: () {
                              setState(() {
                                if(selectaTruck == false){
                                  selectedTruck = aTruck;
                                  selectaTruck = true;
                                }
                                else if(selectaTruck == true){
                                  selectedTruck = {};
                                  selectaTruck = false;
                                }
                              });
                            },
                          ),
                          // Add other widgets to the app bar as needed
                        ],
                      ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(100, 10, 100, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: aTruck['truckPic'] != null ? Image.network(aTruck['truckPic'],
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover, // Adjust the fit as needed
                            )
                            : Image.asset('images/truck.png',
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover, // Adjust the fit as needed
                            ),
                          ),
                        ),
                        Text(
                            aTruck['id'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                        ),
                        const Text(
                          'Edit Details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.red,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height:10
                        ),
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
                        Container(
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: const BorderRadius.horizontal(),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundImage:
                                AssetImage('images/user_pic.png',),
                                radius: 30.0,
                              ),
                              const SizedBox(width: 10.0),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Employee Name',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const Text(
                                    'Staff ID',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  const Text(
                                    'Position',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  const Text(
                                    'Date',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Container(
                                    margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                    height: 2,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: const BorderRadius.horizontal(),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundImage:
                                AssetImage('images/user_pic.png',),
                                radius: 30.0,
                              ),
                              const SizedBox(width: 10.0),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Employee Name',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const Text(
                                    'Staff ID',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  const Text(
                                    'Position',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  const Text(
                                    'Date',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Container(
                                    margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                    height: 2,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  
              // Add the Delivery History text here
              const Text(
                'Delivery History',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                  ),
                  const Text(
                    'Filter By:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 25,
                    width: 100,
                    decoration: const BoxDecoration(
                      color: Colors.grey, // Set the background color here
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(3),
                          right: Radius.circular(
                              3)), // Optional: Add border radius
                    ),
                    child: DropdownButton<String>(
                      value: 'Delivery Id',
                      onChanged: (String? newValue) {
                        // Handle dropdown value change
                      },
                      items: <String>['Delivery Id']
                          .map<DropdownMenuItem<String>>(
                            (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                  color: Colors.black), // Set text color
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Container(
                // height:110,
                // width:320,
                color: Colors.lightGreen.shade400,
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15),
                    ),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text('Delivery',
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold)),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                height: 1.0,
                                color: Colors.orange,
                              ),
                              const Text('2023054'),
                              const Text('2023053'),
                              const Text('2023052'),
                              const Text('2023051'),
                              const Text('2023050'),
                            ])),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('Customer',
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold)),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                height: 1.0,
                                color: Colors.orange,
                              ),
                              const Text('GDC523'),
                              const Text('GDL897'),
                              const Text('GDC523'),
                              const Text('GDL897'),
                              const Text('GDC523'),
                            ])),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Date',
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold)),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                height: 1.0,
                                color: Colors.orange,
                              ),
                              const Text('12-16-2023'),
                              const Text('12-16-2023'),
                              const Text('12-15-2023'),
                              const Text('12-15-2023'),
                              const Text('12-15-2023'),
                            ])),
                    const SizedBox(width: 15),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Incident Reports',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                  ),
                  const Text(
                    'Filter By:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 25,
                    width: 100,
                    decoration: const BoxDecoration(
                      color: Colors.grey, // Set the background color here
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(3),
                          right: Radius.circular(
                              3)), // Optional: Add border radius
                    ),
                    child: DropdownButton<String>(
                      value: 'Delivery Id',
                      onChanged: (String? newValue) {
                        // Handle dropdown value change
                      },
                      items: <String>['Delivery Id']
                          .map<DropdownMenuItem<String>>(
                            (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                  color: Colors.black), // Set text color
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Container(
                color: Colors.lightGreen.shade400,
                // height:110,
                // width:320,
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text('DATE ',
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold)),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                height: 1.0,
                                color: Colors.orange,
                              ),
                              const Text('11-14-2023'),
                              const SizedBox(height: 1),
                              const Text('10-05-2023'),
                              const SizedBox(height: 1),
                              const Text('05-04-2023'),
                              const SizedBox(height: 1),
                              const Text('05-01-2023'),
                              const SizedBox(height: 1),
                              const Text('12-20-2022'),
                              const SizedBox(height: 1),
                            ])),
                    const SizedBox(height: 1),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('DESCRIPTION',
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold)),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                height: 1.0,
                                color: Colors.orange,
                              ),
                              const Text('Broken Bumper',),
                                  //style: TextStyle(fontSize: 12)),
                              const SizedBox(height: 1),
                              const Text('Accident during delivery',),
                                  //style: TextStyle(fontSize: 11)),
                              const SizedBox(height: 1),
                              const Text('Flat Tire', ),
                              //style: TextStyle(fontSize: 12)),
                              const SizedBox(height: 1),
                              const Text('Broken Headlights',),
                                  //style: TextStyle(fontSize: 12)),
                              const SizedBox(height: 1),
                              const Text('Unstable Breaks',),
                                  //style: TextStyle(fontSize: 12)),
                            ])),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('REMARK',
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold)),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                height: 1.0,
                                color: Colors.orange,
                              ),
                              const Text('On-Repair'),
                              const SizedBox(height: 1),
                              const Text('Unsuccessful'),
                              const SizedBox(height: 1),
                              const Text('Unsuccessful'),
                              const SizedBox(height: 1),
                              const Text('On-Repair'),
                              const SizedBox(height: 1),
                              const Text('On_repair'),
                        ]
                      )
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}