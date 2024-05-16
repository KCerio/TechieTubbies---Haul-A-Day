import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haul_a_day_web/homepage/deliveryInformation.dart';
import 'package:haul_a_day_web/homepage/unloadingDelivery.dart';
import 'addUnloadingDelivery.dart';
import 'editUnloadingDelivery.dart';
import 'tabs.dart';


class DeliveryHomePage extends StatefulWidget {
  @override
  _DeliveryHomePageState createState() => _DeliveryHomePageState();
}

class _DeliveryHomePageState extends State<DeliveryHomePage>  with TickerProviderStateMixin {
  late TabController _orderTabs;
  List<bool> _isDisabled = [true, false, false, false];
  Delivery delivery= Delivery.nullDelivery();

  final _formField = GlobalKey<FormState>();
  final _formField2 = GlobalKey<FormState>();


  //controllers customer information
  TextEditingController _customerName = TextEditingController();
  TextEditingController _pointPerson = TextEditingController();
  TextEditingController _contactInformation = TextEditingController();
  TextEditingController _emailAddress = TextEditingController();
  TextEditingController _note = TextEditingController();

  //controllers loadingInformation
  TextEditingController _loadingDate = TextEditingController();
  TextEditingController _loadingTime = TextEditingController();
  TextEditingController _loadingRoute = TextEditingController();
  TextEditingController _loadingLocation = TextEditingController();
  TextEditingController _loadingWarehouse = TextEditingController();
  String _loadingCargoType = '';
  TextEditingController _loadingCartons = TextEditingController();
  TextEditingController _loadingWeight = TextEditingController();

 


  @override
  void initState() {
    super.initState();
    _orderTabs = TabController(length: 4, vsync: this);
    _orderTabs.addListener(() {onTap();});
  }

