import 'package:flutter/material.dart';
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


  //controllers
  TextEditingController _customerName = TextEditingController();
  TextEditingController _pointPerson = TextEditingController();
  TextEditingController _contactInformation = TextEditingController();
  TextEditingController _emailAddress = TextEditingController();
  TextEditingController _note = TextEditingController();



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
          deliveryInformation(context)


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

                  if (value!.isEmpty) {
                    return "Enter Customer or Company Name";
                  } else {
                    bool  isValidEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
                    if(isValidEmail){
                      return "Enter a valid email address";
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

}