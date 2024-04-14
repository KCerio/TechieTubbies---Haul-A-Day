import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String? id;
  final String staffId;
  //final String depart_id;
  final String firstname;
  final String lastname;
  final String password;
  final String userName;
  final String position;
  final Timestamp registeredDate;
  //final String contact_no;

  const UserModel({
    this.id,
    required this.staffId,
    //required this.depart_id,
    required this.firstname,
    required this.lastname,
    //required this.contact_no,
    required this.userName,
    required this.password,
    required this.position,
    required this.registeredDate,
  });

  toJson(){
    return{ 
      "staffId": staffId,
      //'depart_id': depart_id,
      'firstname' : firstname ,
      'lastname' : lastname,
      //'contact_no' : contact_no,
      'userName' :  userName,
      'password' : password,
      'position' : position,
      'registeredDate':registeredDate,

    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data();
    return UserModel(
      id: document.id,
      staffId: data?["staffId"],
      firstname: data?[ "firstname"],
      lastname: data ?["lastname"] ,
      userName: data?[ "userName"],
      password: data?[ "password"],
      position: data?["position"],
      registeredDate: data?["registeredDate"],

    );
  }
}