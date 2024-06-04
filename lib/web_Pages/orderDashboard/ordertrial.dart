import 'package:flutter/material.dart';
import 'package:haul_a_day_web/authentication/constant.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:haul_a_day_web/web_Pages/otherComponents/sidepanel.dart';
import 'package:provider/provider.dart';

class OrderTrial extends StatefulWidget {
  final List<Map<String, dynamic>> orderDetails;
  final bool fetchOrderDetails;
  const OrderTrial({super.key, required this.orderDetails, required this.fetchOrderDetails});

  @override
  State<OrderTrial> createState() => _OrderTrialState();
}

class _OrderTrialState extends State<OrderTrial> {
  DatabaseService databaseService = DatabaseService();
  List<Map<String, dynamic>> _filteredOrderDetails = [];
  TextEditingController _searchcontroller = TextEditingController();
  bool notExist = false;

  @override
  void initState() {
    super.initState();
    // Provider.of<SideMenuSelection>(context, listen: false)
    //     .setPreviousTab(TabSelection.Order);
    //fetchOrder();
    _waitForFetchOrderDetails();
  }

  // void fetchOrder() async{
  //   List<Map<String, dynamic>> orders = await databaseService.fetchAllOrderList();
  //   setState(() {
  //     _filteredOrderDetails = orders;
  //   });
  // }

  void _waitForFetchOrderDetails() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (widget.fetchOrderDetails == true) {
        setState(() {
          _filteredOrderDetails = widget.orderDetails;
          //print('${widget.fetchOrderDetails}, $_filteredOrderDetails');
        });
      } else {
        _waitForFetchOrderDetails(); // Call the function again if fetchOrderDetails is not true
      }
    });
  }

  void searchOrder(List<Map<String, dynamic>> originalList, String searchQuery) {
    List<Map<String, dynamic>> filteredList = widget.orderDetails;
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
        _filteredOrderDetails = filteredList;
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical:10),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Order Dashboard',
                        style: TextStyle(
                          fontFamily: 'Itim',
                          fontSize: 36
                        ),
                      ),
                    ),
                    
                    
                  ],
                ),
              ),
          
              
              
            ],
          ),
        );
      }
    );
  }
}