import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/service/payrollService.dart';

class ComputeDialog extends StatefulWidget {
  final Map<String, dynamic> staff;
  const ComputeDialog({super.key, required this.staff});

  @override
  State<ComputeDialog> createState() => _ComputeDialogState();
}

class _ComputeDialogState extends State<ComputeDialog> {
  List<String> _deliveries = [];
  Map<String, dynamic> staff = {};
  double salaryRate = 0;
  //Map<String,dynamic> _rates = {};
  List<Map<String,dynamic>> deductions= [
    {'name': 'SSS', 'amount': 0},
    {'name': 'PhilHealth', 'amount': 0},
    {'name': 'Pag-ibig', 'amount': 0},
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    staff = widget.staff;
    _initializeStaffData();
    fetchData(staff['staffId']);
  }

  void fetchData(String staffId)async{
    PayrollService payrollService = new PayrollService();
    List<String> deliveries = await payrollService.accomplishedDeliveries(staffId);
    print('Accomplished Deliveries: $deliveries');
    setState(() {
      _deliveries = deliveries;
    });
  }

  Future<void> _initializeStaffData() async {
    try {
      PayrollService payrollService = new PayrollService();
      Map<String, dynamic> rates = await payrollService.getPayRate();
      if(rates.isNotEmpty){
          if(staff['position'] == 'Driver'){
          setState(() {
            salaryRate = rates['driverRate'];
          });
        }else if(staff['position'] == 'Helper'){
          setState(() {
            salaryRate = rates['helperRate'];
          });
        }
      }
      
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1250,
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(                  
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
                      Container(
                        width: constraints.maxWidth *(5/6),
                        alignment: Alignment.center,                        
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('images/logo2_trans.png'),
                            const SizedBox(width: 80,),
                            Container(
                              // decoration: BoxDecoration(
                              //   border: Border.all(color: Colors.black)
                              // ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text('Compute Salary',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter' 
                                  ),
                                  ),
                                  const SizedBox(height:5),
                                  Text("Fill in the necessary changes to compute staff's salary.\nThe accomplished deliveries of staff is provided.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'InriaSans' 
                                  ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      icon: Icon(Icons.close)
                    ),
                    SizedBox(width:10)
                    ],
                  )
                );
              }
            ),
          ),
          Expanded(
            flex:8,
            child: LayoutBuilder(
              builder: (context,constraints) {
                return Row(              
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical:16),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical:10),
                      width: constraints.maxWidth/2-41,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            width: 400,
                            height: 100,
                            // decoration: BoxDecoration(
                            //   color: Colors.white,
                            //   borderRadius: BorderRadius.circular(10),
                            //   border: Border.all(color: Colors.grey)
                            // ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor:
                                  Colors.white,
                                  backgroundImage: staff['pictureUrl'] != null
                                    ? NetworkImage(staff['pictureUrl'])
                                    : Image.asset('images/user_pic.png').image,
                                ),
                                const SizedBox(width: 50,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${staff['firstname']} ${staff['lastname']}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight:
                                              FontWeight.bold,
                                          color:
                                              Colors.black,
                                              fontFamily: 'Inter'
                                              ),
                                    ),
                                    Text(
                                      'Staff ID: ${staff['staffId']}',
                                      style: const TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                          color:
                                              Colors.black,
                                              fontFamily: 'Inter'),
                                    ),
                                    Text(
                                      'Position: ${staff['position']}',
                                      style: const TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                          color:
                                              Colors.black,
                                              fontFamily: 'Inter'),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ),
                          const SizedBox(height: 8),
                          Divider(color: Colors.grey,),
                          const SizedBox(height:10),
                          Container(
                            width: 350,
                            height: 100,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Net Salary',
                                  style: TextStyle(
                                    fontFamily: 'InriaSans',
                                    fontSize: 16,
                                    color: Color.fromRGBO(115, 115, 115, 1)
                                  )
                                ),
                                Text(
                                  'Php 3,000.00',
                                  style: TextStyle(
                                    fontFamily: 'InriaSans',
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(56, 113, 193, 1)
                                  )
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 30,),

                          Container(
                            width: 450,
                            //height: 50,
                            //color: Colors.blue,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Claim Status',
                                    style: TextStyle(
                                      fontFamily: 'InriaSans',
                                      fontSize: 25,
                                      color: Color.fromRGBO(115, 115, 115, 1)
                                    )
                                  ),
                                  Text(
                                    'Not Claimed',
                                    style: TextStyle(
                                      fontFamily: 'InriaSans',
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green
                                    )
                                  )
                                ],
                              ),
                          ),
                          const SizedBox(height: 16,),

                          Container(
                            width: 450,
                            //height: 50,
                            //color: Colors.blue,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Claimed by:',
                                    style: TextStyle(
                                      fontFamily: 'InriaSans',
                                      fontSize: 19,
                                      color: Color.fromRGBO(115, 115, 115, 1)
                                    )
                                  ),
                                  Text(
                                    '--',
                                    style: TextStyle(
                                      fontFamily: 'InriaSans',
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey
                                    )
                                  )
                                ],
                              ),
                          ),
                          const SizedBox(height: 16,),

                          Container(
                            width: 450,
                            //height: 50,
                            //color: Colors.blue,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Date Claimed:',
                                    style: TextStyle(
                                      fontFamily: 'InriaSans',
                                      fontSize: 19,
                                      color: Color.fromRGBO(115, 115, 115, 1)
                                    )
                                  ),
                                  Text(
                                    '--',
                                    style: TextStyle(
                                      fontFamily: 'InriaSans',
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey
                                    )
                                  )
                                ],
                              ),
                          ),
                          const SizedBox(height: 16,),

                          Container(
                            width: 450,
                            //height: 50,
                            //color: Colors.blue,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Signature:',
                                    style: TextStyle(
                                      fontFamily: 'InriaSans',
                                      fontSize: 19,
                                      color: Color.fromRGBO(115, 115, 115, 1)
                                    )
                                  ),
                                  InkWell(
                                    onTap: (){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Container(
                                              width: 500,
                                              height:500,
                                              decoration: BoxDecoration(
                                                color: Color.fromRGBO(194, 192, 192, 1),
                                                borderRadius: BorderRadius.circular(10)
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(194, 192, 192, 1),
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ),
                          const SizedBox(height: 50),
                          ElevatedButton(
                            onPressed: (){
                              
                            }, 
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromRGBO(153, 241, 165, 1),
                                ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Claim',
                              style: TextStyle(
                                fontFamily: 'InriaSans',
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold                                             
                              ),
                            ),
                          )                  

                        ],
                      ),
                    ),
                    Container(
                      width: constraints.maxWidth/2,
                      //margin: EdgeInsets.only(bottom: 16),                      
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(190, 216, 253, 1),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10), // Circular top-left corner
                        ),
                      ),
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //const SizedBox(height: 16),
                
                          Container(
                            width: 500,
                            height: 350,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Salary Rate
                                Container(
                                  padding: EdgeInsets.all(10),
                                  width: 500,
                                  //color: Colors.yellow,
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Salary Rate:',
                                        style: TextStyle(
                                          fontFamily: 'InriaSans',
                                          fontSize: 16,
                                          color: Color.fromRGBO(115,115,115,1)
                                        )
                                      ),
                                      SizedBox(width: 50,),
                                      Text(
                                        'Php ${salaryRate.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontFamily: 'InriaSans',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(115,115,115,1)
                                        )
                                      )
                                    ],
                                  ),
                                ),
                                // No. of Days
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  width: 500,
                                  child: Text(
                                    'No. of days:',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic
                                    ),
                                  ),
                                ),
                                // Accomplished Deliveries
                                Container(
                                  //color: Colors.blue,
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  width: 500,
                                  height: 215,
                                  child: Column(
                                    children: [
                                      LayoutBuilder(
                                        builder: (context,constraints) {
                                          double width = constraints.maxWidth;
                                          return Container(                                              
                                            height: 25,
                                            decoration:BoxDecoration(
                                              border: Border(bottom: BorderSide(color: Colors.grey)),
                                              
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  //color: Colors.indigo,
                                                  alignment: Alignment.center,
                                                  width: width * 0.5,
                                                  child: Text(
                                                    'Accomplished Deliveries',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.bold,
                                                      color: Color.fromRGBO(56, 113, 193, 1)
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  //color: Colors.blue,
                                                  alignment: Alignment.center,
                                                  width: width * 0.5,
                                                  decoration: BoxDecoration(
                                                    border: Border(left: BorderSide(color: Colors.grey))
                                                  ),
                                                  child: Text(
                                                    'Days Equivalent',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.bold,
                                                      color: Color.fromRGBO(56, 113, 193, 1)
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          );
                                        }
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              //thy list creates the containers for all the trucks          
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(), // you can try to delete this
                                                itemCount: 7,
                                                itemBuilder: (context, index) {
                                                  return accomplishedList(index);
                                                },
                                              ),
                                      
                                            ],
                                          )
                                        ),
                                      ),
                                      LayoutBuilder(
                                        builder: (context,constraints) {
                                          double width = constraints.maxWidth;
                                          return Container(                                              
                                            height: 25,
                                            
                                            child: Row(
                                              children: [
                                                Container(
                                                  //color: Colors.indigo,
                                                  padding: EdgeInsets.only(right: 8),
                                                  alignment: Alignment.center,
                                                  width: width * 0.5,
                                                  child: Text(
                                                    'Total No. of Days',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.bold,
                                                      color: Color.fromRGBO(56, 113, 193, 1)
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  //color: Colors.blue,
                                                  alignment: Alignment.center,
                                                  width: width * 0.5,                                                   
                                                  child: Text(
                                                    '10',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.bold,
                                                      color: Color.fromRGBO(56, 113, 193, 1)
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          );
                                        }
                                      ),
                
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Calculated Salary:',
                                      style: TextStyle(
                                        fontFamily: 'InriaSans',
                                        fontSize: 18,
                                        color: Color.fromRGBO(115,115,115,1)
                                      )
                                    ),
                                    SizedBox(width: 50,),
                                    Text(
                                      'Php 0.00',
                                      style: TextStyle(
                                        fontFamily: 'InriaSans',
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(56, 113, 193, 1)
                                      )
                                    )
                                  ],
                                ),
                                
                              ],
                            ),
                          ),
                          const SizedBox(height:20),
                          
                          // total salary based from salary rate and no. of days
                          
                          Container(
                            width: 500,
                            height: 160,
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Deduction List
                                LayoutBuilder(
                                  builder: (context,constraints) {
                                    double width = constraints.maxWidth;
                                    return Container(                                              
                                      height: 25,
                                      decoration:BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Colors.grey)),
                                        
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            //color: Colors.indigo,
                                            alignment: Alignment.center,
                                            width: width * 0.5,
                                            child: Text(
                                              'Deductions',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(56, 113, 193, 1)
                                              ),
                                            ),
                                          ),
                                          Container(
                                            //color: Colors.blue,
                                            alignment: Alignment.center,
                                            width: width * 0.5,
                                            decoration: BoxDecoration(
                                              border: Border(left: BorderSide(color: Colors.grey))
                                            ),
                                            child: Text(
                                              'Amount',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(56, 113, 193, 1)
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    );
                                  }
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        //thy list creates the containers for all the trucks          
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(), // you can try to delete this
                                          itemCount: deductions.length,
                                          itemBuilder: (context, index) {
                                            return deductionList(deductions[index]);
                                          },
                                        ),
                                
                                      ],
                                    )
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Total Deduction:',
                                      style: TextStyle(
                                        fontFamily: 'InriaSans',
                                        fontSize: 18,
                                        color: Color.fromRGBO(115,115,115,1)
                                      )
                                    ),
                                    SizedBox(width: 50,),
                                    Text(
                                      'Php 0.00',
                                      style: TextStyle(
                                        fontFamily: 'InriaSans',
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(56, 113, 193, 1)
                                      )
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height:20),
                          ElevatedButton(
                            onPressed: (){
                              
                            }, 
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromRGBO(153, 241, 165, 1),
                                ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Compute',
                              style: TextStyle(
                                fontFamily: 'InriaSans',
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold                                             
                              ),
                            ),
                          )                  
                        ],
                      )
                    )
                  ]
                );
              }
            )
    
          )
        ]
      )
    );          
  }
}
 Widget accomplishedList(int index){
  return LayoutBuilder(
    builder: (context,constraints) {
      double width = constraints.maxWidth;
      double fontSize = width * 0.1;
      return Container(
        height: 25,
        decoration:BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))
        ),
        child: Row(
          children: [
            Container(
              width: width * 0.5,
              child: Text(
                'OR00${index + 1}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'InriaSans'
                ),
              ),
            ),
            Container(
              width: width * 0.5,
              //color: Colors.yellow,
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: Colors.grey))
              ),
              child: TextField(
                //controller: _othercontroller,
                decoration: InputDecoration(
                  //contentPadding: EdgeInsets.symmetric(vertical: 2),
                  hintText: '2',
                  hintStyle: TextStyle(fontFamily: 'InriaSans'),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center, // Center align horizontally
                textAlignVertical: TextAlignVertical.center, // Center align vertically
              ),
            )
          ],
        )
      );
    }
  );
 }

 Widget deductionList(Map<String, dynamic> deduction){
  return LayoutBuilder(
    builder: (context,constraints) {
      double width = constraints.maxWidth;
      double fontSize = width * 0.1;
      return Container(
        height: 25,
        decoration:BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))
        ),
        child: Row(
          children: [
            Container(
              width: width * 0.5,
              child: Text(
                deduction['name'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'InriaSans'
                ),
              ),
            ),
            Container(
              width: width * 0.5,
              //color: Colors.yellow,
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: Colors.grey))
              ),
              child: TextField(
                //controller: _othercontroller,
                decoration: InputDecoration(
                  //contentPadding: EdgeInsets.symmetric(vertical: 2),
                  hintText: deduction['amount'].toStringAsFixed(2),
                  hintStyle: TextStyle(fontFamily: 'InriaSans'),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center, // Center align horizontally
                textAlignVertical: TextAlignVertical.center, // Center align vertically
              ),
            )
          ],
        )
      );
    }
  );
 }

