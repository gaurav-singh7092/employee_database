import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class EditScreen extends StatefulWidget {
  final int id;
  final String employee_name;
  final int employee_age;
  final int employee_salary;
  const EditScreen(
      {Key? key,
      required this.employee_name,
      required this.employee_age,
      required this.employee_salary, required this.id})
      : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController employeeName_controller = TextEditingController();
  final TextEditingController employeeSalary_controller =
      TextEditingController();
  final TextEditingController employeeAge_controller = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    employeeName_controller.text = widget.employee_name;
    employeeSalary_controller.text = widget.employee_salary.toString();
    employeeAge_controller.text = widget.employee_age.toString();
    super.initState();
  }
  Future<String> editEmployee() async {
    try {
      setState(() {
        isLoading = true;
      });
      var response = await http.put(
          Uri.parse(
              'https://dummy.restapiexample.com/api/v1/update/${widget.id}'),
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
      return 'Too Many Requests';
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Employee'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 50,
                    width: 80,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        }, child: Text('Cancel',style: TextStyle(color: Colors.white,fontSize: 16),),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blueAccent
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  SizedBox(
                    height: 50,
                    width: 80,
                    child: TextButton(onPressed: () async {
                      final resultMessage = await editEmployee();
                      final message = SnackBar(content: Text(resultMessage));
                      ScaffoldMessenger.of(context).showSnackBar(message);
                      Navigator.pop(context);
                    }, child: Text('Update',style: TextStyle(color: Colors.white,fontSize: 16),),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blueAccent
                    ),),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding buildTextField(
      TextEditingController controller, String labelText, String hintText) {
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
