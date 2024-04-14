import 'package:flutter/material.dart';
import 'package:haul_a_day_web/newUI/orderdashboard.dart';
import 'package:haul_a_day_web/service/database.dart';

class AssignDialog extends StatefulWidget {
  final Map<String,dynamic> order;
  const AssignDialog({super.key, required this.order});

  @override
  State<AssignDialog> createState() => _AssignDialogState();
}

class _AssignDialogState extends State<AssignDialog> {

  DatabaseService databaseService = DatabaseService();

  bool isCheck = false;
  List<String> _truckAvailable = [];
  List<String> _helpersAvailable = [];
  String? _selectedTruck;
  String? _selectedCrew1;
  String? _selectedCrew2;
  Map<String,dynamic> _order = {};
  
  @override
  void initState(){
    super.initState();
    setState(() {
      _order = widget.order;
    });
    getDetails();
  }

  Future<void> getDetails()async{
  // Fetch order details
  try {
    List<String> truckAvailable = await databaseService.getAvailableTruckDocumentIds(_order['cargoType']);
    List<String> helpersAvailable = await databaseService.getAvailableCrewIds();
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
    
    return Stack(
      children: [
        Container(    //gi wrap nako sa Stack para sa 'Deploy' button
          width: 850.0, // Adjust the width as needed
          height: 600.0, // Adjust the height as needed
          color: Colors.white, // Set content background color
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF3871C1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                child: AppBar(
                  title: const Padding(
                    padding: EdgeInsets.fromLTRB(250, 0, 0, 0),
                    child: Text(
                      'Create Schedule',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  backgroundColor: Colors.amber,
                  elevation: 0, // Remove the shadow
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(60, 20, 60, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [                          
                              const Text(
                                'Order Details',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Arial',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              //SizedBox(height: 15),
                              Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Order ID: ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Arial',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _order['id'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Arial',
                                  ),
                                ),
                              ],
                            ),
                              
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(  //container sulod sa create schedule
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Container(
                        alignment: Alignment.center,
                        height: 210,
                        width: 740,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Customer:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                          '${_order['company_name'] ?? ''}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Text(
                                          'Cargo Type:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                          _order['cargoType'] == 'fgl'
                                            ? 'frozen cargo'
                                            : _order['cargoType'] == 'cgl'
                                                ? 'dry cargo'
                                                : '',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Text(
                                          'Weight:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                          '${_order['totalWeight']} kgs',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Date:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                          '${_order['loadingDate'] ?? ''}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Text(
                                          'Time:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                          '${_order['loadingTime'] ?? ''}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Text(
                                          'Route:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                          '${_order['route'] ?? ''}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(100, 20, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Assign Truck:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Container(
                                          height: 40,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
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
                                                // Add your code here to handle the selected value
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
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Text(
                                          'Assign Crew 1:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          height: 40,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: _selectedCrew1,
                                              onChanged: (String? newValue) {
                                                // Add your code here to handle the selected value
                                                setState(() {
                                                  _selectedCrew1 = newValue; 
                                                  //crew1 = newValue!;                                                                 
                                                });
                                                // Remove selected crew from the list
                                                //_helpersAvailable.remove(_selectedCrew1);
                                                
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
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Text(
                                          'Assign Crew 2:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          height: 40,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: _selectedCrew2,
                                              onChanged: (String? newValue) {
                                                // Add your code here to handle the selected value
                                                setState(() {                                                  
                                                  _selectedCrew2 = newValue;
                                                  //crew2 = newValue!;                                                  
                                                });
                                                // Remove selected crew from the list
                                                //_helpersAvailable.remove(_selectedCrew2);
                                                
                                              },
                                              items:_selectedCrew1 != null
                                                ? _helpersAvailable.where((element) => element != _selectedCrew1).map<DropdownMenuItem<String>>((String value) {
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
                                    const SizedBox(height: 25),
                                    Row(
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
                                          'Confirm Schedule',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Arial',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
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
                        String orderId = _order['id'];
                        String truck = _selectedTruck!;
                        String crew1 = _selectedCrew1!;
                        String  crew2 = _selectedCrew2!;

                        print('Assign Schedule to: $orderId, $truck, $crew1, $crew2');
                        databaseService.assignSchedule(_order['id'], truck,crew1,crew2);

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
                          const Color.fromARGB(255, 9, 86, 150),
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}