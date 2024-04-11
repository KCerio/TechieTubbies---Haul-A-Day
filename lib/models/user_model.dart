import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String? uid;

  User({this.uid});
}

class UserModel{
  final String? id;
  final String staffId;
  //final String depart_id;
  final String firstname;
  final String lastname;
  final String password;
  final String userName;
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
    };
  }

  // for storing data of user from database
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data();
    return UserModel(
      id: document.id,
      staffId: data?["staffId"],
      firstname: data?[ "firstname"],
      lastname: data ?["lastname"] ,
      userName: data?[ "userName"],
      password: data?[ "password"]
    );
  }
}