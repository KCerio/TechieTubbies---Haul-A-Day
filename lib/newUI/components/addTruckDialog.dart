import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddTruckDialog extends StatefulWidget {
  const AddTruckDialog({super.key});

  @override
  State<AddTruckDialog> createState() => _AddTruckDialogState();
}

class _AddTruckDialogState extends State<AddTruckDialog> {
  bool isCheck = false;
  bool imageAdded = false;
  String truckID = '';
  String? cargoType;
  String truckType = '';
  int maxCapacity = 0;
  //List<String> cargoTypes = ['cgl - canned/dry', 'fgl - frozen'];

  final _formfield = GlobalKey<FormState>();
  TextEditingController truckIdcontroller = TextEditingController();
  TextEditingController truckTypecontroller = TextEditingController();
  TextEditingController maxCapacitycontroller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 850.0,
          height: 600,
          color: Colors.white,
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
                      'Add Truck',
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
                padding: EdgeInsets.fromLTRB(60, 20, 60, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex:2,
                      child: Container(
                        margin: const EdgeInsets.all(24),
                        child: Form(
                          key: _formfield,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                        
                              //Truck Id
                              TextFormField(
                                controller: truckIdcontroller,
                                validator: (value){
                                  truckID = truckIdcontroller.text;
                                  if(value!.isEmpty){
                                    return "Enter Truck Plate Number";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  //hintText: 'Username or Staff ID',
                                  labelText: "Truck's Plate No.",
                                  //suffixIcon: Icon(Icons.check)
                                ),
                              ),
                        
                              //Truck Type
                              TextFormField(
                                controller: truckTypecontroller,
                                validator: (value){
                                  truckType = truckTypecontroller.text;
                                  if(value!.isEmpty){
                                    return "Enter Truck Type or Description";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  //hintText: 'Username or Staff ID',
                                  labelText: "Truck Type or Description",
                                  //suffixIcon: Icon(Icons.check)
                                ),
                              ),
                        
                              //Max Capacity
                              TextFormField(
                                controller: maxCapacitycontroller,
                                validator: (value){
                                  maxCapacity = int.parse(maxCapacitycontroller.text);
                                  if(value!.isEmpty){
                                    return "Enter Truck's Max Capacity";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  //hintText: 'Username or Staff ID',
                                  labelText: "Truck's Max Capacity",
                                  //suffixIcon: Icon(Icons.check)
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              //Cargo Type Dropdown
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Truck's Cargo Type:",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Arial',
                                      color: Colors.black
                                    ),
                                  ),
                                  
                                  //const SizedBox(height: 20),
                                                                
                                  Container(
                                    height: 40,
                                    width: 500,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border(bottom: BorderSide(color: Colors.grey, width: 1.5))
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: cargoType,
                                        items: <String>['cgl - canned/dry', 'fgl - frozen']
                                            .map((String value) {
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
                                            cargoType = newValue;
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top:24,left: 24),
                        height:300,                        
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 200,
                              width: 200,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.add_a_photo),
                                onPressed: ()async{
                                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                                  if (result != null) {
                                    String? filePath = result.files.single.path;
                                  }
                                  setState(() {
                                    imageAdded = true;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text("Truck's Picture", style: TextStyle(fontSize: 16),)
                          ],
                        ),
                      ),
                    )
                ],),
              ),
              Container(
                padding: EdgeInsets.only(top:24),
                width: 850,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
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
                          'Confirm Truck Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                    onPressed: ()async {
                      // Handle button press
                      if(_formfield.currentState!.validate() &&
                          cargoType != null &&
                          imageAdded &&  isCheck){
                            Navigator.pop(context);
                      }else{
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Alert'),
                              content: const Text('Please fill in all the truck information required.'),
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
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 223, 175, 17),
                        ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Add Truck',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      ),
                  ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}