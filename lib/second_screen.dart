import 'dart:convert';
import 'package:assignment_2/edit_screen.dart';
import 'package:assignment_2/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SecondScreen extends StatefulWidget {
  final int id;
  SecondScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  Map mapResponse = {};
  Map dataResponse = {};
  bool isLoading = true;
  @override
  void initState() {
    employee_detail(widget.id);
    super.initState();
  }

  Future employee_detail(int id) async {
    http.Response response;
    final url = "https://dummy.restapiexample.com/api/v1/employee/$id";
    final uri = Uri.parse(url);
    response = await http.get(uri);
    final body = response.body;
    if (response.statusCode == 200) {
      setState(() {
        mapResponse = jsonDecode(body);
        dataResponse = mapResponse['data'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Details'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
                  child: Column(children: [
                    CircleAvatar(
                        radius: 50,
                        child: mapResponse['data']['profile_image'] == ''
                            ? Icon(Icons.error)
                            : Image.network(
                                mapResponse['data']['profile_image'])),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      'Employee Name : ${dataResponse['employee_name']}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Salary : ${dataResponse['employee_salary']}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Employee Age : ${dataResponse['employee_age']}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ]),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditScreen(
                    id: dataResponse['id'],
                        employee_name: dataResponse['employee_name'],
                    employee_age: dataResponse['employee_age'],
                    employee_salary: dataResponse['employee_salary'],
                      )));
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
