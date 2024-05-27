import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../service/database.dart';

class EditTruck extends StatefulWidget {
  final Map<String, dynamic> truck;
  final Function() onUpdate;


  EditTruck({Key? key, required this.truck, required this.onUpdate}) : super(key: key);

  @override
  _EditTruckState createState() => _EditTruckState();
}

class _EditTruckState extends State<EditTruck> {

  final _formField = GlobalKey<FormState>();
  TextEditingController truckPlateNumber = TextEditingController();
  TextEditingController truckDescription = TextEditingController();
  TextEditingController maxCapacity = TextEditingController();

  DatabaseService databaseService = DatabaseService();
  List<Map<String,dynamic>> _drivers = [];
  List<String> drivers = [];

  String driver='...';
  String cargoType = '';


  @override
  void initState() {
    super.initState();
    truckPlateNumber.text=widget.truck['id'];
    truckDescription.text=widget.truck['truckType'];
    maxCapacity.text=widget.truck['maxCapacity'].toString();
    cargoType = widget.truck['cargoType'];
    fetchDriver(widget.truck['driver']);
    getDrivers();


  }

  Future<void> getDrivers()async{
    List<Map<String,dynamic>> _dbdrivers = await databaseService.getAvailableDrivers();
    if(_dbdrivers.isNotEmpty){
      for(Map<String,dynamic> driver in _dbdrivers){
        drivers.add(driver['name']);
      }
    } else{
      drivers.add('No Available drivers');
    }
    setState(() {
      drivers.add(driver);
      _drivers = _dbdrivers;
    });

  }

  Future<void> fetchDriver(String driverId)async{
    print('driver: ${driver}');
    if(driverId=='none'){
      driver = 'none';
    }else{
      DocumentSnapshot driverDoc = await FirebaseFirestore.instance
          .collection('Users')
          .where('staffId', isEqualTo: driverId)
          .limit(1)
          .get()
          .then((querySnapshot) => querySnapshot.docs.first);

      if(driverDoc.exists){
        driver = driverDoc['firstname']+ ' '+driverDoc['lastname'];
      }

    }
    setState(() {

    });


  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 700,  // Set the desired width
        //height: 650, // Set the desired height
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Color(0xff),
            width: 4.0,
          ),
        ),
        child: Column(
          children: [
            //top part
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop(); // This will close the current screen and go back to the previous one
                  },
                  child: Container(
                    height:40,
                    width: 80,
                    padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: Colors.white, // Icon color
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Itim',
                            color: Colors.white, // Text color
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 40),
                Text(
                  'Edit Truck Info',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Itim',
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Container(
              width: 600,
              child: Divider(
                color: Colors.black,
                thickness: 1,
              ),
            ),

            SizedBox(height: 15),
            //image
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
              child: Row(
                children: [
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: _pickImage,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(150),
                          ),
                          child: _image == null
                              ? Container() // Empty container instead of text
                              : Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  Column(
                    children: [
                      Text(
                        widget.truck['id'],
                        style: TextStyle(
                          fontFamily: 'Itim',
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8), // Add some spacing between the text and the button
                      TextButton(
                        onPressed: () => _pickTruckPicture(), // Utilize the _pickTruckPicture method
                        child: Text(
                          _imagePath != null ? 'Change Truck Picture' : 'Select Truck Picture',
                          style: TextStyle(
                            color: _imagePath != null ? Colors.blue : Colors.blue, // Change color based on image selection
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            //forms
            Form(
              key:_formField,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  height: 400,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: truckPlateNumber,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter Truck Plate Number";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.format_list_numbered),
                            labelText: "Truck's Plate Number",
                            labelStyle: TextStyle(
                              color: Color(0xff5A5A5A),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: truckDescription,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter Truck Type or Description";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.description),
                            labelText: 'Truck Type or Description',
                            labelStyle: TextStyle(
                              color: Color(0xff5A5A5A),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: maxCapacity,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter Truck's Max Capacity";
                            }else{
                              bool  isValid = RegExp(r'^[0-9]\d*$').hasMatch(value);
                              if(!isValid){
                                return "Invalid maximum capacity";
                              }
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.line_weight),
                            labelText: "Truck's Max Capacity (kg)",
                            labelStyle: TextStyle(
                              color: Color(0xff5A5A5A),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        DropdownButtonFormField<String>(
                          value: cargoType.isEmpty ? null : cargoType,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.local_shipping),
                            labelText: "Truck's Cargo Type",
                            labelStyle: TextStyle(
                              color: Color(0xff5A5A5A),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'cgl',
                              child: Text('Dry Goods'),
                            ),
                            DropdownMenuItem(
                              value: 'fgl',
                              child: Text('Frozen Goods'),
                            ),
                          ],
                          onChanged: (newValue) {
                            setState(() {
                              cargoType = newValue as String;
                            });
                          },
                          validator: (value) {
                            if (value == null || value == '') {
                              return 'Please select a cargo type';
                            }
                            return null;
                          },



                        ),
                        SizedBox(height: 15),
                        DropdownButtonFormField<String>(
                            value: driver.isEmpty ? null : driver,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: "Assign Truck Driver",
                            labelStyle: TextStyle(
                              color: Color(0xff5A5A5A),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          items: drivers.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value)
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            // Handle the value change
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: (){
                    if(_formField.currentState!.validate()){
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    "Update",
                    style: TextStyle(
                        fontFamily: 'Itim',
                        fontSize: 20,
                        color: Colors.white
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff3871C1),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  File? _image;
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  String? _imagePath; // Declare a variable to store the image path

// Create a method to handle picking the truck picture
  Future<void> _pickTruckPicture() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }


}