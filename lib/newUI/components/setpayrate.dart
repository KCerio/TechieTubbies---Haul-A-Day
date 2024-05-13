import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:haul_a_day_web/service/payrollService.dart';

class RateDialog extends StatefulWidget {
  const RateDialog({super.key});

  @override
  State<RateDialog> createState() => _RateDialogState();
}

class _RateDialogState extends State<RateDialog> {
  bool? isCheck = false;
  Map<String,dynamic> _rates = {};
  TextEditingController _drivercontroller = TextEditingController();
  TextEditingController _helpercontroller = TextEditingController();
  TextEditingController _loadingcontroller = TextEditingController();
  TextEditingController _cebucontroller = TextEditingController();
  TextEditingController _othercontroller = TextEditingController();


  @override
  void initState() {
    super.initState();
    _initializeStaffData();
    
  }

  Future<void> _initializeStaffData() async {
    try {
      PayrollService payrollService = new PayrollService();
      Map<String, dynamic> rates = await payrollService.getPayRate();
      setState(() {
        _rates = rates;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return _rates.isEmpty 
    ? Container(
      width: 700,
      height: 800,
      child: Center(
        child: CircularProgressIndicator(color: Colors.green,),
        )
      )
    : Container(
      width: 700,
      height: 800,
      //color: Colors.blue,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              //color: Colors.green,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black, )
                )
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
                        Text('Update Pay Rate Form',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter' 
                        ),
                        ),
                        const SizedBox(height:5),
                        Text('Fill in the necessary changes to the pay rate.\nBelow is the recorded pay rate is provided.',
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
            flex:8,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  width: 700,
                  height: 241,
                  //color: Colors.green,
                  child: Column(
                    children: [
                      Container(
                        width: 520,
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "Recorded Rates",
                          style: TextStyle(
                            fontFamily: 'InriaSans',
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Container(
                        width: 500,
                        height: 180,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color.fromRGBO(56, 113, 193, 1)),
                          borderRadius: BorderRadius.circular(10),
                          color:Color.fromRGBO(190, 216, 253, 1)
                        ),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              margin: EdgeInsets.only(bottom: 12),
                              width: 249,
                              //color: Colors.blue,
                              // decoration: BoxDecoration(
                              //   border: Border(left: BorderSide(color: Color.fromRGBO(56, 113, 193, 1)))
                              // ),
                              child: Column(
                                children: [
                                  Container(
                                    height:35,
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Employee Rate',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  //const SizedBox(height: 10),
                                  Container(
                                    width:249,
                                    height: 130,
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical:8),
                                    decoration: BoxDecoration(
                                      color: Colors.white, 
                                      // border: Border(
                                      //   top: BorderSide(color: Colors.black, width: 1.0,),
                                      //   bottom: BorderSide(color: Colors.black, width: 1.0,),
                                      // ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Job Position Salary:',
                                          style:TextStyle(
                                            color: Color.fromRGBO(148,143,143, 1),
                                            fontSize: 14
                                          )
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Driver Rate',
                                              style: TextStyle(
                                                fontFamily: 'InriaSans',
                                                fontSize: 15,
                                                //color: Color.fromRGBO(148,143,143, 1)
                                              )
                                            ),
                                            const SizedBox(width: 17),
                                            Text(
                                              'Php ${_rates['driverRate'].toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontFamily: 'InriaSans',
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(56, 113, 193, 1)
                                              )
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Helper Rate',
                                              style: TextStyle(
                                                fontFamily: 'InriaSans',
                                                fontSize: 15,
                                                //color: Color.fromRGBO(148,143,143, 1)
                                              )
                                            ),
                                            const SizedBox(width: 15),
                                            Text(
                                              'Php ${_rates['helperRate'].toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontFamily: 'InriaSans',
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(56, 113, 193, 1)
                                              )
                                            )
                                          ],
                                        ),
                                        //Text('Other Rate'),
                                      ],
                                    )
                                  ),
                                ],
                              ),
                            ),
                          
