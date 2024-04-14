import 'package:flutter/cupertino.dart';

class Payroll extends StatefulWidget {
  const Payroll({super.key});

  @override
  State<Payroll> createState() => _PayrollState();
}

class _PayrollState extends State<Payroll> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Payroll content'),
      ),
    );
  }
}