import 'package:flutter/material.dart';

class EditUnloadingDelivery extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
        side: BorderSide(color: Colors.grey[700]!, width: 4.0), // Top border color and thickness
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
      content: Column(
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 30),
              Text(
                'Reference',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal:
                30.0), // Add padding to left and right
            child: Container(
              height: 30,
              width: 450, // Set the width to 500
              child: TextFormField(
                style: TextStyle(
                    fontSize:
                    10), // Change the font size of the text inside the TextFormField
                decoration: InputDecoration(
                  hintText:
                  'xxxxxxxxxxxx', // Change labelText to hintText
                  hintStyle: TextStyle(
                      fontSize: 10,
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
          ),
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 30),
              Text(
                'Cargo Details',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 30.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(
                            right: 10.0),
                        child: Container(
                          height: 30,
                          child: TextFormField(
                            style: TextStyle(
                                fontSize:
                                10), // Change the font size of the text inside the TextFormField
                            decoration:
                            InputDecoration(
                              hintText:
                              'quantity unloaded', // Change labelText to hintText
                              hintStyle: TextStyle(
                                  fontSize: 10,
                                  color: Colors
                                      .grey), // Change the font size of the hint text to 10 and color to grey
                              border:
                              OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    10.0), // Make edges curvier
                                borderSide: BorderSide(
                                    color: Colors
                                        .grey[
                                    500]!), // Make the border color grey
                              ),
                              enabledBorder:
                              OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    10.0), // Make edges curvier
                                borderSide: BorderSide(
                                    color: Colors
                                        .grey[
                                    500]!), // Make the border color grey
                              ),
                              focusedBorder:
                              OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    10.0), // Make edges curvier
                                borderSide: BorderSide(
                                    color: Colors
                                        .grey), // Change the border color when focused
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding:
                              EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal:
                                  10.0), // Adjust padding inside the TextFormField
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(
                            left: 10.0),
                        child: Container(
                          height: 30,
                          child: TextFormField(
                            style: TextStyle(
                                fontSize:
                                10), // Change the font size of the text inside the TextFormField
                            decoration:
                            InputDecoration(
                              hintText:
                              'weight', // Change labelText to hintText
                              hintStyle: TextStyle(
                                  fontSize: 10,
                                  color: Colors
                                      .grey), // Change the font size of the hint text to 10 and color to grey
                              border:
                              OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    10.0), // Make edges curvier
                                borderSide: BorderSide(
                                    color: Colors
                                        .grey[
                                    500]!), // Make the border color grey
                              ),
                              enabledBorder:
                              OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    10.0), // Make edges curvier
                                borderSide: BorderSide(
                                    color: Colors
                                        .grey[
                                    500]!), // Make the border color grey
                              ),
                              focusedBorder:
                              OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    10.0), // Make edges curvier
                                borderSide: BorderSide(
                                    color: Colors
                                        .grey), // Change the border color when focused
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding:
                              EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal:
                                  10.0), // Adjust padding inside the TextFormField
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 30),
              Text(
                'Unloading Date and Time',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 30.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(
                            right: 10.0),
                        child: Container(
                          height: 30,
                          child: TextFormField(
                            style: TextStyle(
                                fontSize:
                                10), // Change the font size of the text inside the TextFormField
                            decoration:
                            InputDecoration(
                              hintText:
                              'MM-dd-YYYY', // Change labelText to hintText
                              hintStyle: TextStyle(
                                  fontSize: 10,
                                  color: Colors
                                      .grey), // Change the font size of the hint text to 10 and color to grey
                              border:
                              OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    10.0), // Make edges curvier
                                borderSide: BorderSide(
                                    color: Colors
                                        .grey[
                                    500]!), // Make the border color grey
                              ),
                              enabledBorder:
                              OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    10.0), // Make edges curvier
                                borderSide: BorderSide(
                                    color: Colors
                                        .grey[
                                    500]!), // Make the border color grey
                              ),
                              focusedBorder:
                              OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    10.0), // Make edges curvier
                                borderSide: BorderSide(
                                    color: Colors
                                        .grey), // Change the border color when focused
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding:
                              EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal:
                                  10.0), // Adjust padding inside the TextFormField
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(
                            left: 10.0),
                        child: Container(
                          height: 30,
                          child: TextFormField(
                            style: TextStyle(
                                fontSize:
                                10), // Change the font size of the text inside the TextFormField
                            decoration:
                            InputDecoration(
                              hintText:
                              '00:00 AM', // Change labelText to hintText
                              hintStyle: TextStyle(
                                  fontSize: 10,
                                  color: Colors
                                      .grey), // Change the font size of the hint text to 10 and color to grey
                              border:
                              OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    10.0), // Make edges curvier
                                borderSide: BorderSide(
                                    color: Colors
                                        .grey[
                                    500]!), // Make the border color grey
                              ),
                              enabledBorder:
                              OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    10.0), // Make edges curvier
                                borderSide: BorderSide(
                                    color: Colors
                                        .grey[
                                    500]!), // Make the border color grey
                              ),
                              focusedBorder:
                              OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    10.0), // Make edges curvier
                                borderSide: BorderSide(
                                    color: Colors
                                        .grey), // Change the border color when focused
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding:
                              EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal:
                                  10.0), // Adjust padding inside the TextFormField
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 30),
              Text(
                'Recipient',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal:
                30.0), // Add padding to left and right
            child: Container(
              height: 30,
              width: 450, // Set the width to 500
              child: TextFormField(
                style: TextStyle(
                    fontSize:
                    10), // Change the font size of the text inside the TextFormField
                decoration: InputDecoration(
                  hintText:
                  'recipient name', // Change labelText to hintText
                  hintStyle: TextStyle(
                      fontSize: 10,
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
          ),
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 30),
              Text(
                'Route',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal:
                30.0), // Add padding to left and right
            child: Container(
              height: 30,
              width: 450, // Set the width to 500
              child: TextFormField(
                style: TextStyle(
                    fontSize:
                    10), // Change the font size of the text inside the TextFormField
                decoration: InputDecoration(
                  hintText:
                  'name of point person', // Change labelText to hintText
                  hintStyle: TextStyle(
                      fontSize: 10,
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
          ),
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 30),
              Text(
                'Loading',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal:
                30.0), // Add padding to left and right
            child: Container(
              height: 30,
              width: 450, // Set the width to 500
              child: TextFormField(
                style: TextStyle(
                    fontSize:
                    10), // Change the font size of the text inside the TextFormField
                decoration: InputDecoration(
                  hintText:
                  'somewhere, cebu', // Change labelText to hintText
                  hintStyle: TextStyle(
                      fontSize: 10,
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
          ),
        ],
      ),
      actions: <Widget>[
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .pop(); // Dismiss the dialog
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty
                  .resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(
                      MaterialState.pressed)) {
                    // return grey when pressed
                    return Colors.grey[300]!;
                  }
                  // return blue when not pressed
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
}
