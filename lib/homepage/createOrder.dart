import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haul_a_day_web/homepage/deliveryInformation.dart';
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
  TextEditingController _loadingCargoType = TextEditingController();
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
        if(_orderTabs.index==0)
          deliveryInformation(context),
        if(_orderTabs.index==1)
          loadingInformation(context),


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
                    hintText: 'Type of Cargo',
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
                      value: 'option1',
                      child: Text('Option 1'),
                    ),
                    DropdownMenuItem(
                      value: 'option2',
                      child: Text('Option 2'),
                    ),
                    // Add more items here
                  ],
                  onChanged: (String? newValue) {
                    // Handle the value change
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
                          delivery.company_name= _customerName.text.trim();
                          delivery.phone= _contactInformation.text.trim();
                          delivery.point_person= _pointPerson.text.trim();
                          delivery.customer_email= _emailAddress.text.trim();
                          delivery.note= (_note.text.isEmpty)?'none':_note.text.trim();

                          //make next tab true
                          _isDisabled[1]= true;

                          setState(() {
                            _orderTabs.animateTo(1);
                            _orderTabs.index =1;
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


}