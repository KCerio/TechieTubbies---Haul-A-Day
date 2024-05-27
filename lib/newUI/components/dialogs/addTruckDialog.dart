import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haul_a_day_web/authentication/constant.dart';
import 'package:haul_a_day_web/newUI/components/sidepanel.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:firebase/firebase.dart' as fb;
import 'package:universal_html/html.dart';

class AddTruckDialog extends StatefulWidget {
  //Map<String,dynamic> newTruck
  const AddTruckDialog({super.key});

  @override
  State<AddTruckDialog> createState() => _AddTruckDialogState();
}

class _AddTruckDialogState extends State<AddTruckDialog> {
  bool isCheck = false;
  bool imageAdded = false;
  String? truckID;
  String? cargoType;
  String? truckType;
  int? maxCapacity;
  Map<String,dynamic> _newTruck = {};

  Map<String,dynamic> get newTruck => _newTruck;
  //List<String> cargoTypes = ['cgl - canned/dry', 'fgl - frozen'];

  final _formfield = GlobalKey<FormState>();
  TextEditingController truckIdcontroller = TextEditingController();
  TextEditingController truckTypecontroller = TextEditingController();
  TextEditingController maxCapacitycontroller = TextEditingController();

  DatabaseService databaseService = DatabaseService();
  List<Map<String,dynamic>> _drivers = [];
  List<String> drivers = [];
  String? driver;

  @override
  void initState() {
    super.initState();
    getDrivers();
  }

  Future<void> getDrivers()async{
    List<Map<String,dynamic>> _dbdrivers = await databaseService.getAvailableDrivers();
    print("Drivers: $drivers");
    if(_dbdrivers.isNotEmpty){
      for(Map<String,dynamic> driver in _dbdrivers){
      drivers.add(driver['name']);
    }
    } else{
      drivers.add('No Available drivers');
    }
    setState(() {
      _drivers = _dbdrivers;
    });
 
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
      final ref = storage.ref().child('Trucks/$truckID/truckpic');

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

      print("Url: $imageUrl");
    } catch (e) {
      print('Error uploading image: $e');
      setState(() {
        uploading = false;
      });
    }
  }

    

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 850.0,
          height: 700,
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
              Container(
                //height: 800,
                padding: EdgeInsets.fromLTRB(60, 20, 60, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex:2,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(24, 24, 24, 15),
                          child: Form(
                            key: _formfield,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Truck Id
                                TextFormField(
                                  controller: truckIdcontroller,
                                  validator: (value){
                                    setState(() {
                                      truckID = truckIdcontroller.text;
                                    });
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
                                    setState(() {
                                      truckType = truckTypecontroller.text;
                                    });
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
                                    setState(() {
                                      maxCapacity = int.parse(maxCapacitycontroller.text);
                                    });
                                    if(value!.isEmpty){
                                      return "Enter Truck's Max Capacity";
                                    }
                                    
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    //hintText: 'Username or Staff ID',
                                    labelText: "Truck's Max Capacity (kg)",
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
                  
                                const SizedBox(
                                  height: 20,
                                ),
                  
                                //Driver Type Dropdown
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Assign Truck Driver:",
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
                                          value: driver,
                                          onChanged: (String? newValue) {
                                            // Add your code here to handle the selected value
                                            setState(() {
                                              
                                              driver = newValue; 
                                              //crew1 = newValue!;                                                                 
                                            });
                                            
                                            // Remove selected crew from the list
                                            //_helpersAvailable.remove(_selectedCrew1);
                                            
                                          },
                                          items: drivers.map((String value) {
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
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top:16,left: 24),
                          height:400,
                                                  
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                child: _byte == null
                                    ? IconButton(
                                        icon: Icon(Icons.add_a_photo),
                                        onPressed: () async {
                                          _getImage();
                                          setState(() {
                                            imageAdded = true;
                                          });
                                        },
                                      )
                                    : InkWell(onTap: _getImage,child: Image.memory(_byte!, fit: BoxFit.cover))
                              ),
                              SizedBox(height: 10,),
                              Text("Truck Picture", style: TextStyle(fontSize: 16),)
                            ],
                          ),
                        ),
                      )
                  ],),
                ),
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
                      print("Driver: $driver");
                      //print
                      //print("Max: ${maxCapacity!.toString()}");
                      if(cargoType != null &&
                          driver !=null &&  isCheck && imageAdded){
                            if(_formfield.currentState!.validate()){
                            await _uploadImage();
                            //String truckPic = await uploadFileToStorage(_imageFile, truckID); // Call uploadFileToStorage with filePath
                            print("Added Truck: $truckID, ${cargoType!}, ${driver!}, $maxCapacity, $imageUrl, $truckType");
                            //print('TruckPic: $truckPic');
                            setState(() {
                              _newTruck = {
                                'truckID': truckID,
                                'cargoType': (cargoType!.startsWith('f')?'fgl':'cgl'),
                                'driver': driver,
                                'maxCapacity': maxCapacity,
                                'pictureUrl': imageUrl,
                                'truckType': truckType,
                                'truckStatus' : 'Available'
                              };
                            });
                            databaseService.addTruck(truckID!, cargoType!, driver!, maxCapacity!, imageUrl!, truckType!);
                            print("Driver: $driver");
                            
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Successful'),
                                  content: Text('$truckID is successfully added to the truck list.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {        
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );                      
                        }  
                        else if(truckID == null|| maxCapacity == null|| truckType == null){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Alert'),
                                content: const Text('Please fill in all the truck information required.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async {        
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                      else{
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Alert'),
                              content: const Text('Please fill in all the truck information required.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {        
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