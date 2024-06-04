import 'package:flutter/material.dart';
import 'package:haul_a_day_web/authentication/constant.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:provider/provider.dart';

class AssignDialog extends StatefulWidget {
  final Map<String,dynamic> order;
  final bool forHalt;
  //final TabSelection currentTab;
  final Function(String?) onAssigned;
  const AssignDialog({super.key, required this.order, required this.onAssigned, required this.forHalt});

  @override
  State<AssignDialog> createState() => _AssignDialogState();
}

class _AssignDialogState extends State<AssignDialog> {
  String? assignedValue; // State variable to hold the assigned value

  DatabaseService databaseService = DatabaseService();

  bool isCheck = false;
  List<String> _truckAvailable = [];
  List<String> _helpersAvailable = [];
  String? _selectedTruck;
  String? _selectedCrew1;
  String? _selectedCrew2;
  Map<String,dynamic> order = {};
  
  @override
  void initState(){
    super.initState();
    setState(() {
      order = widget.order;
    });
    getDetails();
  }

  Future<void> getDetails()async{
  // Fetch order details
  try {
    List<String> truckAvailable = await databaseService.getAvailableTruckDocumentIds(order['cargoType']);
    List<String> helpersAvailable = await databaseService.getAvailableCrewIds();
    print(truckAvailable);
    setState(() {
      _truckAvailable = truckAvailable;
      _helpersAvailable = helpersAvailable;
    });
  } catch (e) {
    print('Failed to fetch order details: $e');
  }
    
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: 700,
      height: 800,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
      child: Column(
        children: [
           Expanded(
            flex: 2,
            child: Container(
              //color: Colors.green,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black, )
                )
              ),
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.fromLTRB(25, 16, 0, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/logo2_trans.png'),
                  const SizedBox(width: 50,),
                  Container(
                    // decoration: BoxDecoration(
                    //   border: Border.all(color: Colors.black)
                    // ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text('Assign Delivery Schedule',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter' 
                        ),
                        ),
                        const SizedBox(height:5),
                        Text('Choose the truck and crew to be assigned to \ndelivery the said order',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'InriaSans' 
                        ),
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                  icon: Icon(Icons.close)
                ),
                const SizedBox(width: 10,)
                ],
              )
            ),
          ),
          Expanded(
            flex:8,
            child: _truckAvailable.isEmpty 
            ? Container(
              width: 700,
              height: 600,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
            : Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  width: 700,
                  height: 215,
                  //color: Colors.green,
                  child: Column(
                    children: [
                      //Order details title
                      Container(
                        width: 520,
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Order Details",
                              style: TextStyle(
                                fontFamily: 'InriaSans',
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Order ID: ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'InriaSans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  order['id'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'InriaSans',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 500,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color.fromRGBO(56, 113, 193, 1)),
                          borderRadius: BorderRadius.circular(10),
                          //color:Color.fromRGBO(190, 216, 253, 1)
                        ),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(bottom: 12),
                              width: 249,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              //color: Colors.blue,
                              // decoration: BoxDecoration(
                              //   border: Border(left: BorderSide(color: Color.fromRGBO(56, 113, 193, 1)))
                              // ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Customer:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Arial',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                        '${order['company_name'] ?? ''}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Arial',
                                        ),
                                      ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Cargo Type:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Arial',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                        order['cargoType'] == 'fgl'
                                          ? 'frozen cargo'
                                          : order['cargoType'] == 'cgl'
                                              ? 'dry cargo'
                                              : '',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Arial',
                                        ),
                                      ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Weight:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Arial',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                        '${order['totalWeight']} kgs',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Arial',
                                        ),
                                      ),
                                      ),
                                    ],
                                  ),
                                        //Text('Other Rate'),
                                ],
                              )
                            ),
                          
                    
                            Container(
                              alignment: Alignment.center,
                              width: 249,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              //color: Colors.blue,
                              // decoration: BoxDecoration(
                              //   border: Border(left: BorderSide(color: Color.fromRGBO(56, 113, 193, 1)))
                              // ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Date:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Arial',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                        '${order['loadingDate'] ?? ''}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Arial',
                                        ),
                                      ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Time:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Arial',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                        '${order['loadingTime'] ?? ''}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Arial',
                                        ),
                                      ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Route:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Arial',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                        '${order['route'] ?? ''}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Arial',
                                        ),
                                      ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  width: 700,
                  height: 300,
                  //color: Colors.blue,
                  // decoration: BoxDecoration(
                  //   border: Border(top: BorderSide(color:Colors.grey))
                  // ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Wish to order to a truck team?
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 700,
                        child: Text(
                          'Wish to assign schedule to a truck team?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontStyle: FontStyle.italic
                          ),
                        ),
                      ),
                      const SizedBox(height: 5,),
                      //Assigning
                      Container(
                        alignment: Alignment.center,
                        width: 600,
                        height: 180,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.black)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(                      
                              alignment: Alignment.center,
                              width: 480,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Center the Row contents
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Assign Truck:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Arial',
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  //const SizedBox(width: 20),
                                  Container(
                                    height: 40,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedTruck,
                                        items: _truckAvailable.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(value),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedTruck = newValue;
                                            //truck = _selectedCrew1!;
                                          });
                                        },
                                        icon: const Icon(Icons.arrow_drop_down), // Add dropdown icon
                                        style: const TextStyle(
                                          fontSize: 14, // Set the font size of the selected item
                                          fontFamily: 'Arial',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: 480,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Center the Row contents
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Assign Helper 1:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Arial',
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  //const SizedBox(width: 10),
                                  Container(
                                    height: 40,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedCrew1,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedCrew1 = newValue;
                                            //crew1 = newValue!;
                                          });
                                        },
                                        items: _helpersAvailable.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(value),
                                            ),
                                          );
                                        }).toList(),
                                        icon: const Icon(Icons.arrow_drop_down), // Add dropdown icon
                                        style: const TextStyle(
                                          fontSize: 14, // Set the font size of the selected item
                                          fontFamily: 'Arial',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: 480,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Center the Row contents
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Assign Helper 2:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Arial',
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  //const SizedBox(width: 10),
                                  Container(
                                    height: 40,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedCrew2,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedCrew2 = newValue;
                                            //crew2 = newValue!;
                                          });
                                        },
                                        items: _selectedCrew1 != null
                                            ? _helpersAvailable
                                                .where((element) => element != _selectedCrew1)
                                                .map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(value),
                                                    ),
                                                  );
                                                }).toList()
                                            : _helpersAvailable.map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(value),
                                                  ),
                                                );
                                              }).toList(),
                                        icon: const Icon(Icons.arrow_drop_down), // Add dropdown icon
                                        style: const TextStyle(
                                          fontSize: 14, // Set the font size of the selected item
                                          fontFamily: 'Arial',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20,),

                      //Confirmation
                      Container(
                        width: 700,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                            value: isCheck,
                            onChanged: (newValue) {
                              setState(() {
                                
                                isCheck = newValue!;
                              });
                            },
                          ),
                            const Text(
                              'Confirm Schedule Assignment',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Arial',
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                      const SizedBox(height:10),
                      Container(
                        width: 700,
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: ()async {
                            // Handle button press
                            if(_selectedTruck == null ||
                                _selectedCrew1 == null ||
                                _selectedCrew2 == null ||
                                !isCheck){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Alert'),
                                    content: const Text('Please fill all dropdowns and check the checkbox to confirm schedule.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }else{
                              // Declare progressContext outside the showDialog function
                              BuildContext? progressContext;
                        
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  // Update progressContext inside the showDialog function
                                  progressContext = context;
                                  return Dialog(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircularProgressIndicator(color: Colors.green,),
                                          SizedBox(height: 20),
                                          Text('Assigning...'),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                              String orderId = order['id'];
                              String truck = _selectedTruck!;
                              String crew1 = _selectedCrew1!;
                              String  crew2 = _selectedCrew2!;
                              DateTime timestamp = DateTime.now();
                              String timestampString = timestamp.toIso8601String(); // Convert DateTime to string
                        
                              setState(() {
                                order['assignedStatus'] = 'true';
                                order['assignedTimestamp'] = timestampString; // Add timestamp as a string to the map
                              });
                              print('Assign Schedule to: $orderId, $truck, $crew1, $crew2');
                              bool status = await databaseService.assignSchedule(widget.forHalt,order['id'], truck,crew1,crew2);
                              
                              /*//updates orders                        
                              List<Map<String, dynamic>> orderDetails = await databaseService.fetchAllOrderList();
                              Provider.of<SideMenuSelection>(context, listen: false)
                                .setUpdatedOrders(orderDetails);
                              */
                              if(status == false){
                                if (progressContext != null) {
                                  Navigator.pop(progressContext!);
                                }
                              }
                              assignedValue = truck;
                              print(assignedValue);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Assigned Successful'),
                                    content:  Text('Schedule successfully assigned to $truck.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          //Navigator.pop(context);
                                          widget.onAssigned(assignedValue);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              //Navigator.of(context).pop();
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromRGBO(190, 216, 253, 1),
                              ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Deploy',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            ),
                        ),
                      ),
                    ],
                  )
                ),
                
              ],
            )
          )

                
        ],
      )
    );
  }
}