import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/authentication/login_screen.dart';
import 'package:haul_a_day_web/homepage/homepage.dart';

import 'createOrder.dart';

Widget Tabs(int index, context){
  return Row(
    children: [
      TextButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerHomePage()));
      },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>((index==0)?Colors.blue[700]!:Colors.white),
              minimumSize: MaterialStateProperty.all<Size>(Size(100, 50)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),)
          ),
          child: Text(
            'ABOUT',
            style: TextStyle(
                color: (index==0)?Colors.white:Colors.blue[700],
                fontSize:16,
                fontWeight: FontWeight.bold
            ),

          )),
      SizedBox(width: 10,),
      TextButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>DeliveryHomePage()));
      },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>((index==1)?Colors.blue[700]!:Colors.white),
              minimumSize: MaterialStateProperty.all<Size>(Size(100, 50)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),)
          ),
          child: Text(
            'DELIVERY',
            style: TextStyle(
                color: (index==1)?Colors.white:Colors.blue[700],
                fontSize:16,
                fontWeight: FontWeight.bold
            ),

          )),
      SizedBox(width: 10,),
      TextButton(onPressed: (){},
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>((index==2)?Colors.blue[700]!:Colors.white),
              minimumSize: MaterialStateProperty.all<Size>(Size(100, 50)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),)
          ),
          child: Text(
            'CONTACT',
            style: TextStyle(
                color: (index==2)?Colors.white:Colors.blue[700],
                fontSize:16,
                fontWeight: FontWeight.bold
            ),

          )),
      SizedBox(width: 10,),
      TextButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>login_screen()));
      },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>((index==3)?Colors.blue[700]!:Colors.white),
              minimumSize: MaterialStateProperty.all<Size>(Size(100, 50)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),)
          ),
          child: Text(
            'MANAGEMENT',
            style: TextStyle(
                color: (index==3)?Colors.white:Colors.blue[700],
                fontSize:16,
                fontWeight: FontWeight.bold
            ),

          )),
    ],
  );

}

Widget orderForm(int progress, context){
  return Container(
      child: Column(
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
              color: Colors.white, // Set the background color
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                'Customer Information',
                style: TextStyle(
                    color: (progress>=25)?Colors.blue[700]:Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
                Text(
                  'Loading Information',
                  style: TextStyle(
                      color: (progress>=50)?Colors.blue[700]:Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                ),
                Text(
                  'Unloading Information',
                  style: TextStyle(
                      color: (progress>=75)?Colors.blue[700]:Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                ),
                Text(
                  'Submit Delivery',
                  style: TextStyle(
                      color: (progress==100)?Colors.blue[700]:Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                ),
              ],
            )
          ),
          Container(
            child: LinearProgressIndicator(
              value: progress / 100,
              minHeight: 10,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
            ),
          ),


        ],
      )
  );
}