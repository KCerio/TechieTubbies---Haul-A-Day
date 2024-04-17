import 'package:flutter/material.dart';


class AccountInformation extends StatelessWidget {
  final String pictureUrl;
  final String staffID;
  final String fullName;
  final String position;
  final String registeredDate;
  final String contactNumber;

  const AccountInformation({
    Key? key,
    required this.pictureUrl,
    required this.staffID,
    required this.fullName,
    required this.position,
    required this.registeredDate,
    required this.contactNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        automaticallyImplyLeading: false,
        title: Text(
          'Account Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            height: 550,
            decoration: BoxDecoration(
              color: Colors.green[200], // Set the color of the container here
              borderRadius: BorderRadius.circular(30.0), // Set the radius here
            ),
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 75,
                  backgroundImage: NetworkImage(pictureUrl),
                ),
                SizedBox(height: 20),
                _curvedContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'StaffID',
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                      SizedBox(
                          height: 0.5), // Add spacing between the text widgets
                      Text(
                        staffID,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[500]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _curvedContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                      SizedBox(
                          height: 0.5), // Add spacing between the text widgets
                      Text(
                        fullName,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[500]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _curvedContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Position',
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                      SizedBox(
                          height: 0.5), // Add spacing between the text widgets
                      Text(
                        position,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[500]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _curvedContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Registered Date',
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                      SizedBox(
                          height: 0.5), // Add spacing between the text widgets
                      Text(
                        registeredDate,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[500]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _curvedContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Contact Number',
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                      SizedBox(
                          height: 0.5), // Add spacing between the text widgets
                      Text(
                        contactNumber,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[500]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _curvedContainer({required Widget child}) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20), // Adjust the radius to your preference
      ),
      child: child,
    );
  }
}
