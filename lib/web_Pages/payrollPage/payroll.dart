
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:haul_a_day_web/service/payrollService.dart';
import 'package:haul_a_day_web/web_Pages/payrollPage/claimDialog.dart';
import 'package:haul_a_day_web/web_Pages/payrollPage/computeDialog.dart';
import 'package:haul_a_day_web/web_Pages/payrollPage/generatePdf.dart';
import 'package:haul_a_day_web/web_Pages/payrollPage/setpayrate.dart';
import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/widgets.dart' as pdfLib;
// import 'package:pdf/pdf.dart';
import 'dart:typed_data' as html;
import 'dart:html' as html;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class Payroll extends StatefulWidget {
  const Payroll({super.key,});

  @override
  State<Payroll> createState() => _PayrollState();
}

class _PayrollState extends State<Payroll> {
  PayrollService payrollService = PayrollService();
  List<Map<String, dynamic>> allstaffs = [];
  List<Map<String, dynamic>> _staffs = [];
  Map<String, dynamic> selectedStaff = {};
  Map<String,dynamic> _rates = {};
  bool selectaStaff = false;
  double totalSalary = 0;

  String _selectedSortBy = 'Staff ID'; // Default sorting option
  String searchQuery = '';
  TextEditingController _searchcontroller = TextEditingController();
  bool notExist = false;
  bool? isCheck = false;
  bool stillFetching = true;

  int driverRate = 0;
  int helperRate = 0;
  int loadingRate = 0;
  int cebuRate = 0;
  int otherRate = 0;

  double netSalary=0;
  double salary=0;
  double numDays=0;
  double salaryRate=0;
  double totalDeduct =0;
  double SSS =0;
  double PhilHealth=0;
  double Pag_ibig=0;

  int year = 0;
  int month = 0;
  int week = 0;

  @override
  void initState() {
    super.initState();
    _initializeStaffData();
    _initializeCurrentWeek();
  }

  Future<void> _initializeStaffData() async {
    try {
      DatabaseService databaseService = DatabaseService();
      //List<Map<String, dynamic>> staffs = await databaseService.fetchOPStaffList();
      Map<String, dynamic> rates = await payrollService.getPayRate();
      // List<Map<String, dynamic>> accomplished = await payrollService.fetchAccomplished();
      // print(accomplished);
      setState(() {
        //_staffs = staffs;
        _rates = rates;
        driverRate = _rates['driverRate'];
        helperRate = _rates['helperRate'];
        loadingRate = _rates['loadingRate'];
        cebuRate = _rates['cebuRate'];
        otherRate = _rates['noncebuRate'];
      });
      //print(_rates);
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
  

  Future<String?> generateAndSavePDF() async {
  try {
    final pdf = pw.Document();
    
     // Draw the container widget to the PDF document
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Container(
            width: 200,
            height: 200,
            color: PdfColor.fromHex('#FF5733'), // Example color
          ),
        ),
      ),
    );

    // Save the PDF document to a Uint8List
    final pdfBytes = pdf.save();

    // Provide the PDF as a download
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'document.pdf')
      ..click();

    //Open
    html.window.open(url, '_blank');

    // Clean up
    html.Url.revokeObjectUrl(url);

