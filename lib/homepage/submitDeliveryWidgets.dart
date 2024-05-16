import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/homepage/deliveryInformation.dart';
import 'package:intl/intl.dart';

Widget deliveryInfo(Delivery delivery, BuildContext context){
  return Container(
    padding: EdgeInsets.all(20),
    child: Column(
      children: [
        informationContainer('Customer or Company Name', delivery.company_name),
        informationContainer('Point Person', delivery.point_person),
        informationContainer('Contact Information', delivery.phone),
        informationContainer('Email Address', delivery.customer_email),
        if(delivery.note!='')
          informationContainer('Email Address', delivery.note),
      ],

    )
  );
}

Widget loadingInfo(Delivery delivery, BuildContext context){
  return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Flexible(flex:1,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Loading Date and Time',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Flexible(flex:1, child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey,),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  intoDate(delivery.loadingDelivery.loadingTimeDate),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  softWrap: true, // Allow text to wrap
                                ),
                              ),
                            ],
                          ),
                        ),),
                        Flexible(flex:1, child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey,),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  intoTime(delivery.loadingDelivery.loadingTimeDate),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  softWrap: true, // Allow text to wrap
                                ),
                              ),
                            ],
                          ),
                        ),)
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  informationContainer('Cargo Type', delivery.loadingDelivery.cargoType),
                  Text(
                    'Cargo Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Flexible(flex:1, child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey,),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  '${delivery.loadingDelivery.totalCartons} cartons',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  softWrap: true, // Allow text to wrap
                                ),
                              ),
                            ],
                          ),
                        ),),
                        Flexible(flex:1, child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey,),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  '${delivery.loadingDelivery.weight} kgs',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  softWrap: true, // Allow text to wrap
                                ),
                              ),
                            ],
                          ),
                        ),)
                      ],
                    ),
                  ),
                ],
              ),
              ),),
          Flexible(flex:1,
            child: Container(

              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 informationContainer('Route', delivery.loadingDelivery.route),
                  informationContainer('Warehouse', delivery.loadingDelivery.warehouse),
                  informationContainer('Loading Location', delivery.loadingDelivery.loadingLocation),
                ],
              ),
              ),)
        ],

      )
  );
}

Widget informationContainer(String title, String information) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 15,
        ),
      ),
      Container(
        //margin: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey,),
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                information,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                softWrap: true, // Allow text to wrap
              ),
            ),
          ],
        ),
      ),

      SizedBox(height: 10),
    ],
  );
}



Widget unloadingList(Delivery delivery, BuildContext context){
  return Container(
    height: MediaQuery.of(context).size.height * 0.57,
    child: Column(
      children: [
        titleCard(),
        SizedBox(height: 10,),
        Expanded(
          child: ListView.builder(
            itemCount: delivery.unloadingList.length,
            itemBuilder: (BuildContext context, int index) {
              UnloadingDelivery unload = delivery.unloadingList[index];
              return Row(
                children: [
                  insideUnload(unload.recipient),
                  insideUnload(unload.reference_num.toString()),
                  insideUnload(unload.quantity.toString()),
                  insideUnload(unload.weight.toString()),
                  insideUnload(unload.route),
                  insideUnload(unload.unloadingLocation),
                  insideUnload(intoDate(unload.unloadingTimeDate)),
                  insideUnload(intoTime(unload.unloadingTimeDate)),
                ],
              );
            },
          ),
        ),
      ],
    ),
  );
}

Widget insideUnload(String data){
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Center(
        child: Text(
          data,
          style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
  );
}

Widget titleCard(){
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5.0),
    ),
    child: Row(
      children: [
        titles('RECIPIENT'),
        titles('REF NO.'),
        titles('QUANTITY'),
        titles('WEIGHT(kg)'),
        titles('ROUTE'),
        titles('LOCATION'),
        titles('DATE'),
        titles('TIME'),
      ],
    ),
  );
}

Widget titles(String title){
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(
          10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ), // Replace with your content
      ),

    ),
  );
}

String intoDate (Timestamp timeStamp)  {
  DateTime dateTime = timeStamp.toDate(); // Convert Firebase Timestamp to DateTime
  String formattedDate = DateFormat('MMM d,yyyy').format(dateTime); // Format DateTime into date string
  return formattedDate; // Return the formatted date string
}

String intoTime (Timestamp stampTime) {
  DateTime dateTime =  stampTime.toDate();  // Convert Firebase Timestamp to DateTime
  String formattedTime = DateFormat('h:mm a').format(dateTime); // Format DateTime into time string
  return formattedTime; // Return the formatted time string
}
