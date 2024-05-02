import 'package:flutter/material.dart';
import 'package:haul_a_day_web/service/database.dart';

class AttendanceWidget extends StatefulWidget {
  final String reportId;
  final String orderId;
  final String truck;
  const AttendanceWidget({super.key, required this.reportId, required this.orderId, required this.truck});

  @override
  State<AttendanceWidget> createState() => _AttendanceWidgetState();
}

class _AttendanceWidgetState extends State<AttendanceWidget> {
  List<Map<String, dynamic>> _attendance = [];
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAttendance(widget.reportId, widget.orderId, widget.truck);
  }
  
  Future<void> fetchAttendance(String reportId,String orderId, String truck)async{
    try {
      DatabaseService databaseService = DatabaseService();
      List<Map<String, dynamic>> attendance = await databaseService.fetchAttendance(reportId, orderId, truck);
      print("database: $attendance");
      setState(() {
        _attendance = attendance;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: _attendance.length, // Replace members with your list of member data
    itemBuilder: (BuildContext context, int index) {
      return memberContainer(_attendance[index]);
    },
  );
  }
}

Widget memberContainer(Map<String, dynamic> member){
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
    width: 135,
    height: 150,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Color.fromARGB(255, 91, 188, 233),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(member['pictureUrl']),
          backgroundColor: Colors.white,
        ),
        const SizedBox(height: 20),
        Text(
          member['name'],
          style: TextStyle(
            fontFamily: 'InriaSans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        Text(
          member['position'],
          style: TextStyle(
            fontFamily: 'InriaSans',
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: Colors.white
          ),
        )
      ],
    ),
  );
}