import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'deliveryInformation.dart';

class EditUnloadingDelivery extends StatefulWidget {
  final UnloadingDelivery unload;
  final Function() onUpdate;


  EditUnloadingDelivery({Key? key, required this.unload, required this.onUpdate}) : super(key: key);

  @override
  _EditUnloadingDeliveryState createState() => _EditUnloadingDeliveryState();
}

class _EditUnloadingDeliveryState extends State<EditUnloadingDelivery> {
  final _formField = GlobalKey<FormState>();
  TextEditingController _refNum = TextEditingController();
  TextEditingController _quantity = TextEditingController();
  TextEditingController _weight = TextEditingController();
  TextEditingController _recipient = TextEditingController();
  TextEditingController _unloadingDate = TextEditingController();
  TextEditingController _unloadingTime = TextEditingController();
  //TextEditingController _route = TextEditingController();
  TextEditingController _unloadingLocation = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values for the text controllers
    _refNum.text = widget.unload.reference_num.toString();
    _quantity.text = widget.unload.quantity.toString();
    _weight.text = widget.unload.weight.toString();
    _recipient.text = widget.unload.recipient;
    // You need to implement methods to convert timestamp to date and time strings
     _unloadingDate.text = intoDate(widget.unload.unloadingTimeDate);
     _unloadingTime.text = intoTime(widget.unload.unloadingTimeDate);
    //_route.text = widget.unload.route;
    _unloadingLocation.text = widget.unload.unloadingLocation;
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.grey[700]!, width: 4.0),
      ),
      title:
      Center(
        child: Text(
          'Edit Unloading Delivery',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
              fontSize: 24),
        ),
      ),
      content: Form(
        key: _formField,
        child: Container(
          width: MediaQuery.sizeOf(context).width*0.4,
          height: MediaQuery.sizeOf(context).height*0.7,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reference Number',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter Reference Number";
                    }else{
                      bool  isValid = RegExp(r'^[0-9]\d*$').hasMatch(value);
                      if(!isValid){
                        return "Invalid reference number";
                      }
                    }
                    return null;
                  },
                  controller: _refNum,
                  decoration: InputDecoration(
                    hintText:
                    'xxxxxxxxxxxx', // Change labelText to hintText
                    hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors
                            .grey), // Change the font size of the hint text to 10 and color to grey
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Make edges curvier
                      borderSide: BorderSide(
                          color: Colors.grey[
                          500]!), // Make the border color grey
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Make edges curvier
                      borderSide: BorderSide(
                          color: Colors.grey[
                          500]!), // Make the border color grey
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Make edges curvier
                      borderSide: BorderSide(
                          color: Colors
                              .grey), // Change the border color when focused
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal:
                        10.0), // Adjust padding inside the TextFormField
                  ),
                ),
                SizedBox(height: 20),


                Text(
                  'Cargo Details',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1, // Adjust the flex value as needed
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter cartons to be delivered";
                          }else{
                            bool  isValid = RegExp(r'^[1-9]\d*$').hasMatch(value);
                            if(!isValid){
                              return "Invalid number of cartons";
                            }
                          }
                          return null;
                        },
                        controller: _quantity,
                        decoration: InputDecoration(
                          hintText:
                          'cartons to be unloaded', // Change labelText to hintText
                          hintStyle: TextStyle(
                              fontSize: 12,
                              color: Colors
                                  .grey), // Change the font size of the hint text to 10 and color to grey
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Make edges curvier
                            borderSide: BorderSide(
                                color: Colors.grey[
                                500]!), // Make the border color grey
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Make edges curvier
                            borderSide: BorderSide(
                                color: Colors.grey[
                                500]!), // Make the border color grey
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Make edges curvier
                            borderSide: BorderSide(
                                color: Colors
                                    .grey), // Change the border color when focused
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal:
                              10.0), // Adjust padding inside the TextFormField
                        ),
                      ),
                    ),
                    SizedBox(width: 10), // Add some spacing between the text fields
                    Flexible(
                      flex: 1, // Adjust the flex value as needed
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter weight of cargo";
                          }else{
                            bool  isValid = RegExp(r'^[1-9]\d*$').hasMatch(value);
                            if(!isValid){
                              return "Invalid weight";
                            }
                          }
                          return null;
                        },
                        controller: _weight,
                        decoration: InputDecoration(
                          hintText:
                          'weight in kg', // Change labelText to hintText
                          hintStyle: TextStyle(
                              fontSize: 12,
                              color: Colors
                                  .grey), // Change the font size of the hint text to 10 and color to grey
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Make edges curvier
                            borderSide: BorderSide(
                                color: Colors.grey[
                                500]!), // Make the border color grey
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Make edges curvier
                            borderSide: BorderSide(
                                color: Colors.grey[
                                500]!), // Make the border color grey
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Make edges curvier
                            borderSide: BorderSide(
                                color: Colors
                                    .grey), // Change the border color when focused
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal:
                              10.0), // Adjust padding inside the TextFormField
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Text(
                  'Unloading Date and Time',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1, // Adjust the flex value as needed
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter Unloading Date";
                          }else{
                            bool  isValid = RegExp(r'^(0[1-9]|1[0-2])/(0[1-9]|1\d|2\d|3[01])/(19|20)\d{2}$').hasMatch(value);
                            if(!isValid){
                              return "Invalid unlaoding date must be in MM/DD/YYYY format";
                            }
                          }
                          return null;
                        },
                        controller: _unloadingDate,
                        decoration: InputDecoration(
                          hintText:
                          'MM/DD/YYYY', // Change labelText to hintText
                          hintStyle: TextStyle(
                              fontSize: 12,
                              color: Colors
                                  .grey), // Change the font size of the hint text to 10 and color to grey
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Make edges curvier
                            borderSide: BorderSide(
                                color: Colors.grey[
                                500]!), // Make the border color grey
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Make edges curvier
                            borderSide: BorderSide(
                                color: Colors.grey[
                                500]!), // Make the border color grey
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Make edges curvier
                            borderSide: BorderSide(
                                color: Colors
                                    .grey), // Change the border color when focused
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal:
                              10.0), // Adjust padding inside the TextFormField
                        ),
                      ),
                    ),
                    SizedBox(width: 10), // Add some spacing between the text fields
                    Flexible(
                      flex: 1, // Adjust the flex value as needed
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter Ubloading Time";
                          }else{
                            bool  isValid = RegExp(r'^(0[1-9]|1[0-2]):[0-5][0-9] (AM|PM)$').hasMatch(value);
                            if(!isValid){
                              return "Invalid unloading time must be in 00:00 MM format";
                            }
                          }
                          return null;
                        },
                        controller: _unloadingTime,
                        decoration: InputDecoration(
                          hintText:
                          'HH:MM AM', // Change labelText to hintText
                          hintStyle: TextStyle(
                              fontSize: 12,
                              color: Colors
                                  .grey), // Change the font size of the hint text to 10 and color to grey
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Make edges curvier
                            borderSide: BorderSide(
                                color: Colors.grey[
                                500]!), // Make the border color grey
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Make edges curvier
                            borderSide: BorderSide(
                                color: Colors.grey[
                                500]!), // Make the border color grey
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Make edges curvier
                            borderSide: BorderSide(
                                color: Colors
                                    .grey), // Change the border color when focused
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal:
                              10.0), // Adjust padding inside the TextFormField
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Text(
                  'Recipient or Warehouse',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter Name of Recipient or Warehouse";
                    }
                    return null;
                  },
                  controller: _recipient,
                  decoration: InputDecoration(
                    hintText:
                    'name of recipient or warehouse', // Change labelText to hintText
                    hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors
                            .grey), // Change the font size of the hint text to 10 and color to grey
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Make edges curvier
                      borderSide: BorderSide(
                          color: Colors.grey[
                          500]!), // Make the border color grey
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Make edges curvier
                      borderSide: BorderSide(
                          color: Colors.grey[
                          500]!), // Make the border color grey
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Make edges curvier
                      borderSide: BorderSide(
                          color: Colors
                              .grey), // Change the border color when focused
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal:
                        10.0), // Adjust padding inside the TextFormField
                  ),
                ),
                // SizedBox(height: 20),

                // Text(
                //   'Route',
                //   style: TextStyle(
                //     color: Colors.grey[700],
                //     fontSize: 15,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // TextFormField(
                //   validator: (value){
                //     if(value!.isEmpty){
                //       return "Enter Route";
                //     }
                //     return null;
                //   },
                //   controller: _route,
                //   decoration: InputDecoration(
                //     hintText:
                //     'route', // Change labelText to hintText
                //     hintStyle: TextStyle(
                //         fontSize: 12,
                //         color: Colors
                //             .grey), // Change the font size of the hint text to 10 and color to grey
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(
                //           10.0), // Make edges curvier
                //       borderSide: BorderSide(
                //           color: Colors.grey[
                //           500]!), // Make the border color grey
                //     ),
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(
                //           10.0), // Make edges curvier
                //       borderSide: BorderSide(
                //           color: Colors.grey[
                //           500]!), // Make the border color grey
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(
                //           10.0), // Make edges curvier
                //       borderSide: BorderSide(
                //           color: Colors
                //               .grey), // Change the border color when focused
                //     ),
                //     filled: true,
                //     fillColor: Colors.white,
                //     contentPadding: EdgeInsets.symmetric(
                //         vertical: 10.0,
                //         horizontal:
                //         10.0), // Adjust padding inside the TextFormField
                //   ),
                // ),
                SizedBox(height: 20),

                Text(
                  'Unloading Location',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter Unloading Location";
                    }
                    return null;
                  },
                  controller: _unloadingLocation,
                  decoration: InputDecoration(
                    hintText:
                    'unloading location', // Change labelText to hintText
                    hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors
                            .grey), // Change the font size of the hint text to 10 and color to grey
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Make edges curvier
                      borderSide: BorderSide(
                          color: Colors.grey[
                          500]!), // Make the border color grey
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Make edges curvier
                      borderSide: BorderSide(
                          color: Colors.grey[
                          500]!), // Make the border color grey
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Make edges curvier
                      borderSide: BorderSide(
                          color: Colors
                              .grey), // Change the border color when focused
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal:
                        10.0), // Adjust padding inside the TextFormField
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        Center(
          child: ElevatedButton(
            onPressed: () {
              if(_formField.currentState!.validate()){


                    widget.unload.reference_num=int.parse(_refNum.text.trim());
                    widget.unload.unloadingLocation=_unloadingLocation.text.trim();
                    //widget.unload.route=_route.text.trim();
                     widget.unload.recipient=_recipient.text.trim();
                    widget.unload.quantity=int.parse(_quantity.text.trim());
                    widget.unload.unloadingTimeDate=convertIntoTimestamp(_unloadingDate.text.trim(), _unloadingTime.text.trim());
                    widget.unload.weight=int.parse(_weight.text.trim());

                    setState(() {

                    });
                    widget.onUpdate();
                Navigator.of(context).pop();
              }
              // Dismiss the dialog
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty
                  .resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(
                      MaterialState.pressed)) {
                    // return light grey when pressed
                    return Colors.grey[300]!;
                  }
                  // return grey when not pressed
                  return Colors.grey[700]!;
                },
              ),
              minimumSize:
              MaterialStateProperty.all<Size>(
                  Size(125, 40)),
              shape: MaterialStateProperty.all<
                  RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius as needed
                ),
              ),
            ),
            child: Text(
              'Update',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ), // Set text color
            ),
          ),
        ),
      ],
    );
  }

  Timestamp convertIntoTimestamp(String date, String time){
    try {
      List<String> dateParts = date.split('/'); // Split the string into parts
      int month = int.parse(dateParts[0]);
      int day = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);

      // Parse the time string
      List<String> timeParts = time.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1].split(' ')[0]);
      String meridiem = timeParts[1].split(' ')[1];

      if (meridiem == 'PM') {
        hour += 12; // Add 12 hours for PM times
      }

      DateTime dateTime = DateTime(year, month, day, hour, minute); // Create a DateTime object
      Timestamp timestamp = Timestamp.fromDate(dateTime);

      print("Timestamp: $timestamp");

      return timestamp;


    } catch (e) {
      print("Error parsing date: $e");
    }
    return Timestamp(0,0);

  }

  String intoDate (Timestamp timeStamp)  {
    DateTime dateTime = timeStamp.toDate(); // Convert Firebase Timestamp to DateTime
    String formattedDate = DateFormat('MM/dd/yyyy').format(dateTime); // Format DateTime into date string
    return formattedDate; // Return the formatted date string
  }

  String intoTime (Timestamp stampTime) {
    DateTime dateTime =  stampTime.toDate();  // Convert Firebase Timestamp to DateTime
    String formattedTime = DateFormat('hh:mm a').format(dateTime); // Format DateTime into time string
    return formattedTime; // Return the formatted time string
  }
}
