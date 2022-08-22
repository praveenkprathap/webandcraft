import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webandcraft/providers/employee_provider.dart';
import 'package:webandcraft/view/employeeList.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => EmployeeProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EmployeeList(),
    );
  }
}
