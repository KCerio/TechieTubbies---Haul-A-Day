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
import 'package:haul_a_day_web/service/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:firebase/firebase.dart' as fb;
import 'package:universal_html/html.dart';

class AddTruckDialog extends StatefulWidget {
  //Map<String,dynamic> newTruck
  final Function(Map<String, dynamic>?) newTruck;
  const AddTruckDialog({super.key, required this.newTruck});

  @override
  State<AddTruckDialog> createState() => _AddTruckDialogState();
}

class _AddTruckDialogState extends State<AddTruckDialog> {
  bool isCheck = false;
  bool imageAdded = false;
  String? truckID;
  //String? cargoType;
  //String? truckType;
  //int? maxCapacity;
  Map<String,dynamic> _newTruck = {};
  String _cargoType = '';

  //Map<String,dynamic> get newTruck => _newTruck;
  //List<String> cargoTypes = ['cgl - canned/dry', 'fgl - frozen'];

  final _formfield = GlobalKey<FormState>();
  TextEditingController truckIdcontroller = TextEditingController();
  TextEditingController truckTypecontroller = TextEditingController();
  TextEditingController maxCapacitycontroller = TextEditingController();

  DatabaseService databaseService = DatabaseService();
  List<Map<String,dynamic>> _drivers = [];
  //Map<String,dynamic> truck = {};
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
      drivers.add('None');
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
                decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black, )
                ),
                
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
                        Text('Add Truck',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter' 
                        ),
                        ),
                        const SizedBox(height:5),
                        Text('Fill in the necessary information of the truck to be \nadded to the list.',
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

          Expanded(
            flex: 8,
            child: LayoutBuilder(
              builder: ((context, constraints) {
                return Column(
                  children: [
                    Expanded(
                      flex:7,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child:Container(
                              //padding: EdgeInsets.only(top:16,left: 24), 
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(50, 131, 245, 1),
                                borderRadius: BorderRadius.circular(10)
                              ),                                                                       
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //const SizedBox(height: 50),
                                  Container(
                                    height: 200,
                                    width: 200,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromARGB(188, 195, 235, 253),
                                    ),
                                    child: _byte == null
                                        ? IconButton(
                                            icon: Icon(Icons.add_a_photo, color: Colors.grey,),
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
                                  Text("Truck Picture", style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex:4,
                            child:Container(
                              padding: EdgeInsets.all(16),
                              child: LayoutBuilder(
                                builder: (context,constraints) {
                                  return Column(
                                    children: [
                                      const SizedBox(height: 10,),
                                      const Text(
                                        'Truck Information',
                                        style:TextStyle(
                                          fontSize:22,
                                          fontFamily: 'Inter',
                                          color:Colors.grey,
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                      const SizedBox(height:20),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 16),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Plate No.',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox( width: 10,),
                                            Container(
                                              height: 40,
                                              width: constraints.maxWidth * 2/3,
                                              child: TextField(
                                                controller: truckIdcontroller,
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.symmetric(vertical: 2),
                                                  hintText: "Ex. GDN 6543",
                                                  border: OutlineInputBorder(),
                                                ),
                                                style: TextStyle(fontSize: 14),
                                                textAlign: TextAlign.center, // Center align horizontally
                                                textAlignVertical: TextAlignVertical.center, // Center align vertically
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height:12),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 16),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Truck type',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox( width: 10,),
                                            Container(
                                              height: 40,
                                              width: constraints.maxWidth * 2/3,
                                              child: TextField(
                                                controller: truckTypecontroller,
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.symmetric(vertical: 2),
                                                  hintText: 'Ex. 10 Wheelers Reefer Van',
                                                  border: OutlineInputBorder(),
                                                ),
                                                style: TextStyle(fontSize: 14),
                                                textAlign: TextAlign.center, // Center align horizontally
                                                textAlignVertical: TextAlignVertical.center, // Center align vertically
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height:12),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 16),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Max Capacity\n(kg)',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox( width: 10,),
                                            Container(
                                              height: 40,
                                              width: constraints.maxWidth * 2/3,
                                              child: TextField(
                                                controller: maxCapacitycontroller,
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.symmetric(vertical: 2),
                                                  hintText: 'Ex. 5000',
                                                  border: OutlineInputBorder(),
                                                ),
                                                style: TextStyle(fontSize: 14),
                                                textAlign: TextAlign.center, // Center align horizontally
                                                textAlignVertical: TextAlignVertical.center, // Center align vertically
                                              ),
                                            )
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 30,),

                                      Divider(),

                                      const SizedBox(height: 12,),

                                      Container(
                                        width: constraints.maxWidth,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'What type of cargo can it handle?',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontStyle: FontStyle.italic
                                              ),
                                            ),
                                            Container(
                                              //height: 25,
                                              width: constraints.maxWidth,
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              
                                              child: //Radio Button
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Radio<String>(
                                                        value: 'cgl',
                                                        groupValue: _cargoType,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _cargoType = value!;
                                                          });
                                                          print(_cargoType);
                                                        },
                                                      ),
                                                      Text('Dry goods'),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio<String>(
                                                        value: 'fgl',
                                                        groupValue:  _cargoType,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _cargoType = value!;
                                                          });
                                                          print(_cargoType);
                                                        },
                                                      ),
                                                      Text('Frozen Goods'),
                                                    ],
                                                  ),
                                                  
                                                ],
                                              ),

                                            ),

                                            const SizedBox(height: 12,),

                                            Container(
                                              width: constraints.maxWidth,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Assign a driver to this truck?',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                      fontStyle: FontStyle.italic
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Center(
                                                    child: Container(
                                                      height: 40,
                                                      width: constraints.maxWidth * 2/3,
                                                      //alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(color: Colors.grey),
                                                        borderRadius: BorderRadius.circular(10)
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
                                                  )
                                                ]
                                              )
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),


                    //Confirm and save (add truck button)
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                      
                        const SizedBox(height: 8),
                      
                          ElevatedButton(
                          onPressed: ()async {
                            
                            // Handle button press
                            print("Driver: $driver");
                            
                            
                            if(truckIdcontroller.text == '' || 
                            truckTypecontroller.text == ''|| 
                            maxCapacitycontroller.text == '' ||                            
                            driver == null||
                            _cargoType == ''||
                            _byte == null) {
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
                            }else if(isCheck == false){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Alert'),
                                    content: const Text('Please confirm the information above by clicking the checkbox.'),
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
                            }else{
                              try{
                                truckID = truckIdcontroller.text;
                                String truckType = truckTypecontroller.text;
                                int maxCapacity = int.parse(maxCapacitycontroller.text);
                                //print("Added Truck: $truckID, $_cargoType, ${driver!}, $maxCapacity, $_byte, $truckType");
                                await _uploadImage();
                                //String truckPic = await uploadFileToStorage(_imageFile, truckID); // Call uploadFileToStorage with filePath
                                print("Added Truck: $truckID, $_cargoType, ${driver!}, $maxCapacity, $imageUrl, $truckType");
                                //print('TruckPic: $truckPic');
                                setState(() {
                                  _newTruck = {
                                    'id': truckID,
                                    'cargoType': _cargoType,
                                    'driver': driver,
                                    'maxCapacity': maxCapacity,
                                    'truckPic': imageUrl,
                                    'truckType': truckType,
                                    'truckStatus' : 'Available'
                                  };
                                });
                                databaseService.addTruck(truckID!, _cargoType, driver!, maxCapacity, imageUrl!, truckType!);
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
                                            widget.newTruck(_newTruck);
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );                      
                              }catch(e){
                                print(e);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Alert'),
                                      content: const Text('Max Capacity should be numerical.'),
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
                    )
                    ],
                  );
                }
              ),
            ),
          )
        ],
      )
    );
  }
}