Widget oldComputeDialog(){
  return Center(
      child: Container(
        height: 600,
        width: 600,
        child: AlertDialog(
          backgroundColor:
              Colors.amberAccent.shade700,
          title: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      //Navigator.of(context).pop();
                    },
                    child: const Icon(
                        Icons.arrow_back),
                  ),
                  const SizedBox(width: 80),
                  const Text('Compute Pay Check'),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 750,
            width: 900,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.zero,
                  bottom: Radius.circular(10.0),
                ),
              ),
              child: Container(
                width: 400,
                padding: const EdgeInsets.fromLTRB(
                    20, 10, 0, 0),
                child: Stack(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          const Text(
                            'Accomplished Deliveries:',
                            style: TextStyle(
                                fontWeight:
                                    FontWeight
                                        .normal),
                          ),
                          const SizedBox(
                              height: 5.0),
                          Padding(
                            padding:
                                const EdgeInsets
                                    .all(5),
                            child: Container(
                              decoration:
                                  BoxDecoration(
                                border: Border.all(
                                    color: Colors
                                        .black),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 175,
                                    height: 35,
                                    decoration:
                                        BoxDecoration(
                                      color: Colors
                                          .grey
                                          .shade200,
                                      borderRadius: const BorderRadius
                                          .horizontal(
                                          left: Radius
                                              .circular(
                                                  1.0),
                                          right: Radius
                                              .circular(
                                                  1.0)),
                                      border: Border.all(
                                          color: Colors
                                              .black),
                                    ),
                                    child:
                                        const Padding(
                                      padding:
                                          EdgeInsets
                                              .all(
                                                  0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                        children: [
                                          Icon(
                                              Icons
                                                  .local_shipping,
                                              size:
                                                  25),
                                          SizedBox(
                                              width:
                                                  10),
                                          Text(
                                              'Delivery ID',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 175,
                                    height: 35,
                                    decoration:
                                        BoxDecoration(
                                      color: Colors
                                          .grey
                                          .shade200,
                                      borderRadius:
                                          const BorderRadius
                                              .horizontal(),
                                      border: Border.all(
                                          color: Colors
                                              .black),
                                    ),
                                    child:
                                        const Padding(
                                      padding:
                                          EdgeInsets
                                              .all(
                                                  0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                        children: [
                                          Icon(
                                              Icons
                                                  .local_shipping,
                                              size:
                                                  25),
                                          SizedBox(
                                              width:
                                                  10),
                                          Text(
                                              'Delivery ID',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 175,
                                    height: 35,
                                    decoration:
                                        BoxDecoration(
                                      color: Colors
                                          .grey
                                          .shade200,
                                      borderRadius:
                                          const BorderRadius
                                              .horizontal(),
                                      border: Border.all(
                                          color: Colors
                                              .black),
                                    ),
                                    child:
                                        const Padding(
                                      padding:
                                          EdgeInsets
                                              .all(
                                                  0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                        children: [
                                          Icon(
                                              Icons
                                                  .local_shipping,
                                              size:
                                                  25),
                                          SizedBox(
                                              width:
                                                  10),
                                          Text(
                                              'Delivery ID',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding:
                                const EdgeInsets
                                    .fromLTRB(
                                    20, 0, 20, 0),
                            child: Container(
                              width:
                                  480, // Adjust the width as neded
                              height:
                                  5, // Adjust the height as needed
                              child: Table(
                                border: TableBorder
                                    .all(),
                                children: const [
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child:
                                              Center(
                                            child:
                                                Text(
                                              'TOTAL INCOME',
                                              style:
                                                  TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child:
                                              Center(
                                            child:
                                                Text(
                                              'AMOUNT',
                                              style:
                                                  TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              'Medical Allowance'),
                                        ),
                                      ),
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              ''),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              'Rice Allowance'),
                                        ),
                                      ),
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              ''),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              'Mobile Allowance'),
                                        ),
                                      ),
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              ''),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              'Clothing Allowance'),
                                        ),
                                      ),
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              ''),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child:
                                              Center(
                                            child:
                                                Text(
                                              'TOTAL DEDUCTION',
                                              style:
                                                  TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child:
                                              Center(
                                            child:
                                                Text(
                                              'AMOUNT',
                                              style:
                                                  TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  TableRow(
                                    children: [
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              ''),
                                        ),
                                      ),
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              ''),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child:
                                              Center(
                                            child:
                                                Text(
                                              'TAX',
                                              style:
                                                  TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child:
                                              Center(
                                            child:
                                                Text(
                                              'AMOUNT',
                                              style:
                                                  TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              ''),
                                        ),
                                      ),
                                      TableCell(
                                        child:
                                            Padding(
                                          padding:
                                              EdgeInsets.all(
                                                  1.0),
                                          child: Text(
                                              ''),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Add more rows as needed
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .start,
                              children: [
                                Checkbox(
                                  value: false,
                                  onChanged: (bool?
                                      value) {
                                    // Handle checkbox change
                                  },
                                ),
                                const SizedBox(
                                    width: 10),
                                const Text(
                                  'Confirm Pay Rate',
                                  style: TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .normal),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          150, 0, 0, 0),
                      child: Expanded(
                        child:
                            SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceEvenly,
                            children: [
                              const Text(
                                'Salary:',
                                style: TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .normal),
                              ),
                              const SizedBox(
                                  height: 10.0),
                              Column(
                                children: [
                                  const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                      children: [
                                        Text(
                                          '3 Deliveries Accomplished',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                        SizedBox(
                                            height:
                                                5),
                                      ]),
                                  SizedBox(
                                      width: 80),
                                  const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                      children: [
                                        Text(
                                          '1 Cebu Trip',
                                        ),
                                        SizedBox(
                                            width:
                                                15),
                                        Text(
                                            'Php 800.00')
                                      ]),
                                  SizedBox(
                                      width: 80),
                                  const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                      children: [
                                        Text(
                                          '2 Out-Cebu Trip',
                                        ),
                                        SizedBox(
                                            width:
                                                10),
                                        Text(
                                            'Php 1200')
                                      ]),
                                  const SizedBox(
                                      height: 10),
                                  Column(children: [
                                    Container(
                                      width: 175,
                                      height: 35,
                                      decoration:
                                          BoxDecoration(
                                        color: Colors
                                            .grey
                                            .shade200,
                                        borderRadius: const BorderRadius
                                            .horizontal(
                                            left: Radius.circular(
                                                1.0),
                                            right: Radius.circular(
                                                1.0)),
                                      ),
                                      child:
                                          const Padding(
                                        padding:
                                            EdgeInsets
                                                .all(0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                          children: [
                                            Text(
                                                'Php 2,000.00'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ], //children
                ),
              ),
            ),
          ),
        ),
      ),
    );                
}