                            Container(
                              alignment: Alignment.bottomCenter,
                              width: 249,
                              //color: Colors.blue,
                              decoration: BoxDecoration(
                                border: Border(left: BorderSide(color: Color.fromRGBO(56, 113, 193, 1)))
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height:35,
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Trip Rate',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  //const SizedBox(height: 10),
                                  Container(
                                    width:249,
                                    height: 130,
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical:5),
                                    decoration: BoxDecoration(
                                      color: Colors.white, 
                                      // border: Border(
                                      //   top: BorderSide(color: Colors.black, width: 1.0,),
                                      //   bottom: BorderSide(color: Colors.black, width: 1.0,),
                                      // ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Daily Wage Equivalent:',
                                          style:TextStyle(
                                            color: Color.fromRGBO(148,143,143, 1),
                                            fontSize: 14
                                          )
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Loading Rate',
                                              style: TextStyle(
                                                fontFamily: 'InriaSans',
                                                fontSize: 15,
                                                //color: Color.fromRGBO(148,143,143, 1)
                                              )
                                            ),
                                            const SizedBox(width: 20),
                                            Text(
                                              '${_rates['loadingRate'].toString()} day',
                                              style: TextStyle(
                                                fontFamily: 'InriaSans',
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(56, 113, 193, 1)
                                              )
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Cebu Rate',
                                              style: TextStyle(
                                                fontFamily: 'InriaSans',
                                                fontSize: 15,
                                                //color: Color.fromRGBO(148,143,143, 1)
                                              )
                                            ),
                                            const SizedBox(width: 40),
                                            Text(
                                              '${_rates['cebuRate'].toString()} day',
                                              style: TextStyle(
                                                fontFamily: 'InriaSans',
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(56, 113, 193, 1)
                                              )
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Other Rates',
                                              style: TextStyle(
                                                fontFamily: 'InriaSans',
                                                fontSize: 15,
                                                //color: Color.fromRGBO(148,143,143, 1)
                                              )
                                            ),
                                            const SizedBox(width: 29),
                                            Text(
                                              '${_rates['noncebuRate'].toString()} days',
                                              style: TextStyle(
                                                fontFamily: 'InriaSans',
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(56, 113, 193, 1)
                                              )
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  width: 700,
                  height: 258,
                  //color: Colors.blue,
                  // decoration: BoxDecoration(
                  //   border: Border(top: BorderSide(color:Colors.grey))
                  // ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 700,
                        child: Text(
                          'Wish to update pay rates?'
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Container(                        
                        width: 600,
                        height: 200,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          //color: Colors.yellow,
                          border: Border(top: BorderSide(color: Colors.black))
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 600,
                              height: 188,
                              // decoration: BoxDecoration(
                              //   border: Border.all(color: Colors.black)
                              // ),
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    margin: EdgeInsets.only(bottom: 12),
                                    width: 299,
                                    //color: Colors.blue,
                                    // decoration: BoxDecoration(
                                    //   border: Border(left: BorderSide(color: Color.fromRGBO(56, 113, 193, 1)))
                                    // ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height:35,
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Employee Rate',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        //const SizedBox(height: 10),
                                        Container(
                                          width:290,
                                          height: 130,
                                          padding: EdgeInsets.symmetric(horizontal: 5, vertical:8),
                                          decoration: BoxDecoration(
                                            color: Colors.white, 
                                            // border: Border(
                                            //   top: BorderSide(color: Colors.black, width: 1.0,),
                                            //   bottom: BorderSide(color: Colors.black, width: 1.0,),
                                            // ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Job Position Salary:',
                                                style:TextStyle(
                                                  color: Color.fromRGBO(148,143,143, 1),
                                                  fontSize: 14
                                                )
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [                                                  
                                                  Text(
                                                    'Driver Rate',
                                                    style: TextStyle(
                                                      fontFamily: 'InriaSans',
                                                      fontSize: 15,
                                                      //color: Color.fromRGBO(148,143,143, 1)
                                                    )
                                                  ),
                                                  const SizedBox(width: 17),
                                                  Container(
                                                    height: 30,
                                                    width: 170,
                                                    child:LayoutBuilder(
                                                      builder: (context, constraints) {
                                                        double availableWidth = constraints.maxWidth;
                                                        // Adjust this value according to your needs
                                                        double fontSize = availableWidth * 0.08; // Adjust the multiplier as needed

                                                        return TextField(
                                                          controller: _drivercontroller,
                                                          decoration: InputDecoration(
                                                            contentPadding: EdgeInsets.symmetric(vertical: 2),
                                                            hintText: _rates['driverRate'].toString(),
                                                            border: OutlineInputBorder(),
                                                          ),
                                                          style: TextStyle(fontSize: fontSize),
                                                          textAlign: TextAlign.center, // Center align horizontally
                                                          textAlignVertical: TextAlignVertical.center, // Center align vertically
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Helper Rate',
                                                    style: TextStyle(
                                                      fontFamily: 'InriaSans',
                                                      fontSize: 15,
                                                      //color: Color.fromRGBO(148,143,143, 1)
                                                    )
                                                  ),
                                                  const SizedBox(width: 15),
                                                  Container(
                                                    height: 30,
                                                    width: 170,
                                                    child:LayoutBuilder(
                                                      builder: (context, constraints) {
                                                        double availableWidth = constraints.maxWidth;
                                                        // Adjust this value according to your needs
                                                        double fontSize = availableWidth * 0.08; // Adjust the multiplier as needed

                                                        return TextField(
                                                          controller: _helpercontroller,
                                                          decoration: InputDecoration(
                                                            contentPadding: EdgeInsets.symmetric(vertical: 2),
                                                            hintText: _rates['helperRate'].toString(),
                                                            border: OutlineInputBorder(),
                                                          ),
                                                          style: TextStyle(fontSize: fontSize),
                                                          textAlign: TextAlign.center, // Center align horizontally
                                                          textAlignVertical: TextAlignVertical.center, // Center align vertically
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              //Text('Other Rate'),
                                            ],
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    width: 270,
                                    //color: Colors.blue,
                                    decoration: BoxDecoration(
                                      border: Border(left: BorderSide(color: Color.fromRGBO(56, 113, 193, 1)))
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height:35,
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Trip Rate',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        //const SizedBox(height: 10),
                                        Container(
                                          width:270,
                                          height: 150,
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical:5),
                                          decoration: BoxDecoration(
                                            color: Colors.white, 
                                            // border: Border(
                                            //   top: BorderSide(color: Colors.black, width: 1.0,),
                                            //   bottom: BorderSide(color: Colors.black, width: 1.0,),
                                            // ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Daily Wage Equivalent:',
                                                style:TextStyle(
                                                  color: Color.fromRGBO(148,143,143, 1),
                                                  fontSize: 14
                                                )
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Loading Rate',
                                                    style: TextStyle(
                                                      fontFamily: 'InriaSans',
                                                      fontSize: 15,
                                                      //color: Color.fromRGBO(148,143,143, 1)
                                                    )
                                                  ),
                                                  const SizedBox(width: 20),
                                                  Container(
                                                    height: 30,
                                                    width: 129,
                                                    child:LayoutBuilder(
                                                      builder: (context, constraints) {
                                                        double availableWidth = constraints.maxWidth;
                                                        // Adjust this value according to your needs
                                                        double fontSize = availableWidth * 0.1; // Adjust the multiplier as needed

                                                        return TextField(
                                                          controller: _loadingcontroller,
                                                          decoration: InputDecoration(
                                                            contentPadding: EdgeInsets.symmetric(vertical: 2),
                                                            hintText: _rates['loadingRate'].toString(),
                                                            border: OutlineInputBorder(),
                                                          ),
                                                          style: TextStyle(fontSize: fontSize),
                                                          textAlign: TextAlign.center, // Center align horizontally
                                                          textAlignVertical: TextAlignVertical.center, // Center align vertically
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Cebu Rate',
                                                    style: TextStyle(
                                                      fontFamily: 'InriaSans',
                                                      fontSize: 15,
                                                      //color: Color.fromRGBO(148,143,143, 1)
                                                    )
                                                  ),
                                                  const SizedBox(width: 40),
                                                  Container(
                                                    height: 30,
                                                    width: 129,
                                                    child:LayoutBuilder(
                                                      builder: (context, constraints) {
                                                        double availableWidth = constraints.maxWidth;
                                                        // Adjust this value according to your needs
                                                        double fontSize = availableWidth * 0.1; // Adjust the multiplier as needed

                                                        return TextField(
                                                          controller: _cebucontroller,
                                                          decoration: InputDecoration(
                                                            contentPadding: EdgeInsets.symmetric(vertical: 2),
                                                            hintText: _rates['cebuRate'].toString(),
                                                            border: OutlineInputBorder(),
                                                          ),
                                                          style: TextStyle(fontSize: fontSize),
                                                          textAlign: TextAlign.center, // Center align horizontally
                                                          textAlignVertical: TextAlignVertical.center, // Center align vertically
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Other Rates',
                                                    style: TextStyle(
                                                      fontFamily: 'InriaSans',
                                                      fontSize: 15,
                                                      //color: Color.fromRGBO(148,143,143, 1)
                                                    )
                                                  ),
                                                  const SizedBox(width: 28),
                                                  Container(
                                                    height: 30,
                                                    width: 129,
                                                    child:LayoutBuilder(
                                                      builder: (context, constraints) {
                                                        double availableWidth = constraints.maxWidth;
                                                        // Adjust this value according to your needs
                                                        double fontSize = availableWidth * 0.1; // Adjust the multiplier as needed

                                                        return TextField(
                                                          controller: _othercontroller,
                                                          decoration: InputDecoration(
                                                            contentPadding: EdgeInsets.symmetric(vertical: 2),
                                                            hintText: _rates['noncebuRate'].toString(),
                                                            border: OutlineInputBorder(),
                                                          ),
                                                          style: TextStyle(fontSize: fontSize),
                                                          textAlign: TextAlign.center, // Center align horizontally
                                                          textAlignVertical: TextAlignVertical.center, // Center align vertically
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 700,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                            value: isCheck,
                            onChanged: (newValue) {
                              setState(() {
                                print('checked: ${_drivercontroller.text} + ${_helpercontroller.text} + ${_othercontroller.text} + ${_loadingcontroller.text}');
                                isCheck = newValue!;
                              });
                            },
                          ),
                            const Text(
                              'Confirm Changes',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Arial',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height:8),
                ElevatedButton(
                  onPressed: (){
                    if (isCheck == true) {
                      if (_drivercontroller.text.isNotEmpty ||
                          _helpercontroller.text.isNotEmpty ||
                          _loadingcontroller.text.isNotEmpty ||
                          _cebucontroller.text.isNotEmpty ||
                          _othercontroller.text.isNotEmpty) {
                        // Convert text to integers
                        int driverRate = _drivercontroller.text.isNotEmpty ? int.parse(_drivercontroller.text) : _rates['driverRate'];
                        int helperRate = _helpercontroller.text.isNotEmpty ? int.parse(_helpercontroller.text) : _rates['helperRate'];
                        int loadingRate = _loadingcontroller.text.isNotEmpty ? int.parse(_loadingcontroller.text) : _rates['loadingRate'];
                        int cebuRate = _cebucontroller.text.isNotEmpty ? int.parse(_cebucontroller.text) : _rates['cebuRate'];
                        int otherRate = _othercontroller.text.isNotEmpty ? int.parse(_othercontroller.text) : _rates['noncebuRate'];

                        PayrollService payrollService = PayrollService();
                        payrollService.updatePayRate(driverRate, helperRate, cebuRate, loadingRate, otherRate);
                        
                        setState(() {
                         _rates['cebuRate'] = cebuRate;
                         _rates['noncebuRate'] = otherRate;
                         _rates['loadingRate'] = loadingRate;
                         _rates['driverRate'] = driverRate; 
                         _rates['helperRate'] = helperRate;
                        });

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Success'),
                              content: const Text('Pay Rate Updated.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
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
                      
                    }
                    else{
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Alert'),
                              content: const Text('Please confirm changes before saving.'),
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
                        Color.fromRGBO(190, 216, 253, 1),
                      ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontFamily: 'InriaSans',
                      fontSize: 16,
                      color: Colors.black ,
                      fontWeight: FontWeight.bold                                             
                    ),
                  ),
                )
              ],
            )
          )
        ],
      )
    );
  }
}


// Widget setRateDialog(BuildContext context, Map<String,dynamic> _rates){
//   bool isCheck = false;
//   //BuildContext context = BuildContext;
//   return Container(
//     width: 700,
//     height: 750,
//     //color: Colors.blue,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(15.0),
//       color: Colors.white,
//     ),
//     child: Column(
//       children: [
//         Expanded(
//           flex: 2,
//           child: Container(
//             //color: Colors.green,
//             decoration: BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(color: Colors.black, )
//               )
//             ),
//             margin: EdgeInsets.symmetric(horizontal: 30),
//             padding: EdgeInsets.fromLTRB(25, 16, 0, 10),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset('images/logo2_trans.png'),
//                 const SizedBox(width: 50,),
//                 Container(
//                   // decoration: BoxDecoration(
//                   //   border: Border.all(color: Colors.black)
//                   // ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       Text('Set Pay Rate Form',
//                       style: TextStyle(
//                         fontSize: 25,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Inter' 
//                       ),
//                       ),
//                       const SizedBox(height:5),
//                       Text('Fill in the necessary changes set to the pay rate.\nBelow is the recorded pay rate.',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.normal,
//                         fontFamily: 'InriaSans' 
//                       ),
//                       )
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                 onPressed: (){
//                   Navigator.pop(context);
//                 }, 
//                 icon: Icon(Icons.close)
//               )
//               ],
//             )
//           ),
//         ),
//         Expanded(
//           flex:6,
//           child: Column(
//             children: [
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 30),
//                 padding: EdgeInsets.all(16),
//                 alignment: Alignment.center,
//                 width: 700,
//                 height: 250,
//                 //color: Colors.green,
//                 child: Column(
//                   children: [
//                     Container(
//                       width: 520,
//                       alignment: Alignment.topLeft,
//                       child: const Text(
//                         "Recorded Rates",
//                         style: TextStyle(
//                           fontFamily: 'InriaSans',
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: 500,
//                       height: 180,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Color.fromRGBO(56, 113, 193, 1)),
//                         borderRadius: BorderRadius.circular(10),
//                         color:Color.fromRGBO(190, 216, 253, 1)
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             alignment: Alignment.bottomCenter,
//                             margin: EdgeInsets.only(bottom: 12),
//                             width: 249,
//                             //color: Colors.blue,
//                             // decoration: BoxDecoration(
//                             //   border: Border(left: BorderSide(color: Color.fromRGBO(56, 113, 193, 1)))
//                             // ),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   height:35,
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     'Employee Rate',
//                                     style: TextStyle(
//                                       fontFamily: 'Inter',
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold
//                                     ),
//                                   ),
//                                 ),
//                                 //const SizedBox(height: 10),
//                                 Container(
//                                   width:249,
//                                   height: 130,
//                                   padding: EdgeInsets.symmetric(horizontal: 12, vertical:8),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white, 
//                                     // border: Border(
//                                     //   top: BorderSide(color: Colors.black, width: 1.0,),
//                                     //   bottom: BorderSide(color: Colors.black, width: 1.0,),
//                                     // ),
//                                   ),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Text(
//                                             'Driver Rate',
//                                             style: TextStyle(
//                                               fontFamily: 'InriaSans',
//                                               fontSize: 15,
//                                               //color: Color.fromRGBO(148,143,143, 1)
//                                             )
//                                           ),
//                                           const SizedBox(width: 17),
//                                           Text(
//                                             'Php ${_rates['driverRate'].toStringAsFixed(2)}',
//                                             style: TextStyle(
//                                               fontFamily: 'InriaSans',
//                                               fontSize: 20,
//                                               fontWeight: FontWeight.bold,
//                                               color: Color.fromRGBO(56, 113, 193, 1)
//                                             )
//                                           )
//                                         ],
//                                       ),
//                                       Row(
//                                         children: [
//                                           Text(
//                                             'Helper Rate',
//                                             style: TextStyle(
//                                               fontFamily: 'InriaSans',
//                                               fontSize: 15,
//                                               //color: Color.fromRGBO(148,143,143, 1)
//                                             )
//                                           ),
//                                           const SizedBox(width: 15),
//                                           Text(
//                                             'Php ${_rates['helperRate'].toStringAsFixed(2)}',
//                                             style: TextStyle(
//                                               fontFamily: 'InriaSans',
//                                               fontSize: 20,
//                                               fontWeight: FontWeight.bold,
//                                               color: Color.fromRGBO(56, 113, 193, 1)
//                                             )
//                                           )
//                                         ],
//                                       ),
//                                       //Text('Other Rate'),
//                                     ],
//                                   )
//                                 ),
//                               ],
//                             ),
//                           ),
                        
//                           Container(
//                             alignment: Alignment.bottomCenter,
//                             width: 249,
//                             //color: Colors.blue,
//                             decoration: BoxDecoration(
//                               border: Border(left: BorderSide(color: Color.fromRGBO(56, 113, 193, 1)))
//                             ),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   height:35,
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     'Trip Rate',
//                                     style: TextStyle(
//                                       fontFamily: 'Inter',
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold
//                                     ),
//                                   ),
//                                 ),
//                                 //const SizedBox(height: 10),
//                                 Container(
//                                   width:249,
//                                   height: 130,
//                                   padding: EdgeInsets.symmetric(horizontal: 12, vertical:5),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white, 
//                                     // border: Border(
//                                     //   top: BorderSide(color: Colors.black, width: 1.0,),
//                                     //   bottom: BorderSide(color: Colors.black, width: 1.0,),
//                                     // ),
//                                   ),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       const Text(
//                                         'Daily Wage Equivalent:',
//                                         style:TextStyle(
//                                           color: Color.fromRGBO(148,143,143, 1),
//                                           fontSize: 14
//                                         )
//                                       ),
//                                       Row(
//                                         children: [
//                                           Text(
//                                             'Loading Rate',
//                                             style: TextStyle(
//                                               fontFamily: 'InriaSans',
//                                               fontSize: 15,
//                                               //color: Color.fromRGBO(148,143,143, 1)
//                                             )
//                                           ),
//                                           const SizedBox(width: 20),
//                                           Text(
//                                             '${_rates['loadingRate'].toString()} day',
//                                             style: TextStyle(
//                                               fontFamily: 'InriaSans',
//                                               fontSize: 20,
//                                               fontWeight: FontWeight.bold,
//                                               color: Color.fromRGBO(56, 113, 193, 1)
//                                             )
//                                           )
//                                         ],
//                                       ),
//                                       Row(
//                                         children: [
//                                           Text(
//                                             'Cebu Rate',
//                                             style: TextStyle(
//                                               fontFamily: 'InriaSans',
//                                               fontSize: 15,
//                                               //color: Color.fromRGBO(148,143,143, 1)
//                                             )
//                                           ),
//                                           const SizedBox(width: 40),
//                                           Text(
//                                             '${_rates['cebuRate'].toString()} day',
//                                             style: TextStyle(
//                                               fontFamily: 'InriaSans',
//                                               fontSize: 20,
//                                               fontWeight: FontWeight.bold,
//                                               color: Color.fromRGBO(56, 113, 193, 1)
//                                             )
//                                           )
//                                         ],
//                                       ),
//                                       Row(
//                                         children: [
//                                           Text(
//                                             'Other Rates',
//                                             style: TextStyle(
//                                               fontFamily: 'InriaSans',
//                                               fontSize: 15,
//                                               //color: Color.fromRGBO(148,143,143, 1)
//                                             )
//                                           ),
//                                           const SizedBox(width: 29),
//                                           Text(
//                                             '${_rates['noncebuRate'].toString()} days',
//                                             style: TextStyle(
//                                               fontFamily: 'InriaSans',
//                                               fontSize: 20,
//                                               fontWeight: FontWeight.bold,
//                                               color: Color.fromRGBO(56, 113, 193, 1)
//                                             )
//                                           )
//                                         ],
//                                       ),
//                                     ],
//                                   )
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 )
//               ),
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 30),
//                 padding: EdgeInsets.all(16),
//                 alignment: Alignment.center,
//                 width: 700,
//                 height: 255,
//                 color: Colors.blue,
//                 // decoration: BoxDecoration(
//                 //   border: Border(top: BorderSide(color:Colors.grey))
//                 // ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       alignment: Alignment.centerLeft,
//                       width: 700,
//                       child: Text(
//                         'Wish to update pay rates?'
//                       ),
//                     ),
//                     Container(
//                       color: Colors.yellow,
//                       width: 600,
//                       height: 160,
//                     ),
//                     Container(
//                       width: 700,
//                       alignment: Alignment.center,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Checkbox(
//                           value: isCheck,
//                           onChanged: (newValue) {
//                             isCheck = newValue!;
//                           },
//                         ),
//                           const Text(
//                             'Confirm Changes',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontFamily: 'Arial',
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           )
//         )
//       ],
//     )
//   );
// }

