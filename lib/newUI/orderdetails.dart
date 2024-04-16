import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haul_a_day_web/service/database.dart';
import 'package:haul_a_day_web/authentication/constant.dart';
import 'package:haul_a_day_web/newUI/components/sidepanel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderDetailsPage extends StatefulWidget {
  final Map<String,dynamic> order;
  OrderDetailsPage({super.key, required this.order});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  Map<String,dynamic> _order = {};
  List<Map<String, dynamic>> _unloadings = [];
  DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _order = widget.order;
    getUnloadings();

  }
  Future<void> getUnloadings()async{
    List<Map<String, dynamic>> unloadings = await databaseService.fetchUnloadingSchedules(_order['id']);
    setState(() {
      _unloadings=unloadings;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 150),
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
                  child: LayoutBuilder(
                      builder: (context,constraints) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black), // Create a simple border
                              borderRadius: BorderRadius.circular(10), // Define border radius
                            ),
                            child: (_unloadings.isEmpty)
                                ?Container(
                                  height: constraints.maxHeight,
                                  child: Center(
                                    child: CircularProgressIndicator(color: Colors.green[700],),
                                  ),
                                )
                                :Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order Details',
                                  style: TextStyle(
                                    fontFamily: 'Itim',
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                orderStatus(constraints),
                                SizedBox(height:20),
                                completeDelivery(),


                              ],
                            ),
                          ),
                        );
                      }
                  ),
                )
              ],
            ) 
            
          )
        ],
      ),
    );
  }


  Widget orderStatus(constraints) {
    return SizedBox(
      height: constraints.maxHeight*0.8, // Constrain the height
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            orderConfirmTile(constraints),
            assignTile(constraints),
            loadingTile(constraints),
            ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: _unloadings.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> unload = _unloadings[index];
                if(index==_unloadings.length-1){
                  return lastUnloadingTile(constraints, unload);
                }else{
                  return unloadingTile(constraints, unload);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget completeDelivery(){
    Map<String, dynamic> lastUnload = _unloadings[_unloadings.length-1];
    bool isComplete = lastUnload['deliveryStatus'] =='Delivered!';
    return Container(
        child: Row(
          children: [
            Icon(
              isComplete?Icons.check_circle:Icons.timer,
              color: isComplete? Colors.green[700]!:Colors.grey[700]!,),
            Text(
              isComplete? 'Order ${_order['id']} Completed!': 'Order ${_order['id']} In Progress...',
              style: TextStyle(
                color: isComplete? Colors.green[700]!:Colors.grey[700]!,
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        )
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


  Widget orderConfirmTile(constraints){
    double tileheight =constraints.maxHeight *0.125;
    bool isConfirmed =_order['confirmed_status']==true;
    return SizedBox(
      height: tileheight-6,
      child: TimelineTile(
        isFirst: true,
        endChild: statusContainer(
          isConfirmed ? "Order Confirmed" : "Order Not Yet Confirmed",
          isConfirmed ? _order["filed_date"] : "confirmation in progress",
          isConfirmed,
        ),
        indicatorStyle: IndicatorStyle(
          width: 40,
          height: 40,
          color: isConfirmed ? Colors.blue[700]! : Colors.grey[700]!,
          iconStyle: IconStyle(
            color: Colors.white,
            iconData: Icons.assignment,
          ),
        ),
        afterLineStyle: LineStyle(
          color: isConfirmed ? Colors.blue[700]! : Colors.grey[700]!,
          thickness: 6,
        ),
      ),
    );
  }

  Widget assignTile(constraints){
    double tileheight =constraints.maxHeight *0.125;
    bool isAssigned = _order['assignedStatus']=='true';

    return SizedBox(
      height:tileheight,
      child: TimelineTile(
        endChild: statusContainer(
            isAssigned? "Order Assigned": "Order Not Yet Assigned",
            isAssigned? _order["filed_date"]:"assignment in process",
            isAssigned? true: false),
        indicatorStyle: IndicatorStyle(
          width: 40,
          height: 40,
          color: isAssigned?Colors.blue[700]! : Colors.grey[700]!,
          iconStyle: IconStyle(
            color: Colors.white,
            iconData: Icons.local_shipping,
          ),
        ),
        beforeLineStyle: LineStyle(
          color: isAssigned?Colors.blue[700]! : Colors.grey[700]!,
          thickness: 6,
        ),
        afterLineStyle: LineStyle(
          color: isAssigned?Colors.blue[700]! : Colors.grey[700]!,
          thickness: 6,
        ),
      ),
    );
  }

  Widget loadingTile(constraints){
    double tileheight =constraints.maxHeight *0.125;
    bool isLoaded = _order['loadingStatus']=='Loaded!';
    bool isAssigned = _order['assignedStatus']=='true';

    return SizedBox(
      height:tileheight,
      child: TimelineTile(
        endChild: statusContainer(
            isLoaded? "${_order["loading_id"]} Loaded":
            (isAssigned? "Loading ${_order["loading_id"]}...": "Order Not Yet Assigned"),
            isLoaded? _order["loadingDate"]: (isAssigned?"loading in progress":'order in progress'),
            isLoaded? true: false),
        indicatorStyle: IndicatorStyle(
          width: 40,
          height: 40,
          color: isLoaded?Colors.blue[700]!:Colors.grey[700]!,
          iconStyle: IconStyle(
            color: Colors.white,
            iconData:  Icons.featured_video,
          ),
        ),
        beforeLineStyle: LineStyle(
          color: isLoaded?Colors.blue[700]!:Colors.grey[700]!,
          thickness: 6,
        ),
        afterLineStyle: LineStyle(
          color: isLoaded?Colors.blue[700]!:Colors.grey[700]!,
          thickness: 6,
        ),
      ),
    );
  }

  Widget unloadingTile(constraints, Map<String, dynamic> unload){
    var date = unload['unloadingTimestamp'].toDate();
    var unloadDate = DateFormat('MMM dd, yyyy').format(date);
    double tileheight =constraints.maxHeight *0.125;

    bool isDelivered = unload['deliveryStatus']=='Delivered!';
    bool isAssigned = _order['assignedStatus']=='true';

    return SizedBox(
      height:tileheight,
      child: TimelineTile(
        endChild: statusContainer(
          isDelivered? " ${unload['unloadId']} Delivered!":
          (isAssigned? '${unload['unloadId']}  ${unload['deliveryStatus']}': 'Order Not Yet Assigned'),
            isDelivered? unloadDate:(isAssigned?"delivery in progress":"order in progress"),
            isDelivered?true:false),
        indicatorStyle: IndicatorStyle(
          width: 40,
          height: 40,
          color: isDelivered?Colors.blue[700]!:Colors.grey[700]!,
          iconStyle: IconStyle(
            color: Colors.white,
            iconData: Icons.featured_play_list_rounded,
          ),
        ),
        beforeLineStyle: LineStyle(
          color: isDelivered?Colors.blue[700]!:Colors.grey[700]!,
          thickness: 6,
        ),
        afterLineStyle: LineStyle(
          color: isDelivered?Colors.blue[700]!:Colors.grey[700]!,
          thickness: 6,
        ),
      ),
    );
  }

  Widget lastUnloadingTile(constraints, Map<String, dynamic> unload){
    var date = unload['unloadingTimestamp'].toDate();
    var unloadDate = DateFormat('MMM dd, yyyy').format(date);
    double tileheight =constraints.maxHeight *0.125;

    bool isDelivered = unload['deliveryStatus']=='Delivered!';
    bool isAssigned = _order['assignedStatus']=='true';
    return SizedBox(
      height:tileheight,
      child: TimelineTile(
        isLast: true,
        endChild: statusContainer(
            isDelivered? " ${unload['unloadId']} Delivered!":
            (isAssigned? '${unload['unloadId']}  ${unload['deliveryStatus']}': 'Order Not Yet Assigned'),
            isDelivered? unloadDate:(isAssigned?"delivery in progress":"order in progress"),
            isDelivered?true:false),
        indicatorStyle: IndicatorStyle(
          width: 40,
          height: 40,
          color: isDelivered?Colors.blue[700]!:Colors.grey[700]!,
          iconStyle: IconStyle(
            color: Colors.white,
            iconData: Icons.featured_play_list_rounded,
          ),
        ),
        beforeLineStyle: LineStyle(
          color: isDelivered?Colors.blue[700]!:Colors.grey[700]!,
          thickness: 6,
        ),
        afterLineStyle: LineStyle(
          color: isDelivered?Colors.blue[700]!:Colors.grey[700]!,
          thickness: 6,
        ),
      ),
    );
  }

  Widget statusContainer(String title, String subtitle, bool stat){
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Container(
          child: Column( // Wrap Row with Column
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center, // Center the contents vertically
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(subtitle,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(
                    (stat) ? Icons.check_circle_outline_outlined : Icons.timer,
                    color: (stat) ? Colors.green[700] : Colors.grey[700],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}