import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:haul_a_day_web/models/user_model.dart';
import 'package:haul_a_day_web/service/userService.dart';
import 'package:intl/intl.dart';

class AccountApprovalDialog extends StatefulWidget {
  final Map<String, dynamic> account;
  final String userId;
  final Function(Map<String, dynamic>?) access;
  const AccountApprovalDialog({super.key, required this.account, required this.userId, required this.access});

  @override
  State<AccountApprovalDialog> createState() => _AccountApprovalDialogState();
}

class _AccountApprovalDialogState extends State<AccountApprovalDialog> {
  UserService userService = UserService();
  Map<String, dynamic> account={};
  String _selectedAccess = ''; // Variable to store the selected access
  TextEditingController _staffIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      account = widget.account;
    });
  }

  void confirmApproval() async{
    // Add your approval logic here                      
    String password = _passwordController.text;
    // Perform validation and approval process
    bool approved = await userService.confirmation(widget.userId, password);
    if(approved){
      userService.approveAccount(account['staffId'], _selectedAccess);
      Navigator.of(context).pop();
      setState(() {
        account['accessKey'] = _selectedAccess;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Account Approved'),
            content:  Text('This account is now approved!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  widget.access({
                    'accessKey': _selectedAccess,
                    'remove' : false
                  });
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content:  Text('User ID and Password do not match!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

  }

  void rejectAccount()async{
    // Add your approval logic here                      
    String password = _passwordController.text;
    // Perform validation and approval process
    bool approved = await userService.confirmation(widget.userId, password);
    if(approved){
      userService.removeAccount(account['staffId']);
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Account Removed'),
            content:  Text('This account is now denied and removed!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  widget.access({
                    'accessKey': null,
                    'remove' : true
                  });
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content:  Text('User ID and Password do not match!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Account ID: ${account['id']}');
    String registeredDate;
    if (account['registeredDate'] is String) {
      registeredDate = account['registeredDate'] ?? ' ';
    } else if(account['registeredDate'] == null){
      registeredDate = ' ';
    }
    else {
      registeredDate = DateFormat('MMM dd, yyyy').format(account['registeredDate'].toDate());
    }

    return account == {} 
    ? Container(
      height: 600,
      width: 900,
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Row(
                children: [
                  Image.asset('images/logo2_trans.png',
                      height: 150, width: 150),
                  const SizedBox(width: 80),
                  const Text('Account Validation',
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 3.0),
                height: 3.0,
                color: Colors.blue,
              ),
            )
          ],
        ),
        contentPadding: const EdgeInsets.all(10),
        content: Container(
          height: 410,
          width: 850,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(50),
                right: Radius.circular(50),
              ),
            ),
            child: Center(child: CircularProgressIndicator(),)
            )
          )
        )
      )
    : Container(
      height: 600,
      width: 900,
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Row(
                children: [
                  Image.asset('images/logo2_trans.png',
                      height: 150, width: 150),
                  const SizedBox(width: 80),
                  const Text('Account Validation',
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 3.0),
                height: 3.0,
                color: Colors.blue,
              ),
            )
          ],
        ),
        contentPadding: const EdgeInsets.all(10),
        content: Container(
          height: 410,
          width: 850,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(50),
                right: Radius.circular(50),
              ),
            ),
            child: LayoutBuilder(
              builder: (context,constraints) {
                double width = constraints.maxWidth;
                double height = constraints.maxHeight;
                return Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Container(
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: width * 0.35,
                                margin:EdgeInsets.symmetric(horizontal: 40, vertical:30),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 10),
                                      Container(
                                        width: width * 0.34,
                                        child: CircleAvatar(
                                          radius: 70,
                                          backgroundColor:
                                          Colors.white,
                                          backgroundImage: account['pictureUrl'] != null
                                            ? NetworkImage(account['pictureUrl'])
                                            : Image.asset('images/user_pic.png').image,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      
                                      Text(
                                        account['staffId'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      const Text(
                                        'Staff ID#',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          //fontWeight: FontWeight.bold
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  //width: width * 0.6,
                                  //color: Colors.green,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      double width = constraints.maxWidth;
                                      double height = constraints.maxHeight;
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(height:10),
                                          const Text(
                                            'Account Information',
                                            style:TextStyle(
                                              fontSize:22,
                                              fontFamily: 'Inter',
                                              color:Colors.grey,
                                              fontWeight: FontWeight.bold
                                            )
                                          ),
                                          const SizedBox(height:10),
                                          // firstname and lastname
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'First Name',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 25,
                                                    width: width *0.45,
                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius.horizontal(
                                                        left: Radius.circular(
                                                            20.0), // Adjust the radius as needed
                                                        right: Radius.circular(
                                                            20.0), // Adjust the radius as needed
                                                      ),
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                    ),
                                                    child: Text(
                                                      account['firstname'],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        //fontFamily: 'Inter'
                                                      ),
                                                    )
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(width: 10,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Last Name',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 25,
                                                    width: width *0.45,
                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius.horizontal(
                                                        left: Radius.circular(
                                                            20.0), // Adjust the radius as needed
                                                        right: Radius.circular(
                                                            20.0), // Adjust the radius as needed
                                                      ),
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                    ),
                                                    child: Text(
                                                      account['lastname'],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        //fontFamily: 'Inter'
                                                      ),
                                                    )
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10,),
                                          
                                          //Job Position and Contact No.
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Job Position',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 25,
                                                    width: width *0.45,
                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius.horizontal(
                                                        left: Radius.circular(
                                                            20.0), // Adjust the radius as needed
                                                        right: Radius.circular(
                                                            20.0), // Adjust the radius as needed
                                                      ),
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                    ),
                                                    child: Text(
                                                      account['position'],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        //fontFamily: 'Inter'
                                                      ),
                                                    )
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(width: 10,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Contact Number',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 25,
                                                    width: width *0.45,
                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius.horizontal(
                                                        left: Radius.circular(
                                                            20.0), // Adjust the radius as needed
                                                        right: Radius.circular(
                                                            20.0), // Adjust the radius as needed
                                                      ),
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                    ),
                                                    child: Text(
                                                      account['contactNumber'],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        //fontFamily: 'Inter'
                                                      ),
                                                    )
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10,),
                                          
                                          // Registered Date
                                          Container(
                                            width: width,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Registered Date',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Container(
                                                  height: 25,
                                                  width: width *0.45,
                                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        const BorderRadius.horizontal(
                                                      left: Radius.circular(
                                                          20.0), // Adjust the radius as needed
                                                      right: Radius.circular(
                                                          20.0), // Adjust the radius as needed
                                                    ),
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                  ),
                                                  child: Text(
                                                    registeredDate,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      //fontFamily: 'Inter'
                                                    ),
                                                  )
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 20,),
                                          
                                          //Access Key
                                          Container(
                                            width: width,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Give Account Access to Management Portal?',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontStyle: FontStyle.italic
                                                  ),
                                                ),
                                                Container(
                                                  //height: 25,
                                                  width: width,
                                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                                  
                                                  child: //Radio Button
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Radio<String>(
                                                            value: 'Basic',
                                                            groupValue: _selectedAccess,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _selectedAccess = value!;
                                                              });
                                                              print(_selectedAccess);
                                                            },
                                                          ),
                                                          Text('No'),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Radio<String>(
                                                            value: 'Admin',
                                                            groupValue: _selectedAccess,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _selectedAccess = value!;
                                                              });
                                                              print(_selectedAccess);
                                                            },
                                                          ),
                                                          Text('Admin'),
                                                        ],
                                                      ),
                                                      
                                                      Row(
                                                        children: [
                                                          Radio<String>(
                                                            value: 'superAdmin',
                                                            groupValue: _selectedAccess,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _selectedAccess = value!;
                                                              });
                                                              print(_selectedAccess);
                                                            },
                                                          ),
                                                          Text('Super Admin'),
                                                        ],
                                                      )
                                                    ],
                                                  ),

                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context,constraints) {
                            return Container(
                              width: constraints.maxWidth,
                              alignment: Alignment.center,
                              //color: Colors.yellow,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        if(_selectedAccess == ''){
                                          print('_selectedAccess is empty');
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Alert'),
                                                content: const Text('Select access type for this account.'),
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
                                        else{
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Approval Confirmation'),
                                                content: Container(
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: Colors.white
                                                  ),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const Text('Do you wish to validate this account? If yes please input your password to confirm approval.',
                                                      softWrap: true,
                                                      style:TextStyle(
                                                        fontStyle: FontStyle.italic
                                                      ),
                                                      ),
                                                      const SizedBox(height: 10,),
                                                      Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text('User ID:', style: TextStyle(fontSize: 16),),
                                                                const SizedBox(width: 8,),
                                                                Text(widget.userId, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                                              ],
                                                            ),
                                                            TextField(
                                                              onSubmitted: (_){
                                                                confirmApproval();
                                                                
                                                              },
                                                              controller: _passwordController,
                                                              obscureText: true,
                                                              decoration: InputDecoration(
                                                                labelText: 'Password',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () async{
                                                      confirmApproval();
                                                     
                                                    },
                                                    child: Text('Confirm'),
                                                  ),
                                                  const SizedBox(width: 8,),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop(); // Close the dialog
                                                    },
                                                    child: Text('Cancel'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                        //Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape:
                                            const RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.horizontal(
                                            left: Radius.circular(10.0),
                                            right: Radius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          ),
                                          const SizedBox(width: 8.0),
                                          const Text(
                                            'Accept',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Rejection Confirmation'),
                                              content: Container(
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Colors.white
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Text('Do you wish to reject this account? If yes please input your password to confirm rejection.',
                                                    softWrap: true,
                                                    style:TextStyle(
                                                      fontStyle: FontStyle.italic
                                                    ),
                                                    ),
                                                    const SizedBox(height: 10,),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text('User ID:', style: TextStyle(fontSize: 16),),
                                                              const SizedBox(width: 8,),
                                                              Text(widget.userId, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                          TextField(
                                                            onSubmitted: (_){
                                                              //confirmApproval();
                                                              rejectAccount();
                                                            },
                                                            controller: _passwordController,
                                                            obscureText: true,
                                                            decoration: InputDecoration(
                                                              labelText: 'Password',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () async{
                                                    //confirmApproval();
                                                    rejectAccount();
                                                  },
                                                  child: Text('Confirm'),
                                                ),
                                                const SizedBox(width: 8,),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(); // Close the dialog
                                                  },
                                                  child: Text('Cancel'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape:
                                            const RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.horizontal(
                                            left: Radius.circular(10.0),
                                            right: Radius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ),
                                          const SizedBox(width: 8.0),
                                          const Text(
                                            'Reject',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }
                        ),
                      )
                    ],
                  )
                );
              }
            ),
          ),
        ),
      ),
    );
  }


}