    // Return the URL where the PDF can be downloaded from
    return url;
  } catch (e) {
    print('Error generating PDF: $e');
    // Handle the error as needed
    return null;
  }
}


  DateTime? _startOfWeek;
  DateTime? _endOfWeek;

  void _initializeCurrentWeek()async {
    DateTime today = DateTime.now();
    _startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    _endOfWeek = _startOfWeek!.add(Duration(days: 6));

    String date = DateFormat('MMM dd, yyyy').format(today);
    int tempweek = await payrollService.getWeekNumber(date);
      
    setState(() {
      year = today.year;
      month = today.month;
      week = tempweek % 4;
    });

    List<Map<String, dynamic>> accomplished = await payrollService.weekPayroll(year, month, week);
    print(accomplished);
    setState(() {
      _staffs = accomplished;
      allstaffs = _staffs;
      stillFetching = false;
    });
  }


  Future<void> _pickDate() async {
    setState(() {
      stillFetching = true;
    });

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      String date = DateFormat('MMM dd, yyyy').format(selectedDate);
      int tempweek = await payrollService.getWeekNumber(date);
      
      setState(() {
        _startOfWeek = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
        _endOfWeek = _startOfWeek!.add(Duration(days: 6));
        year = selectedDate.year;
        month = selectedDate.month;
        week = tempweek % 4;
        
        //stillFetching = false;
      });
      print('Week: $week');

      List<Map<String, dynamic>> accomplished = await payrollService.weekPayroll(year, month, week);
      print(accomplished);
      setState(() {
        _staffs = accomplished;
        allstaffs = _staffs;
        stillFetching = false;
      });
    }    
  }

  void sortList(List<Map<String, dynamic>> list, String sortBy) {
    print('here');
    // Comparator function to compare two maps based on the specified key
    if (sortBy == 'Name'){
      sortBy = 'firstname';
    }else if (sortBy == 'Staff ID'){
      sortBy = 'staffId';
    }else if(sortBy == 'Position'){
      sortBy = 'position';
    }else if(sortBy == 'Claimed Status'){
      sortBy = 'ClaimedStatus';
    }
    int compare(Map<String, dynamic> a, Map<String, dynamic> b) {
      // Access the values of the specified key from each map
      var aValue = a[sortBy];
      var bValue = b[sortBy];

      // Compare the values and return the result
      if (aValue is String && bValue is String) {
        // For string comparison
        return aValue.compareTo(bValue);
      } else if (aValue is int && bValue is int) {
        // For integer comparison
        return aValue.compareTo(bValue);
      } else {
        // Handle other types if needed
        return 0;
      }
    }
    // Sort the list using the comparator function
    list.sort(compare);
    //print('Sorted list: $list');
    setState(() {
      _staffs = list;
    });
  }

  void searchStaff(List<Map<String, dynamic>> originalList, String searchQuery) {
    List<Map<String, dynamic>> filteredList = [];
    if(searchQuery != ''){
      // Convert the search query to lowercase for case-insensitive matching
      final query = searchQuery.toLowerCase();

      // Filter the original list based on the search query
      filteredList = originalList.where((map) {
        // Iterate through each key-value pair in the map
        // and check if any value contains the search query
        return map.values.any((value) {
          if (value is String) {
            // If the value is a string, check if it contains the search query
            return value.toLowerCase().contains(query);
          }
          // If the value is not a string, convert it to a string and check if it contains the search query
          return value.toString().toLowerCase().contains(query);
        });
      }).toList();
      print("Searched List: $filteredList");
      
    }

    if(filteredList.isEmpty){
      setState(() {
        notExist = true;
      });
    }
    else{
      setState(() {
        _staffs = filteredList;
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if(selectaStaff == false){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical:10),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          
                          child: const Text(
                            'Payroll',
                            style: TextStyle(
                              fontFamily: 'Itim',
                              fontSize: 36
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: LayoutBuilder(
                    builder: (context,constraints) {
                      double width = constraints.maxWidth;
                      double height = constraints.maxHeight;
                      //print('$width , $height');
                      return 
                      // _staffs.isEmpty && stillFetching == true ? const Center(child: CircularProgressIndicator(),)
                      // : 
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              //color: Colors.blue,
                              width: width * 0.9,
                              color: Color.fromARGB(109, 223, 222, 222),
                              padding: selectaStaff == true ? const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
                              :const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                              child:Container(
                                  height: 800,
                                  //padding: EdgeInsets.all(16),
                                  // : Color.fromARGB(109, 223, 222, 222),
                                  child: LayoutBuilder(
                                    builder: (context,constraints) {
                                      double width = constraints.maxWidth;
                                      double height = constraints.maxHeight;
                                      return Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          //Filter Container
                                          Expanded(
                                            flex: 2,
                                            child: LayoutBuilder(
                                                builder: (context,constraints) {
                                                  double width = constraints.maxWidth;
                                                  double height = constraints.maxHeight;
                                                  return Column(
                                                    children: [
                                                      Container(
                                                        height: height*0.38,
                                                        decoration: BoxDecoration(
                                                          color: Color.fromARGB(109, 223, 222, 222),
                                                          border: Border.all(color: Colors.green)
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              width: width,
                                                              color: Color.fromARGB(255, 87, 189, 90),
                                                              padding: EdgeInsets.all(8.0),
                                                              child: Text('Filters',
                                                                style: TextStyle(
                                                                  color:Colors.white,
                                                                  fontFamily: 'Inter',
                                                                  fontSize: 22,
                                                                  fontWeight: FontWeight.bold
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.all(10),
                                                              color: Colors.white,
                                                              width: width,
                                                              height: height *0.26,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  const Text(
                                                                    'Filter list by:',
                                                                    style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontStyle: FontStyle.italic,
                                                                      color: Colors.grey
                                                                    )
                                                                  ),
                                                                  
                                                                  
                                                                  SizedBox(height: 20),
                                                                  if (_startOfWeek != null && _endOfWeek != null) ...[
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('From:'),
                                                                        Text(DateFormat('MMM dd, yyyy').format(_startOfWeek!))
                                                                      ]
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('To:'),
                                                                        Text(DateFormat('MMM dd, yyyy').format(_endOfWeek!))
                                                                      ]
                                                                    ),
                                                                    const Spacer(),
                                                                    const SizedBox(height: 10),
                                                                    const Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('Pick a Week'),
                                                                        //SizedBox(width: 15),
                                                                        
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ],
                                                              ),
                                                            ),                                                    
                                                            Container(
                                                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                                              height: height *0.055,
                                                              width: width,
                                                              color: Color.fromRGBO(251, 250, 239, 0.782),
                                                              child: ElevatedButton(
                                                                onPressed: _pickDate,
                                                                style: ButtonStyle(
                                                                  backgroundColor: MaterialStateProperty.all<Color>(
                                                                      Color.fromARGB(220, 92, 201, 95)
                                                                    ),
                                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                    ),
                                                                  ),
                                                                ),
                                                                child: const Text(
                                                                  'Week',
                                                                  style: TextStyle(
                                                                    fontFamily: 'InriaSans',
                                                                    fontSize: 16,
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.bold                                             
                                                                  ),
                                                                ),
                                                              )                  ,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(height:16),
                                                      Container(
                                                        height: height*0.38,
                                                        decoration: BoxDecoration(
                                                          color: Color.fromARGB(109, 223, 222, 222),
                                                          border: Border.all(color: Colors.green)
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              width: width,
                                                              color: Color.fromARGB(255, 87, 189, 90),
                                                              padding: EdgeInsets.all(8.0),
                                                              child: Text('Pay Rate',
                                                                style: TextStyle(
                                                                  color:Colors.white,
                                                                  fontFamily: 'Inter',
                                                                  fontSize: 22,
                                                                  fontWeight: FontWeight.bold
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.all(10),
                                                              color: Colors.white,
                                                              width: width,
                                                              height: height *0.26,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  const Text(
                                                                    'Recorded Pay Rate:',
                                                                    style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontStyle: FontStyle.italic,
                                                                      color: Colors.grey
                                                                    )
                                                                  ),
                                                                  const SizedBox(height: 10),
                                                                  Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('Driver Rate:'),
                                                                        Text('Php ${driverRate.toStringAsFixed(2)}')
                                                                      ]
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('Helper Rate:'),
                                                                        Text('Php ${helperRate.toStringAsFixed(2)}')
                                                                      ]
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('Loading Trip Rate:'),
                                                                        Text('${loadingRate.toString()} days')
                                                                      ]
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('Cebu Trip Rate:'),
                                                                        Text('${cebuRate.toString()} days')
                                                                      ]
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('Other Trips Rate:'),
                                                                        Text('${otherRate.toString()} days')
                                                                      ]
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                ],
                                                              ),
                                                            ),                                                    
                                                            Container(
                                                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                                              height: height *0.055,
                                                              width: width,
                                                              color: Color.fromRGBO(251, 250, 239, 0.782),
                                                              child: ElevatedButton(
                                                                onPressed: ()async{
                                                                  Map<String, dynamic>? rates = await showDialog<Map<String, dynamic>>(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                      return AlertDialog(
                                                                        contentPadding: EdgeInsets.zero,
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(15.0),
                                                                        ),
                                                                        content: RateDialog(
                                                                          newrates: (value) {
                                                                            Navigator.of(context).pop(value); // Close the dialog and return the assigned value
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                  );

                                                                  if(rates != null){
                                                                    setState(() {
                                                                      driverRate = rates['driverRate'];
                                                                      helperRate = rates['helperRate'];
                                                                      loadingRate = rates['loadingRate'];
                                                                      cebuRate = rates['cebuRate'];
                                                                      otherRate = rates['otherRate'];
                                                                    });
                                                                  }
                                                                }, 
                                                                style: ButtonStyle(
                                                                  backgroundColor: MaterialStateProperty.all<Color>(
                                                                      Color.fromARGB(220, 92, 201, 95)
                                                                    ),
                                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                    ),
                                                                  ),
                                                                ),
                                                                child: const Text(
                                                                  'Update Pay Rate',
                                                                  style: TextStyle(
                                                                    fontFamily: 'InriaSans',
                                                                    fontSize: 16,
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.bold                                             
                                                                  ),
                                                                ),
                                                              )                  ,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                          ),
                                          Expanded(
                                            flex: 8,
                                            child: LayoutBuilder(
                                              builder: (context,constraints) {
                                                double width = constraints.maxWidth;
                                                double height = constraints.maxHeight;
                                                return Container(
                                                  padding: EdgeInsets.only(left: 16),
                                                  //color: Colors.green,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: width,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                const SizedBox(width: 10,),
                                                                Text('Sort by: '),
                                                                SizedBox(width: 8),
                                                                DropdownButton<String>(
                                                                  value: _selectedSortBy,
                                                                  onChanged: (String? newValue) {
                                                                    setState(() {
                                                                      _selectedSortBy = newValue!;
                                                                      sortList(_staffs,_selectedSortBy);
                                                                      // Implement sorting logic here based on the selected option
                                                                    });
                                                                  },
                                                                  items: <String>['Staff ID', 'Name', 'Position', 'Claimed Status']
                                                                      .map<DropdownMenuItem<String>>((String value) {
                                                                    return DropdownMenuItem<String>(
                                                                      value: value,
                                                                      child: Text(value),
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  width: width*0.25,
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.white, // White background color
                                                                    borderRadius: BorderRadius.circular(8),
                                                                  ),
                                                                  child: TextField(
                                                                    controller: _searchcontroller,
                                                                    onSubmitted: (_){
                                                                      searchStaff(_staffs, _searchcontroller.text);
                                                                    },
                                                                    onChanged: (value){
                                                                      if(value == ''){
                                                                        setState(() {
                                                                          //if(_selectedFilter == ''){_selectedFilter = 'All';}
                                                                          _staffs = allstaffs;
                                                                          notExist = false;
                                                                        });
                                                                      }
                                                                    },
                                                                    decoration: InputDecoration(
                                                                      hintText: 'Search...',
                                                                      border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(8),
                                                                        borderSide: BorderSide.none, // Hide border
                                                                      ),
                                                                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(width: 10),
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Color.fromARGB(255, 87, 189, 90), // Blue color for the search icon button
                                                                    borderRadius: BorderRadius.circular(8),
                                                                  ),
                                                                  child: IconButton(
                                                                    onPressed: () {
                                                                      // Implement search functionality here
                                                                      //searchStaff(filterStaff, _searchcontroller.text);
                                                                    },
                                                                    icon: Icon(Icons.search),
                                                                    color: Colors.white, // White color for the search icon
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                            
                                                      const SizedBox(height: 16),
                                                      
                                                      Expanded(
                                                        child: Container(
                                                          padding: EdgeInsets.all(16),
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            //border: Border.all(color: Colors.grey)
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              LayoutBuilder(
                                                                builder: (context, constraints){
                                                                  double width = constraints.maxWidth;
                                                                  return Container(
                                                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                                    decoration: BoxDecoration(
                                                                      border: Border(bottom: BorderSide(color: Colors.grey)),
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child: Container(
                                                                            //width:width *(1/6),
                                                                            child: Text(
                                                                              'Staff ID',
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(
                                                                                    fontSize: 18, 
                                                                                    fontWeight: FontWeight.bold, 
                                                                                    color: Colors.green
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:2,
                                                                          child: Container(
                                                                            //width:width *(2/6),
                                                                            child: Text(
                                                                              'Name',
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(
                                                                                    fontSize: 18, 
                                                                                    fontWeight: FontWeight.bold, 
                                                                                    color: Colors.green
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          
                                                                          child: Container(
                                                                            //width:width *(1/6),
                                                                            child: Text(
                                                                              'Job Position',
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(
                                                                                    fontSize: 18, 
                                                                                    fontWeight: FontWeight.bold, 
                                                                                    color: Colors.green
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:2,
                                                                          child: Container(
                                                                            //color: Colors.grey,
                                                                            width:width *(2/7),
                                                                            child: Text(
                                                                              'Claim Status',
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(
                                                                                    fontSize: 18, 
                                                                                    fontWeight: FontWeight.bold, 
                                                                                    color: Colors.green
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                }
                                                              ),
                                                              notExist == true 
                                                              ? Container(
                                                                alignment: Alignment.topCenter,
                                                                padding: EdgeInsets.only(top: 50),
                                                                width: width,
                                                                child: Text('Employee does not have a payroll for this week or does not exist.',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Inter',
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.bold
                                                                    ), 
                                                                  ),
                                                              )
                                                              : _staffs.isEmpty && stillFetching == false 
                                                              ? Container(
                                                                alignment: Alignment.topCenter,
                                                                padding: EdgeInsets.only(top: 50),
                                                                width: width,
                                                                child: Text('No payroll for this week.',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Inter',
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.bold
                                                                    ), 
                                                                  ),
                                                              )
                                                              : _staffs.isEmpty && stillFetching == true
                                                              ? Container(
                                                                height: constraints.maxHeight * 0.4,
                                                                child: Center(
                                                                  child: CircularProgressIndicator(),
                                                                ),
                                                              )
                                                              : Expanded(
                                                                child: SingleChildScrollView(
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                    children: [
                                                                      // The list creates the containers for all the trucks
                                                                      ListView.builder(
                                                                        shrinkWrap: true,
                                                                        physics: const NeverScrollableScrollPhysics(), // you can try to delete this
                                                                        itemCount: _staffs.length,
                                                                        itemBuilder: (context, index) {
                                                                          return staffContainer(_staffs[index]);
                                                                        },
                                                                      ),
                                                                      // GridView.builder(
                                                                      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                      //     crossAxisCount: selectaStaff == true ? 2 :3,
                                                                      //     mainAxisSpacing: 5,
                                                                      //     crossAxisSpacing: 5,
                                                                      //   ),
                                                                      //   shrinkWrap: true,
                                                                      //   physics: const NeverScrollableScrollPhysics(),
                                                                      //   itemCount: _staffs.length,
                                                                      //   itemBuilder: (context, index) {
                                                                      //     return ConstrainedBox(
                                                                      //       constraints: BoxConstraints(
                                                                      //         minHeight: 250, // Adjust the height as per your requirement
                                                                      //       ),
                                                                      //       child: buildStaffContainer(_staffs[index]),
                                                                      //     );
                                                                      //   },
                                                                      // ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }
                                            ),
                                          ),
                                        
                                        ],
                                      );
                                    }
                                  ),
                                )
                              ),
                          ],
                        ),
                      );
                      }
                    ),
                  )
                ],
              ),
            );
          }
          else{
            return Row(
              children: [
                Expanded(
                  flex:7,
                  child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical:10),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              
                              child: const Text(
                                'Payroll',
                                style: TextStyle(
                                  fontFamily: 'Itim',
                                  fontSize: 36
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: LayoutBuilder(
                        builder: (context,constraints) {
                          double width = constraints.maxWidth;
                          double height = constraints.maxHeight;
                          //print('$width , $height');
                          return _staffs.isEmpty ? const Center(child: CircularProgressIndicator(),)
                          : SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  //color: Colors.blue,
                                  width: width * 0.95,
                                  color: Color.fromARGB(109, 223, 222, 222),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),                                 
                                  child:Container(
                                      height: 800,
                                      //padding: EdgeInsets.all(16),
                                      // : Color.fromARGB(109, 223, 222, 222),
                                      child: LayoutBuilder(
                                        builder: (context,constraints) {
                                          double width = constraints.maxWidth;
                                          double height = constraints.maxHeight;
                                          return Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              //Filter Container
                                              Expanded(
                                                flex: 3,
                                                child: LayoutBuilder(
                                                    builder: (context,constraints) {
                                                      double width = constraints.maxWidth;
                                                      double height = constraints.maxHeight;
                                                      return Column(
                                                    children: [
                                                      Container(
                                                        height: height*0.38,
                                                        decoration: BoxDecoration(
                                                          color: Color.fromARGB(109, 223, 222, 222),
                                                          border: Border.all(color: Colors.green)
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              width: width,
                                                              color: Color.fromARGB(255, 87, 189, 90),
                                                              padding: EdgeInsets.all(8.0),
                                                              child: Text('Filters',
                                                                style: TextStyle(
                                                                  color:Colors.white,
                                                                  fontFamily: 'Inter',
                                                                  fontSize: 22,
                                                                  fontWeight: FontWeight.bold
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.all(10),
                                                              color: Colors.white,
                                                              width: width,
                                                              height: height *0.26,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  const Text(
                                                                    'Filter list by:',
                                                                    style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontStyle: FontStyle.italic,
                                                                      color: Colors.grey
                                                                    )
                                                                  ),
                                                                  
                                                                  SizedBox(height: 20),
                                                                  if (_startOfWeek != null && _endOfWeek != null) ...[
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('From:'),
                                                                        Text(DateFormat('MMM dd, yyyy').format(_startOfWeek!))
                                                                      ]
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('To:'),
                                                                        Text(DateFormat('MMM dd, yyyy').format(_endOfWeek!))
                                                                      ]
                                                                    ),
                                                                    const Spacer(),
                                                                    const Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('Pick a Week'),
                                                                        //SizedBox(width: 15),
                                                                        
                                                                      ],
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                  ],
                                                                ],
                                                              ),
                                                            ),                                                    
                                                            Container(
                                                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                                              height: height *0.055,
                                                              width: width,
                                                              color: Color.fromRGBO(251, 250, 239, 0.782),
                                                              child: ElevatedButton(
                                                                onPressed: _pickDate, 
                                                                style: ButtonStyle(
                                                                  backgroundColor: MaterialStateProperty.all<Color>(
                                                                      Color.fromARGB(220, 92, 201, 95)
                                                                    ),
                                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                    ),
                                                                  ),
                                                                ),
                                                                child: const Text(
                                                                  'Week',
                                                                  style: TextStyle(
                                                                    fontFamily: 'InriaSans',
                                                                    fontSize: 16,
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.bold                                             
                                                                  ),
                                                                ),
                                                              )                  ,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(height:16),
                                                      Container(
                                                        height: height*0.38,
                                                        decoration: BoxDecoration(
                                                          color: Color.fromARGB(109, 223, 222, 222),
                                                          border: Border.all(color: Colors.green)
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              width: width,
                                                              color: Color.fromARGB(255, 87, 189, 90),
                                                              padding: EdgeInsets.all(8.0),
                                                              child: Text('Pay Rate',
                                                                style: TextStyle(
                                                                  color:Colors.white,
                                                                  fontFamily: 'Inter',
                                                                  fontSize: 22,
                                                                  fontWeight: FontWeight.bold
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.all(10),
                                                              color: Colors.white,
                                                              width: width,
                                                              height: height *0.26,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  const Text(
                                                                    'Recorded Pay Rate:',
                                                                    style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontStyle: FontStyle.italic,
                                                                      color: Colors.grey
                                                                    )
                                                                  ),
                                                                  const SizedBox(height: 10),
                                                                  Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('Driver Rate:'),
                                                                        Text('Php ${driverRate.toStringAsFixed(2)}')
                                                                      ]
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('Helper Rate:'),
                                                                        Text('Php ${helperRate.toStringAsFixed(2)}')
                                                                      ]
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('Loading Trip Rate:'),
                                                                        Text('${loadingRate.toString()} days')
                                                                      ]
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('Cebu Trip Rate:'),
                                                                        Text('${cebuRate.toString()} days')
                                                                      ]
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text('Other Trips Rate:'),
                                                                        Text('${otherRate.toString()} days')
                                                                      ]
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                ],
                                                              ),
                                                            ),                                                    
                                                            Container(
                                                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                                              height: height *0.055,
                                                              width: width,
                                                              color: Color.fromRGBO(251, 250, 239, 0.782),
                                                              child: ElevatedButton(
                                                                onPressed: ()async{
                                                                  Map<String, dynamic>? rates = await showDialog<Map<String, dynamic>>(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                      return AlertDialog(
                                                                        contentPadding: EdgeInsets.zero,
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(15.0),
                                                                        ),
                                                                        content: RateDialog(
                                                                          newrates: (value) {
                                                                            Navigator.of(context).pop(value); // Close the dialog and return the assigned value
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                  );

                                                                  if(rates != null){
                                                                    setState(() {
                                                                      driverRate = rates['driverRate'];
                                                                      helperRate = rates['helperRate'];
                                                                      loadingRate = rates['loadingRate'];
                                                                      cebuRate = rates['cebuRate'];
                                                                      otherRate = rates['otherRate'];
                                                                    });
                                                                  }
                                                                }, 
                                                                style: ButtonStyle(
                                                                  backgroundColor: MaterialStateProperty.all<Color>(
                                                                      Color.fromARGB(220, 92, 201, 95)
                                                                    ),
                                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                    ),
                                                                  ),
                                                                ),
                                                                child: const Text(
                                                                  'Update Pay Rate',
                                                                  style: TextStyle(
                                                                    fontFamily: 'InriaSans',
                                                                    fontSize: 16,
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.bold                                             
                                                                  ),
                                                                ),
                                                              )                  ,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                    },
                                                  ),
                                              ),
                                              Expanded(
                                                flex: 8,
                                                child: LayoutBuilder(
                                                  builder: (context,constraints) {
                                                    double width = constraints.maxWidth;
                                                    double height = constraints.maxHeight;
                                                    return Container(
                                                      padding: EdgeInsets.only(left: 16),
                                                      //color: Colors.green,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            width: width,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    const SizedBox(width: 10,),
                                                                    Text('Sort by: '),
                                                                    SizedBox(width: 8),
                                                                    DropdownButton<String>(
                                                                      value: _selectedSortBy,
                                                                      onChanged: (String? newValue) {
                                                                        // setState(() {
                                                                        //   _selectedSortBy = newValue!;
                                                                        //   sortList(filterStaff,_selectedSortBy);
                                                                        //   // Implement sorting logic here based on the selected option
                                                                        // });
                                                                      },
                                                                      items: <String>['Name', 'Staff ID', 'Position']
                                                                          .map<DropdownMenuItem<String>>((String value) {
                                                                        return DropdownMenuItem<String>(
                                                                          value: value,
                                                                          child: Text(value),
                                                                        );
                                                                      }).toList(),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      width: width*0.25,
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.white, // White background color
                                                                        borderRadius: BorderRadius.circular(8),
                                                                      ),
                                                                      child: TextField(
                                                                        controller: _searchcontroller,
                                                                        onSubmitted: (_){
                                                                          //searchStaff(filterStaff, _searchcontroller.text);
                                                                        },
                                                                        onChanged: (value){
                                                                          if(value == ''){
                                                                            // setState(() {
                                                                            //   //if(_selectedFilter == ''){_selectedFilter = 'All';}
                                                                            //   applyFilter(_selectedFilter);
                                                                            //   notExist = false;
                                                                            // });
                                                                          }
                                                                        },
                                                                        decoration: InputDecoration(
                                                                          hintText: 'Search...',
                                                                          border: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(8),
                                                                            borderSide: BorderSide.none, // Hide border
                                                                          ),
                                                                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: 10),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        color: Color.fromARGB(255, 87, 189, 90), // Blue color for the search icon button
                                                                        borderRadius: BorderRadius.circular(8),
                                                                      ),
                                                                      child: IconButton(
                                                                        onPressed: () {
                                                                          // Implement search functionality here
                                                                          //searchStaff(filterStaff, _searchcontroller.text);
                                                                        },
                                                                        icon: Icon(Icons.search),
                                                                        color: Colors.white, // White color for the search icon
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                
                                                          const SizedBox(height: 16),
                                                          
                                                          Expanded(
                                                            child: Container(
                                                              padding: EdgeInsets.all(16),
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                //border: Border.all(color: Colors.grey)
                                                              ),
                                                              child: notExist == true 
                                                              ? Container(
                                                                alignment: Alignment.topCenter,
                                                                padding: EdgeInsets.only(top: 50),
                                                                width: width,
                                                                child: Text('Employee does not exist.',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Inter',
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.bold
                                                                    ), 
                                                                  ),
                                                              )
                                                              : Column(
                                                                children: [
                                                                  LayoutBuilder(
                                                                    builder: (context, constraints){
                                                                      double width = constraints.maxWidth;
                                                                      return Container(
                                                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                                        decoration: BoxDecoration(
                                                                          border: Border(bottom: BorderSide(color: Colors.grey)),
                                                                        ),
                                                                        child: Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Container(
                                                                                //width:width *(1/6),
                                                                                child: Text(
                                                                                  'Staff ID',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(
                                                                                    fontSize: 18, 
                                                                                    fontWeight: FontWeight.bold, 
                                                                                    color: Colors.green
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex:2,
                                                                              child: Container(
                                                                                //width:width *(2/6),
                                                                                child: Text(
                                                                                  'Name',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(
                                                                                    fontSize: 18, 
                                                                                    fontWeight: FontWeight.bold, 
                                                                                    color: Colors.green
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Container(
                                                                                //width:width *(1/6),
                                                                                child: Text(
                                                                                  'Job Position',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(
                                                                                    fontSize: 18, 
                                                                                    fontWeight: FontWeight.bold, 
                                                                                    color: Colors.green
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex:2,
                                                                              child: Container(
                                                                                //color: Colors.grey,
                                                                                width:width *(2/7),
                                                                                child: Text(
                                                                                  'Claim Status',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(
                                                                                    fontSize: 18, 
                                                                                    fontWeight: FontWeight.bold, 
                                                                                    color: Colors.green
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }
                                                                  ),
                                                                  Expanded(
                                                                    child: SingleChildScrollView(
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                        children: [
                                                                          // The list creates the containers for all the trucks
                                                                          ListView.builder(
                                                                            shrinkWrap: true,
                                                                            physics: const NeverScrollableScrollPhysics(), // you can try to delete this
                                                                            itemCount: _staffs.length,
                                                                            itemBuilder: (context, index) {
                                                                              return staffContainer(_staffs[index]);
                                                                            },
                                                                          ),
                                                                          // GridView.builder(
                                                                          //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                          //     crossAxisCount: 2,
                                                                          //     mainAxisSpacing: 5,
                                                                          //     crossAxisSpacing: 5,
                                                                          //   ),
                                                                          //   shrinkWrap: true,
                                                                          //   physics: const NeverScrollableScrollPhysics(),
                                                                          //   itemCount: _staffs.length,
                                                                          //   itemBuilder: (context, index) {
                                                                          //     return ConstrainedBox(
                                                                          //       constraints: BoxConstraints(
                                                                          //         minHeight: 250, // Adjust the height as per your requirement
                                                                          //       ),
                                                                          //       child: buildStaffContainer(_staffs[index]),
                                                                          //     );
                                                                          //   },
                                                                          // ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                ),
                                              ),
                                            
                                            ],
                                          );
                                        }
                                      ),
                                    )
                                  ),
                              ],
                            ),
                          );
                          }
                        ),
                      )
                    ],
                  ),
                  )
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    //height: 1000,
                    color: Colors.green.shade50,
                    child: staffPanel(selectedStaff)
                  ),
                )
              ],
            );
          }
        }
      ),
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
  
  Widget staffContainer(Map<String, dynamic> aStaff){
    return LayoutBuilder(
      builder: (context, constraints){
        double width = constraints.maxWidth;
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
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: selectedStaff == aStaff && selectaStaff == true
              ? Border.all(color: Colors.green, width:3)
              : Border(bottom: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    //width:width *(1/6),
                    child: Text(
                      aStaff['staffId'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    //width:width *(2/6),
                    child: Text(
                      '${aStaff['firstname']} ${aStaff['lastname']}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    //width:width *(1/6),
                    child: Text(
                      aStaff['position'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Expanded(
                  flex:2,
                  child: Container(
                    //color: Colors.grey,
                    //width:width *(2/7),
                    child: Text(
                      aStaff['ClaimedStatus'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
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
    totalDeduct = aStaff['SSS'] + aStaff['PhilHealth'] + aStaff['Pagibig'];
    
    //getAccomplishedDelivery(aStaff['staffId']);
    return Container(
      //width: size.width * 0.5,
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
            height: size.height *0.795, //changed from 0.80
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
                          aStaff['netSalary'] != null?
                          'Php ${aStaff['netSalary'].toStringAsFixed(2)}' 
                          :'Php 0.00',
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
                                onPressed: () async{
                                  String numberString = month.toString();
                                  if (numberString.length == 1) {
                                    numberString = '0$numberString';
                                  }

                                  // Construct the Firestore path
                                  String path = 'Payroll/$year' + '_' + numberString + '/$week';
                                  print(path);
                                  Map<String, dynamic>? breakdown = await showDialog<Map<String, dynamic>>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        contentPadding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        content: ComputeDialog(
                                          staff: aStaff,
                                          breakdown: (value) {
                                            Navigator.of(context).pop(value); // Close the dialog and return the assigned value
                                          },
                                          path: path,
                                        ),
                                      );
                                    },
                                  );

                                  if(breakdown != null){
                                    //print('breakdown not empty');
                                    //print(breakdown); 

                                    // Check and print the data types of the elements in the breakdown map
                                    // breakdown.forEach((key, value) {
                                    //   print('Key: $key, Value: $value, Type: ${value.runtimeType}');
                                    // });

                                    
                                    setState(() {
                                      netSalary = breakdown['netSalary'] ?? breakdown['netSalary'] as double;
                                      salary = breakdown['salary'] ?? breakdown['salary'] as double;
                                      numDays = breakdown['numDays'] ?? breakdown['numDays'] as double;
                                      salaryRate = breakdown['salaryRate'] ?? breakdown['salaryRate'] as double;
                                      totalDeduct = breakdown['totalDeduct'] ?? breakdown['totalDeduct'];
                                      SSS = breakdown['SSS'] ?? breakdown['SSS'] as double;
                                      PhilHealth = breakdown['PhilHealth'] ?? breakdown['PhilHealth'] as double;
                                      Pag_ibig = breakdown['Pag-ibig'] ?? breakdown['Pag-ibig'] as double;
                                      aStaff['netSalary'] = netSalary;
                                      aStaff['numDays'] = numDays;
                                      aStaff['SSS'] = SSS;
                                      aStaff['PhilHealth'] = PhilHealth;
                                      aStaff['Pagibig'] = Pag_ibig;
                                      totalDeduct = aStaff['SSS'] + aStaff['PhilHealth'] + aStaff['Pagibig'];
                                    });
                                    //print('here $netSalary, $salary, $numDays, $salaryRate, $totalDeduct, $SSS, $PhilHealth, $Pag_ibig');
                                  }
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
                        Padding(
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
                                    aStaff['position'] == 'Driver' && aStaff['numDays'] != null
                                    ? 'Php ${(driverRate*aStaff['numDays']).toStringAsFixed(2)}'
                                    :'Php 0.00',
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
                                    'Salary Rate',
                                    style: TextStyle(
                                      color: Color(0xFF737373),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    aStaff['position'] == 'Driver'? 'Php ${driverRate.toStringAsFixed(2)}' 
                                    : 'Php ${helperRate.toStringAsFixed(2)}',
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
                                    'No. of Days',
                                    style: TextStyle(
                                      color: Color(0xFF737373),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    aStaff['numDays'] != null 
                                    ? aStaff['numDays'].toString()
                                    : '0',
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
                                    'Php ${totalDeduct.toStringAsFixed(2)}',
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
                                    aStaff['SSS'] != null ? 'Php ${aStaff['SSS'].toStringAsFixed(2)}'
                                     : 'Php 0.00',
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
                                    aStaff['PhilHealth'] != null ? 'Php ${aStaff['PhilHealth'].toStringAsFixed(2)}'
                                    :'Php 0.00',
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
                                    aStaff['Pagibig']!= null ?'Php ${aStaff['Pagibig'].toStringAsFixed(2)}'
                                    :'Php 0.00',
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
                                    aStaff['netSalary'] != null ? 'Php ${aStaff['netSalary'].toStringAsFixed(2)}'
                                    :'Php 0.00',
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
                          onPressed: () async{
                            if(aStaff['ClaimedStatus'] == 'Not Claimed'){
                              String numberString = month.toString();
                              if (numberString.length == 1) {
                                numberString = '0$numberString';
                              }

                              // Construct the Firestore path
                              String path = 'Payroll/$year' + '_' + numberString + '/$week';
                              Map<String, dynamic>? claimStatus = await showDialog<Map<String, dynamic>?>(
                                context: context,
                                builder: (BuildContext context) {
                                  String todayDate = DateFormat('d MMMM, yyyy').format(DateTime.now()).toUpperCase();
                                  return ClaimDialog(path: path, staffId: aStaff['staffId'],
                                    status: (value) {
                                      Navigator.of(context).pop(value); // Close the dialog and return the assigned value
                                    },
                                  );
                                },
                              );

                              if(claimStatus != null){
                                if(claimStatus['status'] == 'Claimed') {
                                  setState(() {
                                    aStaff['ClaimedStatus'] = 'Claimed';
                                    aStaff['ClaimedBy'] = claimStatus['name'];
                                    aStaff['ClaimedPicture'] = claimStatus['image'];
                                    aStaff['ClaimedDate'] = DateTime.parse(claimStatus['date']); //String
                                  });
                                  //print(staff['ClaimedDate'].runtimeType);
                                
                              }
                              }
                            } else{
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: Text('Payroll already claimed.'),
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
                              );    // Close the dialog
                            }
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
                            // Generate and save the PDF
                            // final String? pdfPath = await generateAndSavePDF();
                            // print('toPdf');

                            generateAndPrintPdf(aStaff, helperRate, driverRate);
                  
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
  
}

