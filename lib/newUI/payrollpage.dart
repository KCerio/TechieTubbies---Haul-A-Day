import 'package:flutter/material.dart';

class StaffPayroll extends StatefulWidget {
  final Map<String, dynamic> staff;
  const StaffPayroll({super.key, required this. staff});

  @override
  State<StaffPayroll> createState() => _StaffPayrollState();
}

class _StaffPayrollState extends State<StaffPayroll> {
  Map<String, dynamic> _staff = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _staff = widget.staff;
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: double.infinity,
        child: Text(
          _staff['firstname']
        ),
      ),
    );
  }
}