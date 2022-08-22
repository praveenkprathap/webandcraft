import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webandcraft/helper/sqflite_singleton.dart';
import 'package:webandcraft/models/employee_model.dart';
import 'package:webandcraft/services/api_service.dart';
import 'package:webandcraft/view/profileDetails.dart';

class EmployeeProvider with ChangeNotifier {
  bool loader = false;
  List<Employee?> empList = [];
  List<Employee?> sList = [];
  TextEditingController searchController = TextEditingController();

  Future<void> getEmployeeListApi() async {
    loader = true;
    notifyListeners();
    try {
      Response response =
          await ApiService().getDioInstance().get(ApiService().api);
      loader = false;
      response.data.forEach((e) {
        Employee obj = Employee.fromJson(e);
        empList.add(obj);
        SQLiteDbProvider.db.insert(obj);
      });
      sList = List.from(empList);
      notifyListeners();
    } catch (error) {
      //show error toast
      loader = false;
      notifyListeners();
    }
  }

  createDataBase() async {
    await SQLiteDbProvider.db.initDB();
    int val = await SQLiteDbProvider.db.getCount();
    print(val);
    // to check whether database have any data
    if (val < 1) {
      getEmployeeListApi();
    } else {
      List<Map<String, dynamic>> results =
          await SQLiteDbProvider.db.getEmpData();
      for (var element in results) {
        Employee obj = Employee.fromJson(element);
        empList.add(obj);
      }
      sList = List.from(empList);
    }
  }

  search(String val) {
    val = val.trim();
    if (val == "") {
      sList = List.from(empList);
    } else {
      sList.clear();
      for (var e in empList) {
        if ((e!.name!.toLowerCase().contains(val.toLowerCase())) ||
            e.email!.toLowerCase().contains(val.toLowerCase())) {
          sList.add(e);
        }
      }
    }
    notifyListeners();
  }

  gotoDetailsPage(int index, context) {
    FocusScope.of(context).unfocus();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ProfileDetails(
                  emp: sList[index]!,
                )));
  }
}
