import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController employeeName_controller = TextEditingController();
  final TextEditingController employeeSalary_controller =
  TextEditingController();
  final TextEditingController employeeAge_controller = TextEditingController();
  bool isLoading = false;
  Future<String> createEmployee() async {
    try {
      setState(() {
        isLoading = true;
      });
      var response = await http.post(
          Uri.parse('https://dummy.restapiexample.com/api/v1/create'),
          body: {
            "name": employeeName_controller.text,
            "salary": employeeSalary_controller.text,
            "age": employeeAge_controller.text
          }
      );
      setState(() {
        isLoading = false;
      });
      final body = response.body;
      if(response.statusCode == 200) {
          final result = jsonDecode(body);
          return result['message'];
      } else {
        return 'Too many Requests';
      }
    } catch (e) {
      print(e);
      return 'Too many Requests';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Employee'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading ? Center(child: CircularProgressIndicator(),) : Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
          child: Column(
            children: [
              buildTextField(employeeName_controller, 'Employee Name', 'Name'),
              buildTextField(employeeAge_controller, 'Employee Age', 'Age'),
              buildTextField(
                  employeeSalary_controller, 'Employee Salary', 'Salary'),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: 80,
                child: TextButton(
                  onPressed: () async {
                    final resultMessage = await createEmployee();
                    final message = SnackBar(content: Text(resultMessage));
                    ScaffoldMessenger.of(context).showSnackBar(message);
                      Navigator.pop(context);
                  },
                  child: Text('Create',
                    style: TextStyle(color: Colors.white,fontSize: 16),),
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blueAccent
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding buildTextField(TextEditingController controller, String labelText,
      String hintText) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: hintText,
            hintStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
    );
  }
}
