import 'package:flutter/material.dart';

class AddTruck extends StatefulWidget {
  const AddTruck({super.key});

  @override
  State<AddTruck> createState() => _AddTruckState();
}

class _AddTruckState extends State<AddTruck> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Truck'),
      ),
      body: Column(
        children: [
          const Center(
            child: Text('Add Truck to List'),
          ),
          ElevatedButton(
            onPressed: (){
              showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                content: addTruckDialog()
              );
            },
          );
            }, 
            child: const Text('Add Truck')
          )
        ],
      ),
    );
  }
}


Widget addTruckDialog(){
  return Container(
    width: 700,
    height: 750,
    //color: Colors.blue,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15.0),
      color: Colors.white,
    ),
    child: Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            //color: Colors.green,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black, )
              )
            ),
            margin: EdgeInsets.symmetric(horizontal: 30),
            padding: EdgeInsets.fromLTRB(25, 16, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/logo2_trans.png'),
                const SizedBox(width: 50,),
                Container(
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: Colors.black)
                  // ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text('Add Truck Form',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter' 
                      ),
                      ),
                      Text('Please fill in this form the necessary information about \nthe new truck to be added to the list.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'InriaSans' 
                      ),
                      )
                    ],
                  ),
                )
              ],
            )
          ),
        ),
        Expanded(
          flex:6,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                padding: EdgeInsets.all(16),
                width: 700,
                height: 250,
                color: Colors.green,
                child: Row(
                  children: [
                    // Truck name, type, max capacity, cargo type

                    //Truck pic upload
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                width: 700,
                height: 250,
                color: Colors.amber
              )
            ],
          )
        )
      ],
    )
  );
}