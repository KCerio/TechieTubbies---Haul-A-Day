import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:haul_a_day_web/service/userService.dart';
import 'package:haul_a_day_web/web_Pages/staffDirectory/accApprovalDialog.dart';
import 'package:intl/intl.dart';

class StaffList extends StatefulWidget {
  final String userId;
  final String accessKey;
  const StaffList({super.key, required this.userId, required this.accessKey});

  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  List<Map<String, dynamic>> filterStaff = [];
  List<Map<String, dynamic>> _staffs = [];
  List<Map<String, dynamic>> _management = [];
  Map<String, dynamic> selectedStaff = {};
  //List<int> sub= [1,2,3,4,5,7,8,9,3];
  List<Map<String, dynamic>> toBeApproved = [];
  bool selectaStaff = false;
  String _selectedFilter = 'All';
  String _selectedSortBy = 'Name'; // Default sorting option
  String searchQuery = '';
  TextEditingController _searchcontroller = TextEditingController();
  bool notExist = false;


  @override
  void initState() {
    super.initState();
    _initializeStaffData();
    
  }

  Future<void> _initializeStaffData() async {
    try {
      print(widget.accessKey);
      DatabaseService databaseService = DatabaseService();
      List<Map<String, dynamic>> management = await databaseService.fetchManagementStaffList();
      List<Map<String, dynamic>> staffs = await databaseService.fetchOPStaffList();
      List<Map<String, dynamic>> allstaffs = [];
      if(widget.accessKey == 'superAdmin'){
        allstaffs = management + staffs;
      }else if(widget.accessKey == 'Admin'){
        allstaffs = staffs;
      }
      for(Map<String, dynamic> account in allstaffs){
        if(account['accessKey']==null){
          toBeApproved.add(account);
        }
        else{
          if(account['position'] != 'Driver' && account['position'] != 'Helper'){
            _management.add(account);
          }
          else{
            _staffs.add(account);
          }
        }
      }
      
      setState(() {
        //_management = management;
        filterStaff = _management + _staffs;
        //_staffs = staffs;
      });
      sortList(filterStaff,_selectedSortBy);
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void applyFilter(String filter){
    if(filter == 'Management'){
      setState(() {
        filterStaff = _management;
        sortList(filterStaff,_selectedSortBy);
      });
    } else if(filter == 'Operational'){
      setState(() {
        filterStaff = _staffs;
        sortList(filterStaff,_selectedSortBy);
      });
    } else{
      setState(() {
        filterStaff = _management + _staffs;
        sortList(filterStaff,_selectedSortBy);
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
      filterStaff = list;
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
        filterStaff = filteredList;
      });
    }
    
  }

  UserService userService = UserService();
  TextEditingController _passwordController = TextEditingController();


  void rejectAccount(Map<String,dynamic> staff)async{
    // Add your approval logic here                      
    String password = _passwordController.text;
    // Perform validation and approval process
    bool approved = await userService.confirmation(widget.userId, password);
    if(approved){
      userService.removeAccount(staff['staffId']);
      //Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Account Removed'),
            content:  Text('This account is now removed!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Close the dialog
                  setState(() {
                    selectaStaff = false;
                    selectedStaff = {};                    
                    if(staff['accessKey'] =='Basic') {
                      _staffs.remove(staff);
                      print('remove from op staff');
                    }else{
                      _management.remove(staff);
                      print('remove from management');
                    }
                    filterStaff.remove(staff);
                    print('removed from all staff');
                  });
                  _passwordController.clear();
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
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
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
                          'Staff Directory',
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
                     return _staffs.isEmpty && _management.isEmpty ? const Center(child: CircularProgressIndicator(),)
                    :SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(100, 0, 100, 10),
                       child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                            Divider(),
                            Row( //Account Approval Text and counter
                              children: [
                                Container(
                                padding: const EdgeInsets.only(bottom: 10, top:10),
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    'Account Approval',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20,),
                                Container(
                                  width: 30,
                                  height: 30,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,

                                  ),
                                  child: Text(
                                    toBeApproved.length.toString(),
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height:12),
                            // Account Approval Carousel
                            Container(
                              padding: const EdgeInsets.all(16),
                              height: 250, // Set a fixed height for the container
                              width: double.infinity, // Make the container expand horizontally
                              decoration: const BoxDecoration(color: Color.fromARGB(109, 223, 222, 222)),
                              child: toBeApproved.length == 0 
                              ? Container(
                                height: 300,
                                child: const Center(
                                  child: Text(
                                    'No accounts to be approved',
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                      ),  
                                    )
                                  ),
                                )          
                              : CarouselSlider.builder(
                                itemCount: toBeApproved.length,
                                options: CarouselOptions(
                                  scrollDirection: Axis.horizontal,
                                  enableInfiniteScroll: false, // Set this to false
                                  height: 300,
                                  //aspectRatio: 16/9,
                                  viewportFraction: 0.3 ,// Adjust this value to change the number of items seen in every page
                                  initialPage: 0,
                                  reverse: false,
                                  autoPlay: false,
                                  autoPlayInterval: Duration(seconds: 3),
                                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: true,
                                  onPageChanged: (index, reason) {
                                    // Your callback
                                  },
                                  scrollPhysics: BouncingScrollPhysics(),
                                // itemMargin: 10.0, // Adjust this value to change the distance between widgets
                                ),
                                itemBuilder: (BuildContext context, int index, int realIndex) {
                                  return accountApproval(toBeApproved[index]);
                                },
                              )
                            ),


                            const SizedBox(height:12),
                            Divider(),
                            const SizedBox(height:12),

                            selectaStaff == false ? Container()
                            : Column(
                              children: [                                
                                Container(
                                  height: height * 0.6,
                                  width: width,
                                  color: Color.fromARGB(109, 223, 222, 222),
                                  child: staffInfoPanel(selectedStaff)
                                ),

                                const SizedBox(height:12),
                                Divider(),
                                const SizedBox(height:12),
                              ],
                            ),

                            Container(
                              width: width,
                              height: 1000,
                              padding: EdgeInsets.all(16),
                              color: Color.fromARGB(109, 223, 222, 222),
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
                                              return Container(
                                                height: height*0.36,
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
                                                      height: height *0.25,
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
                                                          const SizedBox(height: 10),
                                                          Row(
                                                        children: [
                                                          Radio<String>(
                                                            value: 'All',
                                                            groupValue: _selectedFilter,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _selectedFilter = value!;
                                                              });
                                                              print(_selectedFilter);
                                                            },
                                                          ),
                                                          Text('All'),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Radio<String>(
                                                            value: 'Management',
                                                            groupValue: _selectedFilter,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _selectedFilter = value!;
                                                              });
                                                              print(_selectedFilter);
                                                            },
                                                          ),
                                                          Text('Management'),
                                                        ],
                                                      ),
                                                      
                                                      Row(
                                                        children: [
                                                          Radio<String>(
                                                            value: 'Operational',
                                                            groupValue: _selectedFilter,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _selectedFilter = value!;
                                                              });
                                                              print(_selectedFilter);
                                                            },
                                                          ),
                                                          Text('Operational'),
                                                        ],
                                                      )
                                                        ],
                                                      ),
                                                    ),                                                    
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                                      height: height *0.055,
                                                      width: width,
                                                      color: Color.fromRGBO(251, 250, 239, 0.782),
                                                      child: ElevatedButton(
                                                        onPressed: (){
                                                         applyFilter(_selectedFilter);
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
                                                          'Apply Filter',
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
                                                                  sortList(filterStaff,_selectedSortBy);
                                                                  // Implement sorting logic here based on the selected option
                                                                });
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
                                                                  searchStaff(filterStaff, _searchcontroller.text);
                                                                },
                                                                onChanged: (value){
                                                                  if(value == ''){
                                                                    setState(() {
                                                                      //if(_selectedFilter == ''){_selectedFilter = 'All';}
                                                                      applyFilter(_selectedFilter);
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
                                                                  searchStaff(filterStaff, _searchcontroller.text);
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
                                                      : LayoutBuilder(
                                                        builder: (BuildContext context, BoxConstraints constraints) {
                                                          return SingleChildScrollView(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                                              children: [
                                                                // The list creates the containers for all the trucks
                                                                GridView.builder(
                                                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                    crossAxisCount: 3,
                                                                    mainAxisSpacing: 5,
                                                                    crossAxisSpacing: 5,
                                                                  ),
                                                                  shrinkWrap: true,
                                                                  physics: const NeverScrollableScrollPhysics(),
                                                                  itemCount: filterStaff.length,
                                                                  itemBuilder: (context, index) {
                                                                    return ConstrainedBox(
                                                                      constraints: BoxConstraints(
                                                                        minHeight: 250, // Adjust the height as per your requirement
                                                                      ),
                                                                      child: buildStaffContainer(filterStaff[index]),
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          }
                                        ),
                                      )
                                    ],
                                  );
                                }
                              ),
                            )
                          ]
                        )
                      );
                    }
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
                      
  }

  Widget accountApproval(Map<String, dynamic> account){
    String registeredDate;
    if (account['registeredDate'] is String) {
      registeredDate = account['registeredDate'] ?? ' ';
    } else if(account['registeredDate'] == null){
      registeredDate = ' ';
    }
    else {
      registeredDate = DateFormat('MMM dd, yyyy').format(account['registeredDate'].toDate());
    }

    return InkWell(
      onTap: ()async {
        Map<String, dynamic>? approval = await showDialog<Map<String, dynamic>>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              content: AccountApprovalDialog(
                account: account,
                userId: widget.userId,
                access: (value) {
                  Navigator.of(context).pop(value); // Close the dialog and return the assigned value
                },
              ),
            );
          },
        );

        if (approval != null) {
          print(approval);
          if (approval['accessKey'] != null) {
            print('Account: ${approval['accessKey']}');
            setState(() {
              account['accessKey'] = approval['accessKey'];
              //filterStaff.add(account);
              if(approval['accessKey'] =='Basic') {
                _staffs.add(account);
              }else{
                _management.add(account);
              }
              applyFilter(_selectedFilter);
              sortList(filterStaff, _selectedSortBy);
              toBeApproved.remove(account);
            });
          } else if (approval['remove'] == true) {
            toBeApproved.remove(account);
          }
        }

      },
      child: Container(
        width: 200,
        height: 220,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 87, 189, 90),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)
        ),
        child: Column(
          children: [
            Text(
              account['position'],
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
            Container(
              width:200,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white, 
                border: Border(
                  top: BorderSide(color: Colors.black, width: 1.0,),
                  bottom: BorderSide(color: Colors.black, width: 1.0,),
                ),
              ),
              child: account['pictureUrl'] != null
              ? Image.network(account['pictureUrl'],fit: BoxFit.scaleDown,)
              : Image.asset('images/user_pic.png',fit: BoxFit.scaleDown,)
            ),
            const SizedBox(height: 10),
            Text(
              '${account['firstname']} ${account['lastname']}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 10),
            Text(
              registeredDate,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                
              ),
            ),
          ],
        )
      ),
    );
  }

  //Staff Information
  Widget staffInfoPanel(Map<String, dynamic> staff){
    String registeredDate;
    if (staff['registeredDate'] is String) {
      registeredDate = staff['registeredDate'] ?? ' ';
    } else if(staff['registeredDate'] == null){
      registeredDate = ' ';
    }
    else {
      registeredDate = DateFormat('MMM dd, yyyy').format(staff['registeredDate'].toDate());
    }
    return LayoutBuilder(
      builder: (context, constraints){
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        return Center(
          child: Container(
            width: width *0.8,
            height: height *0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.green, width: 5)
            ),
            child:Row(
              children: [
                Expanded(
                  flex:3,
                  child: LayoutBuilder(
                    builder:(context,constraints){
                    double width = constraints.maxWidth;
                    double height = constraints.maxHeight;
                    return Container(
                        //color: Colors.blue,
                        width: width,
                        height: height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //const SizedBox(height: 16),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(12),
                              width: width*0.6,
                              height: height *0.6,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(76, 206, 80, 1),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5), // Shadow color
                                    spreadRadius: 2, // Spread radius
                                    blurRadius: 5, // Blur radius
                                    offset: Offset(0, 3), // Offset from the container
                                  ),
                                ],
                              ),
                              child: staff['pictureUrl'] != null
                              ? Image.network(staff['pictureUrl'], fit: BoxFit.fill)
                              : Image.asset('images/user_pic.png',  fit: BoxFit.contain),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${staff['firstname']} ${staff['lastname']}',
                              style: TextStyle(
                                fontSize: 20,
                                //color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter'
                              ),
                            ),
                            Text(
                              staff['staffId'],
                              style: TextStyle(
                                fontSize: 16,
                                //color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'InriaSans'
                              ),
                            ),
                          ],
                        )
                      
                      );
                    }
                  ),

                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    alignment: Alignment.center,
                    //width: width * 0.6,
                    //color: Colors.green,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double width = constraints.maxWidth;
                        double height = constraints.maxHeight;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            
                            Text(
                              "Staff's Information",
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
                                        staff['firstname']??'',
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
                                        staff['lastname']??'',
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
                                      'Username',
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
                                        staff['userName']?? '',
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
                                        staff['contactNumber'] ?? '',
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
                              child: Row(
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
                                        staff['position']??'',
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
                                ],
                              ),
                            ),
                            const SizedBox(height: 25,),
                            
                            Container(
                              width: width,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 50),
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Deletion Confirmation'),
                                        content: Container(
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text('Do you wish to delete this account? If yes please input your password to confirm deletion.',
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
                                                        rejectAccount(staff);
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
                                              rejectAccount(staff);
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
                                  backgroundColor: Colors.red,
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
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 8.0),
                                    const Text(
                                      'Remove',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                          ],
                        );
                      }
                    ),
                  ),
                )
              ],
            )
          ),
        );
      }
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
        width: 200,
        
        margin: const EdgeInsets.fromLTRB(
            40, 10, 40, 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Colors.grey,
              width: 2),
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
            aStaff['position'] != 'Driver' && aStaff['position'] != 'Helper'
            ? Container()
            : Column(
                crossAxisAlignment:
                CrossAxisAlignment.end,
                children: [
                  Text(
                    aStaff['assignedSchedule'] == 'none' || aStaff['assignedSchedule'] == null
                        ? 'Available'        
                          : 'Busy',
                    style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        color:
                            aStaff['assignedSchedule'] == 'none' || aStaff['assignedSchedule'] == null
                            ? Colors.green        
                            : Colors.blue,
                        fontSize: 20
                        ),
                  ),
                  const SizedBox(height: 2),
                  
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
            Icon(Icons.face_4_rounded,
                size: 50, color: Colors.black),
            SizedBox(height: 10),
            Text(
              'Select an Employee',
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

  // selected staff right panel
  Widget staffPanel(Map<String, dynamic> aStaff){
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width *0.5,
      color: Colors.green.shade50,
      child: SingleChildScrollView(
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
                    if(selectaStaff == false){
                      selectedStaff = aStaff;
                      selectaStaff = true;
                    }
                    else if(selectaStaff == true){
                      selectedStaff = {};
                      selectaStaff = false;
                    }
                  });
                },
              ),
              // Add other widgets to the app bar as needed
            ],
          ),
            SizedBox(height: 40),
            Positioned(
              left: 100,
              child: Container(
                width: 150.0,
                height: 150.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: aStaff['pictureUrl'] != null ? Image.network(aStaff['pictureUrl'],
                    fit: BoxFit.cover,)
                  : Image.asset(
                    'images/user_pic.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '${aStaff['firstname']} ${aStaff['lastname']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 250,
              color: Colors.grey.shade400,
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text('Staff ID: ${aStaff['staffId']}',
                          style:
                              TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('Username: ${aStaff['userName']}',
                          style:
                              TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('Position: ${aStaff['position']}',
                          style:
                              TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('Registered Date: ${aStaff['registeredDate']}',
                          style:
                              TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('Contact Number: ${'contactNumber'}',
                          style:
                              TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('Email',
                          style:
                              TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(100, 50, 0, 30),
                child: ElevatedButton(
                  onPressed: () {
                    // Remove truck functionality here
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(2),
                        right: Radius.circular(2),
                      ),
                    ),
                    backgroundColor: Colors
                        .grey[300], // Background color of the button
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  }