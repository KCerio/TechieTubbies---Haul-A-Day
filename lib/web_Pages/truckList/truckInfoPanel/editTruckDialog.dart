import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_html/html.dart' as html;


class EditTruck extends StatefulWidget {
  final Map<String, dynamic> truck;
  final Function(Map<String, dynamic>?) onUpdate;


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
  String prevDriver = '';

  bool busyTruck = false;


  @override
  void initState() {
    super.initState();
    truckPlateNumber.text=widget.truck['id'];
    truckDescription.text=widget.truck['truckType'];
    maxCapacity.text=widget.truck['maxCapacity'].toString();
    cargoType = widget.truck['cargoType'];
    if(widget.truck['truckStatus'] == 'Busy'){
      print(widget.truck['truckStatus']);
      setState(() {
        busyTruck = true;
      });
    }
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
      if(widget.truck['driver'] != 'none'){
        drivers.add('none');
      }
      _drivers = _dbdrivers;
    });

  }

  Future<void> fetchDriver(String driverId)async{
    //print('driver: ${driver}');
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
        setState(() {
          driver = driverDoc['firstname']+ ' '+driverDoc['lastname'];
        });
        
      }

    }
    
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
            Expanded(
              flex: 2,
              child: Container(
                  decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black, )
                  ),
                  
                ),
                margin: EdgeInsets.symmetric(horizontal: 30),
                padding: EdgeInsets.fromLTRB(25, 0, 0, 10),
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
                          Text('Edit Truck Info',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter' 
                          ),
                          ),
                          const SizedBox(height:5),
                          Text('Fill in the necessary information of the truck\nthat needs to be updated.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'InriaSans' 
                          ),
                          )
                        ],
                      ),
                    ),
                    IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    }, 
                    icon: Icon(Icons.close)
                  )
                  ],
                )
              ),
            ),

            //SizedBox(height: 10),
            //image
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.fromLTRB(40, 10, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    InkWell(
                      onTap: _getImage,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.green, // Border color
                            width: 3, // Border width
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundImage: _byte != null
                              ?Image.memory( _byte!,).image
                              :widget.truck['truckPic'] != null
                              ? Image.network(widget.truck['truckPic'],).image
                              : Image.asset('images/truck.png',).image,
                        ),
                      )
                    ),
                    SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          onPressed: _getImage, // Utilize the _pickTruckPicture method
                          child: Text(
                            _byte != null ? 'Change Truck Picture' : 'Select Truck Picture',
                            style: TextStyle(
                              color: _byte != null ? Colors.blue : Colors.blue, // Change color based on image selection
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //SizedBox(height: 20),

            //forms
            Expanded(
              flex: 6,
              child: Form(
                key:_formField,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    height: 400,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // TextFormField(
                          //   controller: truckPlateNumber,
                          //   validator: (value){
                          //     if(value!.isEmpty){
                          //       return "Enter Truck Plate Number";
                          //     }
                          //     return null;
                          //   },
                          //   decoration: InputDecoration(
                          //     prefixIcon: Icon(Icons.format_list_numbered),
                          //     labelText: "Truck's Plate Number",
                          //     labelStyle: TextStyle(
                          //       color: Color(0xff5A5A5A),
                          //     ),
                          //     filled: true,
                          //     fillColor: Colors.white,
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(20.0),
                          //     ),
                          //   ),
                          // ),
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
                            onChanged: busyTruck ? null :(newValue) {
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
                            onChanged: busyTruck ? null : (String? newValue) {
                              // Handle the value change
                              driver = newValue!;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //Spacer(),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: ()async{
                      if(_formField.currentState!.validate()){
                        if(_byte != null){
                          await _uploadImage();
                        }
                        String truckId = truckPlateNumber.text ?? widget.truck['id'];
                        String image = imageUrl ?? widget.truck['truckPic'];
                        String type = truckDescription.text ?? widget.truck['truckType'];
                        int max = int.parse(maxCapacity.text) ?? widget.truck['maxCapacity'];
                        String driverId = driver;
                        if(driver != 'none'){
                          driverId = await databaseService.getStaffId(driver);
                        }
                        //print('$image, $truckId, $type, $cargoType, $max, $driverId');
                        bool updating = true;

                        // Declare progressContext outside the showDialog function
                        BuildContext? progressContext;

                        // Show progress dialog
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
                                    CircularProgressIndicator(),
                                    SizedBox(height: 20),
                                    Text('Updating Information...'),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                        bool updated = await databaseService.updateTruckInfo('${widget.truck['id']}', cargoType, driverId, max, image, type ,truckId);
                        if(updated){
                          setState(() {
                            updating = false;
                          });
                        }

                        if(updating == false){
                           setState(() {
                            widget.truck['id'] = truckId; 
                            widget.truck['truckPic'] = image;
                            widget.truck['truckType'] = type;
                            widget.truck['maxCapacity'] = max;
                            widget.truck['driver'] = driverId;
                            widget.truck['cargoType'] = cargoType;
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Updated'),
                                content: const Text("Truck's information is updated."),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async {        
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      widget.onUpdate(widget.truck);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        
                        }
                        //Navigator.of(context).pop();
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
            ),
          ],
        ),
      ),
    );
  }

  String? imageUrl;
  html.File? imageFile;
  Uint8List? _byte;
  bool uploading = false; // Track if image is being uploaded

  void _getImage() {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.accept = 'image/*'; // Accept only image files
    input.click();

    input.onChange.listen((e) {
      final List<html.File>? files = input.files;
      if (files != null && files.length == 1) {
        final html.File file = files[0];
        final String fileType = file.type.toLowerCase(); // Get the file type

        // Check if the file type starts with 'image/'
        if (!fileType.startsWith('image/')) {
          // File is not an image, show alert dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Alert'),
                content: Text('Invalid file format. Please upload an image file.'),
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
        } else {
          // File is an image, proceed with handling
          setState(() {
            imageFile = file;
          });
          loadImage(imageFile!);
        }
      }
    });
  }


  void loadImage(html.File _imageFile) {
    if (_imageFile != null) {
      final reader = html.FileReader();
      reader.readAsDataUrl(_imageFile);
      reader.onLoadEnd.listen((event) {
        var _byteData = base64.decode(reader.result.toString().split(',').last);
        setState(() {
          _byte = _byteData;
        });
      });
    }
  }

  Future<void> _uploadImage() async {
    try {
      if (imageFile == null) return;

      // Set uploading flag to true
      setState(() {
        uploading = true;
      });

      // Declare progressContext outside the showDialog function
      BuildContext? progressContext;

      // Show progress dialog
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
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Uploading Image...'),
                ],
              ),
            ),
          );
        },
      );

      // Initialize Firebase if not already initialized
      await Firebase.initializeApp();

      // Get a reference to the Firebase Storage instance
      final storage = FirebaseStorage.instance;

      // Create a reference to the location where you want to upload the file
      final ref = storage.ref().child('Trucks/${widget.truck['id']}/truckpic');

      // Upload the file to Firebase Storage
      final uploadTask = ref.putBlob(imageFile!.slice(), SettableMetadata(contentType: 'image/jpeg'));

      // Get the download URL of the uploaded file
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        uploading = false;
        imageUrl = downloadUrl;
      });

      // Dismiss the progress dialog using the progressContext
      if (progressContext != null) {
        Navigator.pop(progressContext!);
      }

      //print("Url: $imageUrl");
    } catch (e) {
      print('Error uploading image: $e');
      setState(() {
        uploading = false;
      });
    }
  }


}