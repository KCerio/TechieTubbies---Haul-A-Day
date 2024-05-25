
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class DeliveryHistory extends StatelessWidget {
  const DeliveryHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 30), // Adjust the width as needed
                      Align(
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
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 7),

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

              const SizedBox(height: 10),

              //CHILDREN
              Container(
                padding: EdgeInsets.only(left: 30, right: 25),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffF1FFED),
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     deliveryHistory(),
                      deliveryHistory(),
                      deliveryHistory(),

                    ],
                  )
                ),
              ),),


            ],
          ),
        ));
  }

  Widget deliveryHistory(){
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        '0R001',
                        style: TextStyle(
                            fontSize: 20, color: Colors.grey[800]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        'Virginia Corps',
                        style: TextStyle(
                            fontSize: 20, color: Colors.grey[800]),
                        overflow: TextOverflow.ellipsis,
                      ),
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
                        '01/08/2024',
                       style: TextStyle(
                             fontSize: 20, color: Colors.grey[800]),
                        overflow: TextOverflow.ellipsis,
                      ), // Replace with your content
                    ),
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
