class OrderDetails{
  String? oID;
  String? customer;
  String? cargoType;
  int? totalquantity;
  int? weight;
  var date_filed;
  String? status;

  OrderDetails (String orderID, {
    this.oID,
    this.customer,
    this.cargoType,
    this.totalquantity,
    this.weight,
    this.date_filed,
    this.status
  });

  Map<String, dynamic> toList() {
    return{ 
    'Order ID': oID,
    'customer': customer,
    'cargoType': cargoType,
    'totalquantity': totalquantity,
    'weight': weight,
    'date_filed': date_filed,
    'status': status
    };
  }

}

class OrderLoading{
  //String? oID; // order ID
  String loadID; //loading ID
  String company_name;
  String point_person;
  String email;
  String phone;
  String location;
  String status;
  DateTime time;
  DateTime date;
  String? notes;

  OrderLoading (String orderID, {
    //this.oID,
    required this.loadID,
    required this.company_name,
    required this.point_person,
    required this.email,
    required this.phone,
    required this.location,
    required this.status,
    required this.time,
    required this.date,
    this.notes
  });

  Map<String, dynamic> toList() {
    return{ 
      //'order_id' : orderID,
      'company_name': company_name,
      'point_person': point_person,
      'email': email,
      'phone': phone,
      'notes': notes,
      'location' : location,
      'status' :status,
      'time' :time,
      'date' :date,
      'note' :notes
    };
  }
}

class OrderUnloading{
  //String? oID;
  //String? loadID;
  String? unloadID; //unloading ID
  String recipient;
  int reference_num;
  int quantity;
  int weight;
  String unloadingLocation;
  DateTime unloadingDate;

  OrderUnloading(String orderID, String loadID,{
    this.unloadID,
    required this.recipient,
    required this.reference_num,
    required this.quantity,
    required this.weight,
    required this.unloadingLocation,
    required this.unloadingDate
  });

  Map<String, dynamic> toList() {
    return{ 
      //'order_id' : orderID,
    'unload_id' : unloadID,
    'recipient' : recipient,
    'ref_no' : reference_num,
    'quantity': quantity,
    'weight': weight,
    'unloadingLocation' : unloadingLocation,
    'unloadingDate': unloadingDate
    };
  }
  
}