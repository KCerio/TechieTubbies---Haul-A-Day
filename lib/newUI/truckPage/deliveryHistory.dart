
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/newUI/truckPage/truckInfo.dart';

class DeliveryHistory extends StatefulWidget {
  final String truckId;

  DeliveryHistory({Key? key, required this.truckId}) : super(key: key);

  @override
  State<DeliveryHistory> createState() => _DeliveryHistoryState();
}

class _DeliveryHistoryState extends State<DeliveryHistory> {

  List<AccomplishedReport> deliveryList =[];


  @override
  void initState() {
    super.initState();
    _initializeTruckData();
  }

  Future<void> _initializeTruckData() async {
    try {
      deliveryList = await fetchDeliveryReports(widget.truckId);
      setState(() {});
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
           SizedBox(height: 30),
          Container(
            padding: EdgeInsets.only(left: 30),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Delivery History',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

           SizedBox(height: 7),

          //TITLE
          Row(
            children: [
              const SizedBox(width: 30),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffF1FFED),
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(
                                10.0), // Optional inner padding
                            child: Center(
                              child: Text(
                                'Delivery ID',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                    color: Colors.grey[600]),
                                overflow: TextOverflow.ellipsis,
                              ), // Replace with your content
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(
                                10.0), // Optional inner padding
                            child: Center(
                              child: Text(
                                'Customer',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                    color: Colors.grey[600]),
                                overflow: TextOverflow.ellipsis,
                              ), // Replace with your content
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: Container(

                          child: Padding(
                            padding: const EdgeInsets.all(
                                10.0), // Optional inner padding
                            child: Center(
                              child: Text(
                                'Date',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                    color: Colors.grey[600]),
                                overflow: TextOverflow.ellipsis,
                              ), // Replace with your content
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 25),
            ],
          ),

           SizedBox(height: 10),

          //CHILDREN
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffF1FFED),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: Colors.grey[400]!),
              ),
              margin: EdgeInsets.only(left:30, right: 25),
              child: deliveryList.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : (deliveryList[0].id=='none')
                  ?Center(
                child: Text(
                  'No Deliveries so far',
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),)
                  :ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                itemCount: deliveryList.length,
                itemBuilder: (context, index) {
                  AccomplishedReport report = deliveryList[index];
                  return Column(
                    children: [
                      deliveryHistory(report),
                      SizedBox(height: 5),
                    ],
                  );
                },
              ),
            ),
          ),


        ],
      ),
    );
  }

  Widget deliveryHistory(AccomplishedReport report){
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  child: Center(
                    child: Text(
                      report.id,
                      style: TextStyle(
                          fontSize: 20, color: Colors.grey[800]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Container(
                  child: Center(
                    child: Text(
                      report.customer,
                      style: TextStyle(
                          fontSize: 20, color: Colors.grey[800]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Container(

                  child: Center(
                    child: Text(
                      intoDate(report.dateAssigned),
                      style: TextStyle(
                          fontSize: 20, color: Colors.grey[800]),
                      overflow: TextOverflow.ellipsis,
                    ), // Replace with your content
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
              height: 5), // Adjust the height of the line spacing
        ],
      ),
    );
  }
}
