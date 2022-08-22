import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:webandcraft/models/employee_model.dart';

class SQLiteDbProvider {
  SQLiteDbProvider._();
  static final SQLiteDbProvider db = SQLiteDbProvider._();
  static Database? _database;

  Future<dynamic> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database as Database;
  }

  initDB() async {
    String path = join(await getDatabasesPath(), "employee.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE employee_table(id INTEGER PRIMARY KEY, name TEXT,username TEXT,email TEXT,profile_image TEXT,addressid INTEGER,phone TEXT,website TEXT,companyid INTEGER)");
      await db.execute(
          "CREATE TABLE address_table(id INTEGER PRIMARY KEY,street TEXT,suite TEXT, city TEXT,zipcode TEXT,geolat TEXT,geolong TEXT)");
      await db.execute(
          "CREATE TABLE company_table(id INTEGER PRIMARY KEY,name TEXT,catchPhrase TEXT, bs TEXT)");
    });
  }

  Future<int> getCount() async {
    final db = await (database);
    List<Map> results =
        await db.rawQuery("SELECT COUNT(*) as tot FROM employee_table");
    return results[0]['tot'];
  }

  Future<void> insert(Employee emp) async {
    final db = await database;
    int companyId = 0;
    if (emp.company != null) {
      companyId = await db.insert(
        "company_table",
        emp.company!.toJson(),
      );
    }
    int addressId = 0;
    if (emp.address != null) {
      addressId = await db.insert(
        "address_table",
        emp.address!.toJson(),
      );
    }
    int empid =
        await db.insert("employee_table", emp.toJson(companyId, addressId));
    print(empid);
  }

  Future<List<Map<String, dynamic>>> getEmpData() async {
    final db = await (database);
    List<Map<String, dynamic>> results =
        await db.rawQuery("SELECT * FROM employee_table");
    List<Map<String, dynamic>> response = [];
    for (var i in results) {
      Map<String, dynamic> map = {
        "id": i["id"],
        'name': i["name"],
        'username': i["username"],
        'email': i["email"] ?? "",
        'profile_image': i["profile_image"],
        'address': {},
        'phone': i["phone"],
        'website': i["website"],
        'company': {}
      };

      int companyid = i["companyid"];
      if (companyid == 0) {
        map["company"] = null;
      } else {
        List<Map> c = await db
            .rawQuery("SELECT * FROM company_table where id = $companyid");
        map["company"] = c.first;
      }
      int addressid = i["addressid"];
      if (addressid == 0) {
        map["addressid"] = null;
      } else {
        List<Map> a = await db
            .rawQuery("SELECT * FROM address_table where id = $addressid");
        map["address"] = a.first;
      }
      response.add(map);
    }
    return response;
  }
}
