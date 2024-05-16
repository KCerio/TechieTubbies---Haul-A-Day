import 'package:cloud_firestore/cloud_firestore.dart';

class Delivery{
   String orderId;
   String company_name;
   String customer_email;
   Timestamp dateFiled;
   String phone;
   String point_person;
   String note;
   LoadingDelivery loadingDelivery;
   List<UnloadingDelivery> unloadingList;

  Delivery(
      this.company_name,
      this.customer_email,
      this.dateFiled,
      this.phone,
      this.point_person,
      this.note,
      this.loadingDelivery,
      this.orderId,
      this.unloadingList);

   Delivery.nullDelivery()
       : orderId = '',
         company_name = '',
         customer_email = '',
         dateFiled = Timestamp(0, 0),
         phone = '',
         point_person = '',
         note = '',
         loadingDelivery = LoadingDelivery.nullDelivery(),
         unloadingList = [];


}

class LoadingDelivery{
   Timestamp loadingTimeDate;
   String cargoType;
   String loadingLocation;
   String route;
   String warehouse;
   int totalCartons;
   int weight;

  LoadingDelivery(
      this.cargoType,
      this.loadingLocation,
      this.route,
      this.warehouse,
      this.totalCartons,
      this.loadingTimeDate,
      this.weight);

   LoadingDelivery.nullDelivery()
       : cargoType ='',
         loadingLocation='',
         route='',
         warehouse='',
         totalCartons=-1,
         loadingTimeDate =Timestamp(0, 0),
         weight=-1;

}

class UnloadingDelivery{
   Timestamp unloadingTimeDate;
   int reference_num;
   String unloadingLocation;
   String route;
   String recipient;
   int quantity;
   int weight;


  UnloadingDelivery(
      this.reference_num,
      this.unloadingLocation,
      this.route,
      this.recipient,
      this.quantity,
      this.unloadingTimeDate,
      this.weight);

   UnloadingDelivery.nullDelivery()
       :reference_num=-1,
       unloadingLocation='',
       route='',
       recipient='',
       quantity=-1,
       unloadingTimeDate= Timestamp(0, 0),
       weight=-1;


}

Future<void> addDelivery(Delivery delivery) async {
  delivery.orderId=await getOrderNumber();

  FirebaseFirestore.instance.collection('Order').doc('${delivery.orderId}').set({
    'company_name':delivery.company_name,
    'customer_email':delivery.customer_email,
    'date_filed':delivery.dateFiled,
    'loading_id':'LS-${getDeliveryId(delivery.orderId)}',
    'note': delivery.note,
    'phone':delivery.phone,
    'point_person':delivery.point_person,
    'confirmed_status':false,
  });

  FirebaseFirestore.instance.collection('Order/${delivery.orderId}/LoadingSchedule').doc('LS-${getDeliveryId(delivery.orderId)}').set({
    'cargoType':(delivery.loadingDelivery.cargoType=='Frozen Goods')?'fgl':'cgl',
    'loadingLocation':delivery.loadingDelivery.loadingLocation,
    'loadingTime_Date' :delivery.loadingDelivery.loadingTimeDate,
    'route':delivery.loadingDelivery.route,
    'totalCartons':delivery.loadingDelivery.totalCartons,
    'warehouse':delivery.loadingDelivery.warehouse,
  });
  int index =1;
  for(var unloading in delivery.unloadingList){
    FirebaseFirestore.instance.collection('Order/${delivery.orderId}/LoadingSchedule/'
        'LS-${getDeliveryId(delivery.orderId)}/UnloadingSchedule')
        .doc('US-${getDeliveryId(delivery.orderId)}-$index').set({
      'quantity':unloading.quantity,
      'recipient' :unloading.recipient,
      'reference_num':unloading.reference_num,
      'unloadingLocation':unloading.unloadingLocation,
      'unloadingTimestamp':unloading.unloadingTimeDate,
      'weight':unloading.weight,
    });
    index++;
  }

}

Future<String> getOrderNumber() async {
  CollectionReference orderCollection =
  FirebaseFirestore.instance.collection('Order');

  QuerySnapshot<Object?> querySnapshot = await orderCollection.get();

  if (querySnapshot.docs.isNotEmpty) {
    int nextNumber = querySnapshot.docs.length + 1;
    String nextId = 'OR${nextNumber.toString().padLeft(3, '0')}';
    return nextId;
  } else {

    return 'OR001';
  }

}

String getDeliveryId(String orderId){
  return orderId.substring(2);
}


