import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/web_Pages/customerPage/deliveryInformation.dart';

class AddUnloadingDelivery extends StatelessWidget {
  final Function(UnloadingDelivery) onSave;

  // Constructor to accept the onSave callback
  AddUnloadingDelivery({Key? key, required this.onSave}) : super(key: key);

  final _formField = GlobalKey<FormState>();
  TextEditingController _refNum = TextEditingController();
  TextEditingController _quantity = TextEditingController();
  TextEditingController _weight = TextEditingController();
  TextEditingController _recipient = TextEditingController();
  TextEditingController _unloadingDate = TextEditingController();
  TextEditingController _unloadingTime = TextEditingController();
  TextEditingController _route = TextEditingController();
  TextEditingController _unloadingLocation = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.blue[700]!, width: 4.0),
      ),
      title:
      Center(
        child: Text(
          'Add Unloading Delivery',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
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
                              .blue), // Change the border color when focused
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
                          'number of cartons', // Change labelText to hintText
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
                                    .blue), // Change the border color when focused
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
                                    .blue), // Change the border color when focused
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
                                    .blue), // Change the border color when focused
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
                          '00:00 AM', // Change labelText to hintText
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
                                    .blue), // Change the border color when focused
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
                              .blue), // Change the border color when focused
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
                  'Route',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter Route";
                    }
                    return null;
                  },
                  controller: _route,
                  decoration: InputDecoration(
                    hintText:
                    'route', // Change labelText to hintText
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
                              .blue), // Change the border color when focused
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
                              .blue), // Change the border color when focused
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

                UnloadingDelivery newUnload = UnloadingDelivery(
                    int.parse(_refNum.text.trim()),
                    _unloadingLocation.text.trim(),
                    _route.text.trim(),
                    _recipient.text.trim(),
                    int.parse(_quantity.text.trim()),
                    convertIntoTimestamp(_unloadingDate.text.trim(), _unloadingTime.text.trim()),
                    int.parse(_weight.text.trim()));
                onSave(newUnload);

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
                    // return light blue when pressed
                    return Colors.blue[300]!;
                  }
                  // return blue when not pressed
                  return Colors.blue[700]!;
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
              'Add',
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
}
