
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/newUI/components/dialogs/computeDialog.dart';
import 'package:haul_a_day_web/newUI/components/dialogs/setpayrate.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:haul_a_day_web/service/payrollService.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class Payroll extends StatefulWidget {
  final Map<int, List<Map<String, dynamic>>> groupedOrders;
  const Payroll({super.key, required this.groupedOrders});

  @override
  State<Payroll> createState() => _PayrollState();
}

class _PayrollState extends State<Payroll> {
  List<Map<String, dynamic>> _staffs = [];
  Map<String, dynamic> selectedStaff = {};
  Map<String,dynamic> _rates = {};
  bool selectaStaff = false;
  double totalSalary = 0;
  List<String> _loadingDateRanges = [];
  String? dateRange;

  @override
  void initState() {
    super.initState();
    _initializeStaffData();
    getLoadingDateRanges(widget.groupedOrders);
  }

  Future<void> _initializeStaffData() async {
    try {
      DatabaseService databaseService = DatabaseService();
      PayrollService payrollService = PayrollService();
      List<Map<String, dynamic>> staffs = await databaseService.fetchOPStaffList();
      Map<String, dynamic> rates = await payrollService.getPayRate();
      setState(() {
        _staffs = staffs;
        _rates = rates;
      });
      print(_rates);
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
  

  Future<String> generateAndSavePDF() async {
  final pdf = pdfLib.Document();

  // Add content to the PDF document
  pdf.addPage(
    pdfLib.Page(
      build: (pdfLib.Context context) {
        return pdfLib.Center(
          child: pdfLib.Text('Hello World'),
        );
      },
    ),
  );

  // Get the document directory using path_provider package
  final directory = await getApplicationDocumentsDirectory();
  final String dirPath = directory.path;

  // Construct the file path
  final String filePath = path.join(dirPath, 'example.pdf');

  // Save the PDF document to the document directory
  final File file = File(filePath);
  await file.writeAsBytes(await pdf.save());

  // Print the file path for debugging
  print('PDF saved at: $filePath');

  // Return the file path
  return filePath;
}

  void getLoadingDateRanges(Map<int, List<Map<String, dynamic>>> groupedOrders) {
    List<String> loadingDateRanges = [];

    groupedOrders.forEach((key, orders) {
      int year = key ~/ 10000;
      int month = (key % 10000) ~/ 100;
      int week = key % 100;

      // Find the minimum and maximum loading dates for the current week
      DateTime minDate = DateTime(year, month, 1); // Initialize minDate to the first day of the month
      DateTime maxDate = DateTime(year, month + 1, 0); // Initialize maxDate to the last day of the month

      orders.forEach((order) {
        DateTime loadingDate = DateFormat('MMM dd, yyyy').parse(order['loadingDate']);
        if (loadingDate.isBefore(minDate)) {
          minDate = loadingDate;
        }
        if (loadingDate.isAfter(maxDate)) {
          maxDate = loadingDate;
        }
      });

      // Format the minimum and maximum dates into the desired string format
      String range = 'From ${DateFormat('MMMM dd').format(minDate)} to ${DateFormat('MMMM dd').format(maxDate)} $year';
      loadingDateRanges.add(range);
    });

    setState(() {
      _loadingDateRanges = loadingDateRanges;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          // If a staff is selected, right panel will appear
          if(selectaStaff == true && selectaStaff){
            return Row(
            children: [
              // Left side
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Payroll',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontFamily: 'Itim',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          const Spacer(),

                          //Search Bar
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                  fillColor: const Color.fromRGBO(
                                      199, 196, 196, 0.463),
                                  filled: true,
                                  hintText: "Search Staff",
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  suffixIcon: InkWell(
                                      onTap: () {},
                                      child: const Icon(
                                        Icons.search,
                                        color: Colors.black,
                                      ))),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                      //const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 2, 0, 0),
                        child: Row(
                          children: [
                            const Text(
                              'Week: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  // Add truck functionality here
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(2),
                                      right: Radius.circular(2),
                                    ),
                                  ),
                                  backgroundColor: Colors.grey[
                                      300], // Background color of the button
                                  elevation: 0,
                                ),
                                child: DropdownButton<String>(
                                  value:
                                      'From March 4 to March 9 2024', // Initially selected value
                                  onChanged: (String? newValue) {
                                    // Handle dropdown value change here
                                  },
                                  underline: Container(),
                                  items: <String>[
                                    'From March 4 to March 9 2024', // You can add more items here
                                    // Add more dropdown items here
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      contentPadding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      content: RateDialog()
                                    );
                                  },
                                );
                              }, 
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(2),
                                    right: Radius.circular(2),
                                  ),
                                ),
                                backgroundColor: Colors.grey[
                                    300], // Background color of the button
                                elevation: 0,
                              ),
                              child: const Text(
                                'Update Payrate',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                          height: size.height * 0.68,
                          child: _staffs.isEmpty
                              ? Container(
                                  alignment: Alignment.center,
                                  child: const CircularProgressIndicator())
                              : Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: SingleChildScrollView(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        //thy list creates the containers for all the trucks
                                        GridView.builder(
                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            mainAxisSpacing: 8,
                                            crossAxisSpacing: 8,
                                          ),
                                          shrinkWrap: true, // Add this line
                                          physics: const NeverScrollableScrollPhysics(), // Add this line if needed
                                          itemCount: _staffs.length,
                                          itemBuilder: (context, index) {
                                            return buildStaffContainer(
                                              _staffs[index]);
                                          },
                                        ),
                                        // ListView.builder(
                                        //   shrinkWrap: true,
                                        //   physics:
                                        //       const NeverScrollableScrollPhysics(), // you can try to delete this
                                        //   itemCount: _staffs.length,
                                        //   itemBuilder: (context, index) {
                                        //     return buildStaffContainer(
                                        //         _staffs[index]);
                                        //   },
                                        // ),
                                      ],
                                    )),
                                  ),
                                )),
                      //const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              // Right panel for Truck
              Expanded(
                  flex: 3,
                  child: selectaStaff == true
                      ? Container(
                          height: size.height * 0.87,
                          color: Colors.green.shade50,
                          child: staffPanel(selectedStaff))
                      : Container(
                          height: size.height * 0.87,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 50),
                          child: unselectedRightPanel())),
            ],
          );
        
          }
          // if no staff is selected, right panel is hidden
          return Container(
                height: size.height -500,
                
                //flex: 6,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50, 16, 50, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Payroll',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontFamily: 'Itim',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          const Spacer(),

                          //Search Bar
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                  fillColor: const Color.fromRGBO(
                                      199, 196, 196, 0.463),
                                  filled: true,
                                  hintText: "Search Staff",
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  suffixIcon: InkWell(
                                      onTap: () {},
                                      child: const Icon(
                                        Icons.search,
                                        color: Colors.black,
                                      ))),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                      //const SizedBox(height: 10,),
                      _staffs.isEmpty && widget.groupedOrders.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            height: size.height - 300,
                            
                            child: const CircularProgressIndicator())
                            //:Container()
                        : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(25, 2, 0, 0),
                              child: Row(
                                children: [
                                  const Text(
                                    'Week: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        // Add truck functionality here
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.horizontal(
                                            left: Radius.circular(2),
                                            right: Radius.circular(2),
                                          ),
                                        ),
                                        // backgroundColor: Colors.grey[
                                        //     300], // Background color of the button
                                        elevation: 0,
                                      ),
                                      child: DropdownButton<String>(
                                        value:
                                            dateRange, // Initially selected value
                                        onChanged: (String? newValue) {
                                          dateRange = newValue;
                                        },
                                        underline: Container(),
                                        items: _loadingDateRanges.map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      )),
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            contentPadding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                            content: RateDialog()
                                          );
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(2),
                                          right: Radius.circular(2),
                                        ),
                                      ),
                                      backgroundColor: Colors.grey[
                                          300], // Background color of the button
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      'Update Payrate',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                        height: size.height * 0.68,
                        child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: SingleChildScrollView(
                                  child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                children: [
                                  //thy list creates the containers for all the trucks
                                  GridView.builder(
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      mainAxisSpacing: 15,
                                      crossAxisSpacing: 15,
                                    ),
                                    shrinkWrap: true, // Add this line
                                    physics: const NeverScrollableScrollPhysics(), // Add this line if needed
                                    itemCount: _staffs.length,
                                    itemBuilder: (context, index) {
                                      return buildStaffContainer(
                                         _staffs[index]);
                                    },
                                  ),
                                  // ListView.builder(
                                  //   shrinkWrap: true,
                                  //   physics:
                                  //       const NeverScrollableScrollPhysics(), // you can try to delete this
                                  //   itemCount: _staffs.length,
                                  //   itemBuilder: (context, index) {
                                  //     return buildStaffContainer(
                                  //         _staffs[index]);
                                  //   },
                                  // ),
                                ],
                              )
                            ),
                          ),
                        )
                      ),
                      //const SizedBox(height: 20),
                          ],
                        )
                    ],
                  ),
                ),
              );
              // Right panel for Truck;
        
        }),
      );           
  }

  //for the list
  Widget buildStaffContainer(Map<String, dynamic> aStaff){
    return InkWell(
      onTap: (){
        setState(() {
          if(selectaStaff == false){
            selectedStaff = aStaff;
            selectaStaff = true;
          }
          else if(selectaStaff == true && selectedStaff == aStaff){
            selectedStaff = {};
            selectaStaff = false;
          } else if(selectaStaff == true && selectedStaff != aStaff){
            selectaStaff = false;
            selectedStaff = aStaff;
            selectaStaff = true;
          }
        });
      },
      child: Container(
        width: 500,
        margin: const EdgeInsets.fromLTRB(
            40, 10, 40, 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Colors.black),
          borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          children: [
            //truckPicture
            CircleAvatar(
              radius: 50,
              backgroundColor:
              Colors.white,
              backgroundImage: aStaff['pictureUrl'] != null
                ? NetworkImage(aStaff['pictureUrl'])
                : Image.asset('images/user_pic.png').image,
            ),
            const Spacer(),
            Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  '${aStaff['firstname']} ${aStaff['lastname']}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Colors.black),
                ),
                Text(
                  'Staff ID: ${aStaff['staffId']}',
                  style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Colors.black),
                ),
                Text(
                  'Position: ${aStaff['position']}',
                  style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Colors.black),
                ),
              ],
            ),
            const Spacer(),
            const Column(
                crossAxisAlignment:
                CrossAxisAlignment.end,
                children: [
                  Text(
                    'Not Claimed',
                    style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        color:
                            Colors.green,
                        fontSize: 20
                        ),
                  ),
                  SizedBox(height: 2),
                  
                ]),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
  // unselected Right Panel
  Widget unselectedRightPanel(){
    return Expanded(
      child: Container(                              
        //height: 450,                              
        //margin: const EdgeInsets.fromLTRB(20, 50, 20, 20),
        //padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
        color: Colors.yellow[100],
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.money,
                size: 50, color: Colors.black),
            SizedBox(height: 10),
            Text(
              'Select an Employee\nto view payslip',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _deliveries = [];

  void getAccomplishedDelivery(String staffId)async{
    PayrollService payrollService = new PayrollService();
    List<String> deliveries = await payrollService.accomplishedDeliveries(staffId);
    //print('Accomplished Deliveries: $deliveries');
    setState(() {
      _deliveries = deliveries;
    });

  }
  // selected staff right panel
  Widget staffPanel(Map<String, dynamic> aStaff) {
    DateTime now = DateTime.now();
    String dateToday = DateFormat('MMMM dd, yyyy').format(now);
    Size size = MediaQuery.of(context).size;
    //getAccomplishedDelivery(aStaff['staffId']);
    return Container(
      width: size.width * 0.5,
      color: const Color(0xFFFF95E),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back,
                    size: 35, color: Colors.black),
                onPressed: () {
                  setState(() {
                    if (selectaStaff == false) {
                      selectedStaff = aStaff;
                      selectaStaff = true;
                    } else if (selectaStaff == true) {
                      selectedStaff = {};
                      selectaStaff = false;
                    }
                  });
                },
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Divider(color: Colors.orange),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(
                  'Pay Slip',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 32,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Itim"
                  ),
                ),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Divider(color: Colors.orange),
                ),
              ),
              // Add other widgets to the app bar as needed
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical:30),
            height: size.height *0.8,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: 400,
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      // Wrap the SizedBox and Row inside a Column
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10), // Move SizedBox inside the Column
                        Container(
                          width: 400,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                backgroundImage: aStaff['pictureUrl'] != null
                                    ? NetworkImage(aStaff['pictureUrl'])
                                    : Image.asset('images/user_pic.png').image,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${aStaff['firstname']} ${aStaff['lastname']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                dateToday,
                                style: const TextStyle(
                                  color: Color(0xFF737373),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                            height: 25), // Moved from inside child to inside Column
                        Text(
                          'PHP ${totalSalary.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFF737373),
                            fontSize: 26,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Container(
                  //   width: 400,
                  //   height: 80,
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.black),
                  //     borderRadius: BorderRadius.circular(10)
                  //   ),
                  // ),
                  // const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, ),
                    width: 400, // Set width as per your requirement
                    height: 380, // Set height as per your requirement
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 255, 255, 255), // Set the color of the container
                      borderRadius:
                          BorderRadius.circular(10), // Set the radius of the corners
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 4, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Breakdown:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        contentPadding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        content: ComputeDialog(staff: aStaff)
                                      );
                                    },
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                      const Color(0xFF2A9530)),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(Colors.white),
                                ),
                                child: const Text('Compute'),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Income',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold                            
                                    ),
                                  ),
                                  Text(
                                    'Php 0.00',
                                    style: TextStyle(
                                      color: Color.fromRGBO(115, 115, 115, 1),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'SALARY',
                                    style: TextStyle(
                                      color: Color(0xFF737373),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Php 3,000',
                                    style: TextStyle(
                                      color: Color(0xFF737373),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'NO. OF DAYS',
                                    style: TextStyle(
                                      color: Color(0xFF737373),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '11',
                                    style: TextStyle(
                                      color: Color(0xFF737373),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              
                              SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: Divider(color: Colors.black),
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Deduction',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    'Php 0.00',
                                    style: TextStyle(
                                      color: Color.fromRGBO(115, 115, 115, 1),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'SSS',
                                    style: TextStyle(
                                      color: Color(0xFF737373),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Php 3000',
                                    style: TextStyle(
                                      color: Color(0xFF737373),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'PhilHealth',
                                    style: TextStyle(
                                      color: Color(0xFF737373),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Php 3000',
                                    style: TextStyle(
                                      color: Color(0xFF737373),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Pag-ibig',
                                    style: TextStyle(
                                      color: Color(0xFF737373),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Php 3000',
                                    style: TextStyle(
                                      color: Color(0xFF737373),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: Divider(color: Colors.black),
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Net Salary',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    'Php 0.00',
                                    style: TextStyle(
                                      color: Color.fromRGBO(115, 115, 115, 1),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Add truck functionality here
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(2),
                                right: Radius.circular(2),
                              ),
                            ),
                            backgroundColor:
                                Colors.grey[300], // Background color of the button
                            elevation: 0,
                          ),
                          child: const Text(
                            'CLAIM',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 30),
                        ElevatedButton(
                          onPressed: () async {
                            // // Generate and save the PDF
                            // final String pdfPath = await generateAndSavePDF();
                  
                            // // Open the generated PDF using the default PDF viewer
                            // OpenFile.open(pdfPath);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(2),
                                right: Radius.circular(2),
                              ),
                            ),
                            backgroundColor:
                                const Color(0xFF2A9530), // Background color of the button
                            elevation: 0,
                          ),
                          child: const Text(
                            'PRINT',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Widget setPayRate(Map<String,dynamic> _rates){

  //   return Center(
  //     child: Container(
  //       height: 600,
  //       width: 530,
  //       child: AlertDialog(
  //         backgroundColor:
  //             Colors.amberAccent.shade700,
  //         title: Column(
  //           children: [
  //             Row(
  //               children: [
  //                 GestureDetector(
  //                   onTap: () {
  //                     Navigator.of(context)
  //                         .pop();
  //                   },
  //                   child: const Icon(
  //                       Icons.arrow_back),
  //                 ),
  //                 const SizedBox(width: 80),
  //                 const Text('Pay Rate'),
  //               ],
  //             ),
  //             const SizedBox(height: 20),
  //           ],
  //         ),
  //         contentPadding: EdgeInsets.zero,
  //         content: Container(
  //           height: 300,
  //           width: 900,
  //           child: DecoratedBox(
  //             decoration: const BoxDecoration(
  //               color: Colors.white,
  //               borderRadius:
  //                   BorderRadius.vertical(
  //                 top: Radius.zero,
  //                 bottom: Radius.circular(10.0),
  //               ),
  //             ),
  //             child: Container(
  //               padding: const EdgeInsets.all(20.0),
  //               child: Row(
  //                 children: [
  //                   Expanded(
  //                   child: Column(
  //                     crossAxisAlignment:
  //                         CrossAxisAlignment
  //                             .start,
  //                     children: [
  //                       const Text(
  //                         'Staff Rate:',
  //                         style: TextStyle(
  //                             fontWeight:
  //                                 FontWeight
  //                                     .normal),
  //                       ),
  //                       const SizedBox(
  //                           height: 10.0),
  //                       Row(
  //                         children: [
  //                           const SizedBox(
  //                               width: 20),
  //                           const Text(
  //                               'Driver:',
  //                               style: TextStyle(
  //                                   fontWeight:
  //                                       FontWeight
  //                                           .normal)),
  //                           const SizedBox(
  //                               width: 10),
  //                           Container(
  //                             height: 25,
  //                             width: 200,
  //                             child: TextField(
  //                               decoration:
  //                                   InputDecoration(
  //                                 filled: true,
  //                                 fillColor:
  //                                     Colors.grey[
  //                                         200],
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       const SizedBox(
  //                           height: 10),
  //                       Row(
  //                         children: [
  //                           const SizedBox(
  //                               width: 20),
  //                           const Text(
  //                               'Helper:',
  //                               style: TextStyle(
  //                                   fontWeight:
  //                                       FontWeight
  //                                           .normal)),
  //                           const SizedBox(
  //                               width: 10),
  //                           Container(
  //                             height: 25,
  //                             width: 200,
  //                             child: TextField(
  //                               decoration:
  //                                   InputDecoration(
  //                                 filled: true,
  //                                 fillColor:
  //                                     Colors.grey[
  //                                         200],
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       const SizedBox(
  //                           height: 10),
  //                       const Text(
  //                         'Trip Rate:',
  //                         style: TextStyle(
  //                             fontWeight:
  //                                 FontWeight
  //                                     .normal),
  //                       ),
  //                       const SizedBox(
  //                           height: 10.0),
  //                           Row(
  //                         children: [
  //                           const SizedBox(
  //                               width: 20),
  //                           const Text('Loading:',
  //                               style: TextStyle(
  //                                   fontWeight:
  //                                       FontWeight
  //                                           .normal)),
  //                           const SizedBox(
  //                               width: 10),
  //                           Container(
  //                             height: 25,
  //                             width: 200,
  //                             child: TextField(
  //                               decoration:
  //                                   InputDecoration(
  //                                 filled: true,
  //                                 fillColor:
  //                                     Colors.grey[
  //                                         200],
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       const SizedBox(
  //                           height: 10),
  //                       Row(
  //                         children: [
  //                           const SizedBox(
  //                               width: 20),
  //                           const Text('Cebu:',
  //                               style: TextStyle(
  //                                   fontWeight:
  //                                       FontWeight
  //                                           .normal)),
  //                           const SizedBox(
  //                               width: 10),
  //                           Container(
  //                             height: 25,
  //                             width: 200,
  //                             child: TextField(
  //                               decoration:
  //                                   InputDecoration(
  //                                 filled: true,
  //                                 fillColor:
  //                                     Colors.grey[
  //                                         200],
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       const SizedBox(
  //                           height: 10),
  //                       Row(
  //                         children: [
  //                           const SizedBox(
  //                               width: 20),
  //                           const Text(
  //                               'Others:',
  //                               style: TextStyle(
  //                                   fontWeight:
  //                                       FontWeight
  //                                           .normal)),
  //                           const SizedBox(
  //                               width: 10),
  //                           Container(
  //                             height: 25,
  //                             width: 200,
  //                             child: TextField(
  //                               decoration:
  //                                   InputDecoration(
  //                                 filled: true,
  //                                 fillColor:
  //                                     Colors.grey[
  //                                         200],
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       Expanded(
  //                         child: Row(
  //                           mainAxisAlignment:
  //                               MainAxisAlignment
  //                                   .start,
  //                           children: [
  //                             Checkbox(
  //                               value: false,
  //                               onChanged:
  //                                   (bool?
  //                                       value) {
  //                                 // Handle checkbox change
  //                               },
  //                             ),
  //                             const SizedBox(
  //                                 width: 10),
  //                             const Text(
  //                               'Confirm Pay Rate',
  //                               style: TextStyle(
  //                                   fontWeight:
  //                                       FontWeight
  //                                           .normal),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                   const VerticalDivider(),
  //                   Column(
  //                     children: [
  //                       const SizedBox(width: 20),
  //                       const Text(
  //                     'Recorded Rate:',
  //                     style: TextStyle(
  //                         fontSize: 12,
  //                         fontWeight: FontWeight
  //                             .normal),
  //                   ),   
  //                       const SizedBox(height: 10),
  //                       Text(
  //                     "Php ${_rates['driverRate'].toStringAsFixed(2)}",
  //                     style: const TextStyle(
  //                         fontWeight: FontWeight
  //                             .normal),
  //                   ),
  //                       const SizedBox(height: 10),
  //                       Text(
  //                     "Php ${_rates['helperRate'].toStringAsFixed(2)}",
  //                     style: const TextStyle(
  //                         fontWeight: FontWeight
  //                             .normal),
  //                   ),
  //                       const SizedBox(height: 65),
  //                       Row(
  //                     crossAxisAlignment:
  //                         CrossAxisAlignment
  //                             .start,
  //                     children: [
  //                       const SizedBox(width: 20),
  //                       RichText(
  //                         text: TextSpan(
  //                           text: _rates['loadingRate'].toString(),
  //                           style: const TextStyle(
  //                               fontWeight:
  //                                   FontWeight
  //                                       .normal,
  //                               fontSize: 16),
  //                           children: const <TextSpan>[
  //                             TextSpan(
  //                               text:
  //                                   ' day salary',
  //                               style: TextStyle(
  //                                   fontSize:
  //                                       12,
  //                                   fontWeight:
  //                                       FontWeight
  //                                           .normal),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                       const SizedBox(height: 10),
  //                       Row(
  //                         crossAxisAlignment:
  //                             CrossAxisAlignment
  //                                 .start,
  //                         children: [
  //                           const SizedBox(width: 20),
  //                           RichText(
  //                             text: TextSpan(
  //                               text: _rates['cebuRate'].toString(),
  //                               style: const TextStyle(
  //                                   fontWeight:
  //                                       FontWeight
  //                                           .normal,
  //                                   fontSize: 16),
  //                               children: const <TextSpan>[
  //                                 TextSpan(
  //                                   text:
  //                                       ' day salary',
  //                                   style: TextStyle(
  //                                       fontSize:
  //                                           12,
  //                                       fontWeight:
  //                                           FontWeight
  //                                               .normal),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       const SizedBox(height: 10),
  //                       Row(
  //                     crossAxisAlignment:
  //                         CrossAxisAlignment
  //                             .start,
  //                     children: [
  //                       const SizedBox(width: 20),
  //                       RichText(
  //                         text: TextSpan(
  //                           text: _rates['noncebuRate'].toString(),
  //                           style: const TextStyle(
  //                               fontWeight:
  //                                   FontWeight
  //                                       .normal,
  //                               fontSize: 16),
  //                           children: const <TextSpan>[
  //                             TextSpan(
  //                               text:
  //                                   ' day salary',
  //                               style: TextStyle(
  //                                   fontSize:
  //                                       12,
  //                                   fontWeight:
  //                                       FontWeight
  //                                           .normal),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                           height: 10),
  //                     ],
  //                   ),
  //                     ]
  //                   )
  //                 ]
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  
  }