  void onTap() {
    if (!_isDisabled[_orderTabs.index]) {
      int index = _orderTabs.previousIndex;
      setState(() {
        _orderTabs.index = index;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Incomplete Information'),
            backgroundColor: Colors.white,
            content: Text('Please fill out the delivery information before proceeding.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 60,
            vertical: 60
        ),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/orderBackground.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: orderForm(),
      ),
    );
  }

  Widget orderForm(){
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue[700], // Set the background color
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), // Round the top-left corner
              topRight: Radius.circular(20), // Round the top-right corner
            ), // Set the rounded edges
          ),
          child: Center(
            child: Text(
              'Customer Order Form',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20
              ),
            ),
          ),

        ),
        Container(
            padding: EdgeInsets.only(top: 30, left: 60, right: 60),
            decoration: BoxDecoration(
              color: Colors.white,
            ),child: TabBar(
          controller: _orderTabs,
          indicatorColor: Colors.blue[700],
          indicatorWeight: 10,
          tabs: [
            Tab(text: 'Delivery Information'),
            Tab(text: 'Loading Information'),
            Tab(text: 'Unloading Information'),
            Tab(text: 'Submit Delivery'),
          ],
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700]
          ),
          labelColor: Colors.blue[700],

        )),
        if(_orderTabs.index==2)
          deliveryInformation(context),
        if(_orderTabs.index==1)
          loadingInformation(context),
        if(_orderTabs.index==0)
          unloadingDeliveryList(context),



        //INSERT HERE
      ],
    );
  }

  Widget deliveryInformation(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      height:MediaQuery.sizeOf(context).height*0.57,
      width:MediaQuery.sizeOf(context).width*0.95,
      decoration:BoxDecoration(
        color: Color(0xffCEDCF0),
        borderRadius:BorderRadius.only(
          bottomLeft: Radius.circular(20), // Round the top-left corner
          bottomRight: Radius.circular(20), // Round the top-right corner
        ),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formField,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer Name or Company Name',
                style:TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Segoe UI',
                  color: Color(0xff5A5A5A),
                ),
              ),
              TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return "Enter Customer or Company Name";
                  }
                  return null;
                },

                controller: _customerName,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.business),
                  hintText: 'company or customer name',
                  hintStyle: TextStyle(
                    color: Color(0xff5A5A5A),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(height: 30),

              Text(
                'Point Person',
                style:TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Segoe UI',
                  color: Color(0xff5A5A5A),
                ),
              ),
              TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return "Enter Name of Point Person";
                  }
                  return null;
                },
                controller: _pointPerson,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'name of point person',
                  hintStyle: TextStyle(
                    color: Color(0xff5A5A5A),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(height: 30),

              Text(
                'Contact Information',
                style:TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Segoe UI',
                  color: Color(0xff5A5A5A),
                ),
              ),
              TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return "Enter Contact Number";
                  }else{
                    bool  isValidName = RegExp(r'^09\d{9}').hasMatch(value);
                    if(!isValidName){
                      return "Invalid contact number";
                    }
                  }
                  return null;
                },

                controller: _contactInformation,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  hintText: '09xxxxxxxxx',
                  hintStyle: TextStyle(
                    color: Color(0xff5A5A5A),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(height: 30),

              Text(
                'Email Address',
                style:TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Segoe UI',
                  color: Color(0xff5A5A5A),
                ),
              ),
              TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return "Enter Email Address";
                  }else{
                    bool  isValidName = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
                    if(!isValidName){
                      return "Invalid email  address";
                    }
                  }
                  return null;
                },
                controller: _emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: 'abc@xyz.com',
                  hintStyle: TextStyle(
                    color: Color(0xff5A5A5A),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(height: 30),

              Text(
                'Delivery Note',
                style:TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Segoe UI',
                  color: Color(0xff5A5A5A),
                ),
              ),
              TextFormField(
                controller: _note,
                maxLines: null,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.note_alt_outlined),
                  hintText: 'anything we need to note during delivery',
                  hintStyle: TextStyle(
                    color: Color(0xff5A5A5A),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(height: 30),

              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    if(_formField.currentState!.validate()){
                      delivery.company_name= _customerName.text.trim();
                      delivery.phone= _contactInformation.text.trim();
                      delivery.point_person= _pointPerson.text.trim();
                      delivery.customer_email= _emailAddress.text.trim();
                      delivery.note= (_note.text.isEmpty)?'none':_note.text.trim();

                      //make next tab true
                      _isDisabled[1]= true;

                      setState(() {
                        _orderTabs.animateTo(1);
                        _orderTabs.index = 1;
                      });



                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.sim_card_alert_outlined, color: Colors.red,),
                              SizedBox(width: 5),
                              Text('Please correctly fill out all necessary fields to continue'),
                            ],
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Next',
                        style:TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff3871C1),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  Widget loadingInformation(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      height: MediaQuery.of(context).size.height * 0.57,
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: BoxDecoration(
        color: Color(0xffCEDCF0),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formField2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Loading Date and Time',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Segoe UI',
                  color: Color(0xff5A5A5A),
                ),
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1, // Adjust the flex value as needed
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty){
                          return "Enter Loading Date";
                        }else{
                          bool  isValid = RegExp(r'^(0[1-9]|1[0-2])/(0[1-9]|1\d|2\d|3[01])/(19|20)\d{2}$').hasMatch(value);
                          if(!isValid){
                            return "Invalid loading date must be in MM/DD/YYYY format";
                          }
                        }
                        return null;
                      },
                      controller: _loadingDate,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_month),
                        hintText: 'MM/DD/YYYY',
                        hintStyle: TextStyle(
                          color: Color(0xff5A5A5A),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Add some spacing between the text fields
                  Flexible(
                    flex: 1, // Adjust the flex value as needed
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty){
                          return "Enter Loading Time";
                        }else{
                          bool  isValid = RegExp(r'^(0[1-9]|1[0-2]):[0-5][0-9] (AM|PM)$').hasMatch(value);
                          if(!isValid){
                            return "Invalid loading time must be in 00:00 MM format";
                          }
                        }
                        return null;
                      },
                      controller: _loadingTime,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_clock),
                        hintText: '00:00 AM',
                        hintStyle: TextStyle(
                          color: Color(0xff5A5A5A),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              Text(
                'Route',
                style:TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Segoe UI',
                  color: Color(0xff5A5A5A),
                ),
              ),
              TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return "Enter Loading Route";
                  }
                  return null;
                },
                controller: _loadingRoute,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.route),
                  hintText: 'route of delivery',
                  hintStyle: TextStyle(
                    color: Color(0xff5A5A5A),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(height: 30),

              Text(
                'Loading Location',
                style:TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Segoe UI',
                  color: Color(0xff5A5A5A),
                ),
              ),
              TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return "Enter loading location";
                  }
                  return null;
                },
                controller: _loadingLocation,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_city),
                  hintText: 'loading location',
                  hintStyle: TextStyle(
                    color: Color(0xff5A5A5A),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(height: 30),

              Text(
                'Warehouse',
                style:TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Segoe UI',
                  color: Color(0xff5A5A5A),
                ),
              ),
              TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return "Enter Warehouse";
                  }
                  return null;
                },
                controller: _loadingWarehouse,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.warehouse),
                  hintText: 'warehouse',
                  hintStyle: TextStyle(
                    color: Color(0xff5A5A5A),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(height: 30),

              Text(
                'Cargo Type',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Segoe UI',
                  color: Color(0xff5A5A5A),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Shadow color
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20.0), // Match the border radius
                ),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.local_shipping),
                    hintText: 'select type of cargo',
                    hintStyle: TextStyle(
                      color: Color(0xff5A5A5A),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'cgl',
                      child: Text('Canned Coods'),
                    ),
                    DropdownMenuItem(
                      value: 'fgl',
                      child: Text('Frozen Goods'),
                    ),
                    // Add more items here
                  ],
                  onChanged: (newValue) {
                    setState(() {
                      _loadingCargoType = newValue as String;
                    });
                  },
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Please select a position';
                    }
                    return null;
                  },

                ),
              ),
              SizedBox(height: 30),

              Text(
                'Cargo Details',
                style:TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Segoe UI',
                  color: Color(0xff5A5A5A),
                ),
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1, // Adjust the flex value as needed
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty){
                          return "Enter total number of cartons to be loaded";
                        }else{
                          bool  isValid = RegExp(r'^[1-9]\d*$').hasMatch(value);
                          if(!isValid){
                            return "Invalid number of cartons";
                          }
                        }
                        return null;
                      },
                      controller: _loadingCartons,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.gif_box),
                        hintText: 'total cartons',
                        hintStyle: TextStyle(
                          color: Color(0xff5A5A5A),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Add some spacing between the text fields
                  Flexible(
                    flex: 1, // Adjust the flex value as needed
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty){
                          return "Enter estimated weight of cargo";
                        }else{
                          bool  isValid = RegExp(r'^[1-9]\d*$').hasMatch(value);
                          if(!isValid){
                            return "Invalid weight";
                          }
                        }
                        return null;
                      },
                      controller: _loadingWeight,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.line_weight),
                        hintText: 'weight in kgs',
                        hintStyle: TextStyle(
                          color: Color(0xff5A5A5A),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),

                  ),
                ],
              ),
              SizedBox(height: 30),

              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _orderTabs.animateTo(0);
                          _orderTabs.index = 0;
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          Text(
                            'Back',
                            style:TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff3871C1),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    ElevatedButton(
                      onPressed: () {
                        if(_formField2.currentState!.validate()){

                          delivery.loadingDelivery.loadingLocation=_loadingLocation.text.trim();
                          delivery.loadingDelivery.cargoType=_loadingCargoType;
                          delivery.loadingDelivery.warehouse=_loadingWarehouse.text.trim();
                          delivery.loadingDelivery.route=_loadingRoute.text.trim();
                          delivery.loadingDelivery.totalCartons=int.parse(_loadingCartons.text.trim());
                          delivery.loadingDelivery.weight=int.parse(_loadingWeight.text.trim());
                          delivery.loadingDelivery.loadingTimeDate=convertIntoTimestamp(_loadingDate.text.trim(), _loadingTime.text.trim());

                          //make next tab true
                          _isDisabled[2]= true;

                          setState(() {
                            _orderTabs.animateTo(2);
                            _orderTabs.index =2;
                          });

                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.sim_card_alert_outlined, color: Colors.red,),
                                  SizedBox(width: 5),
                                  Text('Please correctly fill out all necessary fields to continue'),
                                ],
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Next',
                            style:TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff3871C1),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget unloadingDeliveryList(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      height: MediaQuery.of(context).size.height * 0.57,
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: BoxDecoration(
        color: Color(0xffCEDCF0),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Row(
              children: [
                SizedBox(width: 30),
                titleCard(),
                SizedBox(width: 25),
                Center(
                  child: IconButton(
                    icon: Icon(
                        Icons.add,
                      color: Colors.white,
                      size: 12,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddUnloadingDelivery(
                            onSave: (UnloadingDelivery newUnload) {
                              delivery.unloadingList.add(newUnload);
                            },
                          );
                        },
                      );
                    },
                    style: IconButton.styleFrom(
                      backgroundColor:
                      Colors.blue,
                    ),
                  ),
                ),
                SizedBox(width: 25)
              ],
            ),


            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 30),
                Expanded(
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 106)
              ],
            ),

            // KANI RA NGA ROW I-LIST BUILDER OR SUMN or ikaw gud bahala ka
            Row(
              children: [
                SizedBox(width: 30),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      'MCR Bles Foods Trading',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      '3456789',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '20',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '120',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      'Consolacion, Cebu',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      'Cebu City',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '05/12/2024',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5), // Adjust the height of the line spacing
                        Container(
                          height: 1, // Height of the line
                          margin: EdgeInsets.symmetric(horizontal: 60.0), // Horizontal margin to control line width
                          color: Colors.grey[400], // Color of the line
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 7),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.edit), // Icon to display
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditUnloadingDelivery();
                        },
                      );
                    },
                    color: Colors.grey[700], // Color of the icon
                    iconSize: 30.0, // Size of the icon
                    tooltip: 'Edit', // Tooltip text displayed on long press
                  ),
                ),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.delete_forever), // Icon to display
                    onPressed: () {
                      // Define the action when the button is pressed
                    },
                    color: Colors.red[900], // Color of the icon
                    iconSize: 30.0, // Size of the icon
                    tooltip: 'Delete', // Tooltip text displayed on long press
                  ),
                ),
                SizedBox(width: 7)
              ],
            ),
            Row(
              children: [
                SizedBox(width: 30),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      'MCR Bles Foods Trading',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      '3456789',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '20',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '120',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      'Consolacion, Cebu',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      'Cebu City',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '05/12/2024',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5), // Adjust the height of the line spacing
                        Container(
                          height: 1, // Height of the line
                          margin: EdgeInsets.symmetric(horizontal: 60.0), // Horizontal margin to control line width
                          color: Colors.grey[400], // Color of the line
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 7),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.edit), // Icon to display
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditUnloadingDelivery();
                        },
                      );
                    },
                    color: Colors.grey[700], // Color of the icon
                    iconSize: 30.0, // Size of the icon
                    tooltip: 'Edit', // Tooltip text displayed on long press
                  ),
                ),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.delete_forever), // Icon to display
                    onPressed: () {
                      // Define the action when the button is pressed
                    },
                    color: Colors.red[900], // Color of the icon
                    iconSize: 30.0, // Size of the icon
                    tooltip: 'Delete', // Tooltip text displayed on long press
                  ),
                ),
                SizedBox(width: 7)
              ],
            ),
            Row(
              children: [
                SizedBox(width: 30),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      'MCR Bles Foods Trading',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      '3456789',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '20',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '120',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      'Consolacion, Cebu',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      'Cebu City',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '05/12/2024',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5), // Adjust the height of the line spacing
                        Container(
                          height: 1, // Height of the line
                          margin: EdgeInsets.symmetric(horizontal: 60.0), // Horizontal margin to control line width
                          color: Colors.grey[400], // Color of the line
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 7),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.edit), // Icon to display
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditUnloadingDelivery();
                        },
                      );
                    },
                    color: Colors.grey[700], // Color of the icon
                    iconSize: 30.0, // Size of the icon
                    tooltip: 'Edit', // Tooltip text displayed on long press
                  ),
                ),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.delete_forever), // Icon to display
                    onPressed: () {
                      // Define the action when the button is pressed
                    },
                    color: Colors.red[900], // Color of the icon
                    iconSize: 30.0, // Size of the icon
                    tooltip: 'Delete', // Tooltip text displayed on long press
                  ),
                ),
                SizedBox(width: 7)
              ],
            ),
            Row(
              children: [
                SizedBox(width: 30),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      'MCR Bles Foods Trading',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      '3456789',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '20',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '120',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      'Consolacion, Cebu',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      'Cebu City',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '05/12/2024',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5), // Adjust the height of the line spacing
                        Container(
                          height: 1, // Height of the line
                          margin: EdgeInsets.symmetric(horizontal: 60.0), // Horizontal margin to control line width
                          color: Colors.grey[400], // Color of the line
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 7),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.edit), // Icon to display
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditUnloadingDelivery();
                        },
                      );
                    },
                    color: Colors.grey[700], // Color of the icon
                    iconSize: 30.0, // Size of the icon
                    tooltip: 'Edit', // Tooltip text displayed on long press
                  ),
                ),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.delete_forever), // Icon to display
                    onPressed: () {
                      // Define the action when the button is pressed
                    },
                    color: Colors.red[900], // Color of the icon
                    iconSize: 30.0, // Size of the icon
                    tooltip: 'Delete', // Tooltip text displayed on long press
                  ),
                ),
                SizedBox(width: 7)
              ],
            ),
            Row(
              children: [
                SizedBox(width: 30),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      'MCR Bles Foods Trading',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      '3456789',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '20',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '120',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      'Consolacion, Cebu',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      'Cebu City',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '05/12/2024',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5), // Adjust the height of the line spacing
                        Container(
                          height: 1, // Height of the line
                          margin: EdgeInsets.symmetric(horizontal: 60.0), // Horizontal margin to control line width
                          color: Colors.grey[400], // Color of the line
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 7),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.edit), // Icon to display
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditUnloadingDelivery();
                        },
                      );
                    },
                    color: Colors.grey[700], // Color of the icon
                    iconSize: 30.0, // Size of the icon
                    tooltip: 'Edit', // Tooltip text displayed on long press
                  ),
                ),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.delete_forever), // Icon to display
                    onPressed: () {
                      // Define the action when the button is pressed
                    },
                    color: Colors.red[900], // Color of the icon
                    iconSize: 30.0, // Size of the icon
                    tooltip: 'Delete', // Tooltip text displayed on long press
                  ),
                ),
                SizedBox(width: 7)
              ],
            ),
            Row(
              children: [
                SizedBox(width: 30),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      'MCR Bles Foods Trading',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      '3456789',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '20',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '120',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      'Consolacion, Cebu',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      'Cebu City',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '05/12/2024',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5), // Adjust the height of the line spacing
                        Container(
                          height: 1, // Height of the line
                          margin: EdgeInsets.symmetric(horizontal: 60.0), // Horizontal margin to control line width
                          color: Colors.grey[400], // Color of the line
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 7),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.edit), // Icon to display
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditUnloadingDelivery();
                        },
                      );
                    },
                    color: Colors.grey[700], // Color of the icon
                    iconSize: 30.0, // Size of the icon
                    tooltip: 'Edit', // Tooltip text displayed on long press
                  ),
                ),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.delete_forever), // Icon to display
                    onPressed: () {
                      // Define the action when the button is pressed
                    },
                    color: Colors.red[900], // Color of the icon
                    iconSize: 30.0, // Size of the icon
                    tooltip: 'Delete', // Tooltip text displayed on long press
                  ),
                ),
                SizedBox(width: 7)
              ],
            ),
            Row(
              children: [
                SizedBox(width: 30),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      'MCR Bles Foods Trading',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      '3456789',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '20',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '120',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      'Consolacion, Cebu',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      'Cebu City',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '05/12/2024',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5), // Adjust the height of the line spacing
                        Container(
                          height: 1, // Height of the line
                          margin: EdgeInsets.symmetric(horizontal: 60.0), // Horizontal margin to control line width
                          color: Colors.grey[400], // Color of the line
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 7),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.edit), // Icon to display
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditUnloadingDelivery();
                        },
                      );
                    },
                    color: Colors.grey[700], // Color of the icon
                    iconSize: 30.0, // Size of the icon
                    tooltip: 'Edit', // Tooltip text displayed on long press
                  ),
                ),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.delete_forever), // Icon to display
                    onPressed: () {
                      // Define the action when the button is pressed
                    },
                    color: Colors.red[900], // Color of the icon
                    iconSize: 30.0, // Size of the icon
                    tooltip: 'Delete', // Tooltip text displayed on long press
                  ),
                ),
                SizedBox(width: 7)
              ],
            ),
            Row(
              children: [
                SizedBox(width: 30),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      'MCR Bles Foods Trading',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      '3456789',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '20',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '120',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      'Consolacion, Cebu',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      'Cebu City',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '05/12/2024',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5), // Adjust the height of the line spacing
                        Container(
                          height: 1, // Height of the line
                          margin: EdgeInsets.symmetric(horizontal: 60.0), // Horizontal margin to control line width
                          color: Colors.grey[400], // Color of the line
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 7),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.edit), // Icon to display
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditUnloadingDelivery();
                        },
                      );
                    },
                    color: Colors.grey[700], // Color of the icon
                    iconSize: 30.0, // Size of the icon
                    tooltip: 'Edit', // Tooltip text displayed on long press
                  ),
                ),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.delete_forever), // Icon to display
                    onPressed: () {
                      // Define the action when the button is pressed
                    },
                    color: Colors.red[900], // Color of the icon
                    iconSize: 30.0, // Size of the icon
                    tooltip: 'Delete', // Tooltip text displayed on long press
                  ),
                ),
                SizedBox(width: 7)
              ],
            ),
            Row(
              children: [
                SizedBox(width: 30),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      'MCR Bles Foods Trading',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      '3456789',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '20',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '120',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      'Consolacion, Cebu',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      'Cebu City',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '05/12/2024',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5), // Adjust the height of the line spacing
                        Container(
                          height: 1, // Height of the line
                          margin: EdgeInsets.symmetric(horizontal: 60.0), // Horizontal margin to control line width
                          color: Colors.grey[400], // Color of the line
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 7),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.edit), // Icon to display
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditUnloadingDelivery();
                        },
                      );
                    },
                    color: Colors.grey[700], // Color of the icon
                    iconSize: 30.0, // Size of the icon
                    tooltip: 'Edit', // Tooltip text displayed on long press
                  ),
                ),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.delete_forever), // Icon to display
                    onPressed: () {
                      // Define the action when the button is pressed
                    },
                    color: Colors.red[900], // Color of the icon
                    iconSize: 30.0, // Size of the icon
                    tooltip: 'Delete', // Tooltip text displayed on long press
                  ),
                ),
                SizedBox(width: 7)
              ],
            ),
            Row(
              children: [
                SizedBox(width: 30),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      'MCR Bles Foods Trading',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      '3456789',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '20',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '120',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      'Consolacion, Cebu',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      'Cebu City',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '05/12/2024',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5), // Adjust the height of the line spacing
                        Container(
                          height: 1, // Height of the line
                          margin: EdgeInsets.symmetric(horizontal: 60.0), // Horizontal margin to control line width
                          color: Colors.grey[400], // Color of the line
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 7),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.edit), // Icon to display
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditUnloadingDelivery();
                        },
                      );
                    },
                    color: Colors.grey[700], // Color of the icon
                    iconSize: 30.0, // Size of the icon
                    tooltip: 'Edit', // Tooltip text displayed on long press
                  ),
                ),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.delete_forever), // Icon to display
                    onPressed: () {
                      // Define the action when the button is pressed
                    },
                    color: Colors.red[900], // Color of the icon
                    iconSize: 30.0, // Size of the icon
                    tooltip: 'Delete', // Tooltip text displayed on long press
                  ),
                ),
                SizedBox(width: 7)
              ],
            ),
            Row(
              children: [
                SizedBox(width: 30),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      'MCR Bles Foods Trading',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      '3456789',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '20',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '120',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      'Consolacion, Cebu',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      'Cebu City',
                                      style: TextStyle(

                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      10.0), // Optional inner padding
                                  child: Center(
                                    child: Text(
                                      '05/12/2024',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ), // Replace with your content
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5), // Adjust the height of the line spacing
                        Container(
                          height: 1, // Height of the line
                          margin: EdgeInsets.symmetric(horizontal: 60.0), // Horizontal margin to control line width
                          color: Colors.grey[400], // Color of the line
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 7),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.edit), // Icon to display
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditUnloadingDelivery();
                        },
                      );
                    },
                    color: Colors.grey[700], // Color of the icon
                    iconSize: 30.0, // Size of the icon
                    tooltip: 'Edit', // Tooltip text displayed on long press
                  ),
                ),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.delete_forever), // Icon to display
                    onPressed: () {
                      // Define the action when the button is pressed
                    },
                    color: Colors.red[900], // Color of the icon
                    iconSize: 30.0, // Size of the icon
                    tooltip: 'Delete', // Tooltip text displayed on long press
                  ),
                ),
                SizedBox(width: 7)
              ],
            ),


            Row(
              children: [
                SizedBox(width: 30),
                Expanded(
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 106)
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget titleCard(){
    return Expanded(
      child: Container(
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

  Widget unloadContainer(UnloadingDelivery unload){
    return Row(
      children: [
        SizedBox(width: 30),
        Expanded(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              'MCR Bles Foods Trading',
                              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              '3456789',
                              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(
                              10.0), // Optional inner padding
                          child: Center(
                            child: Text(
                              '20',
                              style: TextStyle(

                                  fontSize: 16, color: Colors.grey[500]),
                              overflow: TextOverflow.ellipsis,
                            ), // Replace with your content
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(
                              10.0), // Optional inner padding
                          child: Center(
                            child: Text(
                              '120',
                              style: TextStyle(

                                  fontSize: 16, color: Colors.grey[500]),
                              overflow: TextOverflow.ellipsis,
                            ), // Replace with your content
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(
                              10.0), // Optional inner padding
                          child: Center(
                            child: Text(
                              'Consolacion, Cebu',
                              style: TextStyle(

                                  fontSize: 16, color: Colors.grey[500]),
                              overflow: TextOverflow.ellipsis,
                            ), // Replace with your content
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(
                              10.0), // Optional inner padding
                          child: Center(
                            child: Text(
                              'Cebu City',
                              style: TextStyle(

                                  fontSize: 16, color: Colors.grey[500]),
                              overflow: TextOverflow.ellipsis,
                            ), // Replace with your content
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                              10.0), // Optional inner padding
                          child: Center(
                            child: Text(
                              '05/12/2024',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[500]),
                              overflow: TextOverflow.ellipsis,
                            ), // Replace with your content
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5), // Adjust the height of the line spacing
                Container(
                  height: 1, // Height of the line
                  margin: EdgeInsets.symmetric(horizontal: 60.0), // Horizontal margin to control line width
                  color: Colors.grey[400], // Color of the line
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 7),
        Center(
          child: IconButton(
            icon: Icon(Icons.edit), // Icon to display
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return EditUnloadingDelivery();
                },
              );
            },
            color: Colors.grey[700], // Color of the icon
            iconSize: 30.0, // Size of the icon
            tooltip: 'Edit Delivery', // Tooltip text displayed on long press
          ),
        ),
        Center(
          child: IconButton(
            icon: Icon(Icons.delete_forever), // Icon to display
            onPressed: () {
              // Define the action when the button is pressed
            },
            color: Colors.red[900], // Color of the icon
            iconSize: 30.0, // Size of the icon
            tooltip: 'Delete Delivery', // Tooltip text displayed on long press
          ),
        ),
        SizedBox(width: 7)
      ],
    );
  }

  Timestamp convertIntoTimestamp(String date, String time){
    try {
      List<String> dateParts = date.split('/'); // Split the string into parts
      int month = int.parse(dateParts[0]);
      int day = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);

      // Parse the time string
      List<String> timeParts = time.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1].split(' ')[0]);
      String meridiem = timeParts[1].split(' ')[1];

      if (meridiem == 'PM') {
        hour += 12; // Add 12 hours for PM times
      }

      DateTime dateTime = DateTime(year, month, day, hour, minute); // Create a DateTime object
      Timestamp timestamp = Timestamp.fromDate(dateTime);

      print("Timestamp: $timestamp");

      return timestamp;


    } catch (e) {
      print("Error parsing date: $e");
    }
    return Timestamp(0,0);

  }


}