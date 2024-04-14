import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haul_a_day_web/authentication/constant.dart';
import 'package:haul_a_day_web/newUI/components/sidepanel.dart';
import 'package:provider/provider.dart';

class OrderDetailsPage extends StatefulWidget {
  final Map<String,dynamic> order;
  OrderDetailsPage({super.key, required this.order});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  Map<String,dynamic> _order = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _order = widget.order;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 200),
      width: double.infinity,
      
      child: Column(
        children: [
          Expanded(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                  onPressed: (){
                    Provider.of<SideMenuSelection>(context, listen: false)
                      .setSelectedTab(TabSelection.Order); // Assuming the order tab index is 3
                  },
                  icon: Icon(Icons.arrow_back, size: 30)
                ),
                SizedBox(width: 10,),
                const Text(
                  'Order Details',
                  style: TextStyle(
                    fontFamily: 'Itim',
                    fontSize: 36
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 9,
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: LayoutBuilder(
                    builder: (context,constraints) {
                      return Container(
                        //height: 1060,
                        padding:EdgeInsets.fromLTRB(16, 16, 16, 0),
                        color: Colors.blue[200],
                        child: SingleChildScrollView(
                          child: SizedBox(
                            height: 1300, // Limit the height of SingleChildScrollView
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 100),
                                  margin: EdgeInsets.all(16),
                                  height: 125,
                                  decoration: BoxDecoration(
                                    color: Colors.green[300],
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5), // Shadow color
                                        spreadRadius: 5, // Spread radius
                                        blurRadius: 5, // Blur radius
                                        offset: Offset(0, 3), // Offset from the container
                                      ),
                                    ],
                                  ),
                                  child: orderTitle(
                                    _order['route'], 
                                    _order['id'], 
                                    _order['filed_date'], 
                                    _order['filed_time'],
                                    _order['confirmed_status'],
                                    _order['assignedStatus']
                                  )
                                ),
                                SizedBox(height:16),
                                Container(
                                  height: 450,
                                  color: Colors.white,
                                  child: Center(
                                    child: Text(
                                      'Unloading'
                                      ),
                                    ), 
                                ),
                                SizedBox(height:16),
                                Container(
                                  height: 115,
                                  color: Colors.white,
                                  child: Center(
                                    child: Text(
                                      'Customer'
                                      ),
                                    ), 
                                ),
                                SizedBox(height:16),
                                Container(
                                  height: 500,
                                  color: Colors.white,
                                  child: Center(
                                    child: Text(
                                      'Reports'
                                      ),
                                    ), 
                                ),
                              ],
                            ),
                          ),
                        ),
                        );
                    }
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(color: Colors.green[200]),
                )
              ],
            ) 
            
          )
        ],
      ),
    );
  }

  Widget orderTitle(String route,String orderID, String filedDate, String filedTime, bool confirm, String assignStatus){
    ColorFilter colorFilter = ColorFilter.mode(Colors.white, BlendMode.modulate);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Order title and filed date & time
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$route - $orderID',
              style: TextStyle(
                fontFamily: 'Itim',
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '$filedDate at $filedTime',
              style: TextStyle(
                fontFamily: 'Iter',
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ],
        ),

        // Confirm & cancel and Assign buttons
        Column(
          children: [
            //confirm and cancel butttons
            Row(
              children: [
                ElevatedButton(
                  onPressed: (){}, 
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white,),
                      SizedBox(width: 5,),
                      Text('Confirm', style: TextStyle(color: Colors.white))
                    ],
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                    backgroundColor: confirm
                        ? MaterialStateProperty.all<Color>(Colors.grey) // Gray out the button if confirmed
                        : MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255, 235, 59)),
                    foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                ElevatedButton(
                  onPressed: (){}, 
                  child: Row(
                    children: [
                      Icon(Icons.cancel, color: Colors.white,),
                      SizedBox(width: 5,),
                      Text('Cancel', style: TextStyle(color: Colors.white))
                    ],
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                    backgroundColor: MaterialStateProperty.all(Color.fromRGBO(233, 98, 105,1)),
                    //foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                ElevatedButton(
                  onPressed: (){}, 
                  child: Row(
                    children: [
                      SizedBox(
                        height:20,
                        child: ColorFiltered(
                        colorFilter: colorFilter,
                        child: Image.asset('images/logistic_add.png', fit: BoxFit.scaleDown,), // Replace 'assets/image.png' with your image path
                      ),
                      ),
                      SizedBox(width: 5,),
                      Text('Assign', style: TextStyle(color: Colors.white))
                    ],
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    //foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 0, 0, 0)),
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}