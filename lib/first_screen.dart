import 'dart:convert';
import 'package:assignment_2/add_screen.dart';
import 'package:assignment_2/edit_screen.dart';
import 'package:assignment_2/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  List<Employee> employees = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Database'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder(
          future: getEmployee(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SecondScreen(
                                      id: employees[index].id,
                                    )));
                      },
                      child: ListTile(
                        title: Text(employees[index].employeeName),
                        subtitle:
                            Text('Salary : ${employees[index].employeeSalary}'),
                        leading: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditScreen(
                                        employee_name:
                                            employees[index].employeeName,
                                        employee_age:
                                            employees[index].employeeAge,
                                        employee_salary:
                                            employees[index].employeeSalary,
                                        id: employees[index].id)));
                          },
                          icon: Icon(Icons.edit),
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            final resultMessage = await deleteEmployee(employees[index].id);
                            final message = SnackBar(content: Text(resultMessage));
                            ScaffoldMessenger.of(context).showSnackBar(message);
                            },
                          icon: Icon(Icons.delete),
                        ),
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddScreen()));
        },
      ),
    );
  }

  Future<List<Employee>> getEmployee() async {
    final response = await http
        .get(Uri.parse('https://dummy.restapiexample.com/api/v1/employees#'));
    final body = response.body;
    var json = jsonDecode(body);
    var data = json['data'];
    if (response.statusCode == 200) {
      for (Map<String, dynamic> index in data) {
        employees.add(Employee.fromJson(index));
      }
      return employees;
    } else {
      return employees;
    }
  }
  
  Future<String> deleteEmployee(int id) async {
    try {
      var response = await http.delete(
        Uri.parse('https://dummy.restapiexample.com/api/v1/delete/$id'),
      );
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
}
