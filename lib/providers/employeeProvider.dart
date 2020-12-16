import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class EmployeeProvider extends ChangeNotifier{
  List<dynamic> _employeeDetails;
  List<dynamic> _employeeList;

  List<dynamic> get employeeDetails => _employeeDetails;
  List<dynamic> get employeeList =>  _employeeList;

  Future<void> getAllEmployees() async {
    var url = "http://www.mocky.io/v2/5d565297300000680030a986";
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      _employeeDetails = json.decode(response.body) as List;
      print(_employeeDetails);
      setEmployeeData(_employeeDetails);
      saveEmployeeData(_employeeDetails);
    } else {
      Fluttertoast.showToast(
          msg: 'Error occurred while communicating with Server!');
    }
  }

  void setEmployeeData(value){
    _employeeDetails = value;
    _employeeList = value;
    notifyListeners();
  }

  void saveEmployeeData(value){
    var box = Hive.box("employeeDb");
    box.put('employees', value);
  }

  void getEmployeeData(){
    var box = Hive.box("employeeDb");
    _employeeDetails = box.get('employees');
    _employeeList = _employeeDetails;
    print(_employeeDetails);
    notifyListeners();
  }

  void updateSearchQuery(String val){
    _employeeList = _employeeDetails.where((element) =>  element["name"].toLowerCase().contains(val.toLowerCase()) || element["email"].toLowerCase().contains(val.toLowerCase())).toList();
    notifyListeners();
  }
}