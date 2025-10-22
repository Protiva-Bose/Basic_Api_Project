import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:basic_api_project/view/course/module_20_assignment/profile/profile_details/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../cors/service/token_service.dart';

class UserTaskHomePage extends StatefulWidget {
  const UserTaskHomePage({super.key});

  @override
  State<UserTaskHomePage> createState() => _UserTaskHomePageState();
}

class _UserTaskHomePageState extends State<UserTaskHomePage> {

  dynamic TaskData;

  initState() {
    super.initState();
    _loadTasks("New");
  }

  Future<void> _loadTasks(String statusTask) async {
    final data = await fetchStatusWiseTask(statusTask);
    setState(() {
      TaskData = data;
    });
  }

  Widget _buildCustomHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      color: Colors.blueAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen()));},
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.face, color: Colors.blueAccent),
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task management',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3. Task Card
  Widget _buildTaskCard(String title, String description, String status, String date) {
    return Card(
      margin: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
             Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Date: $date',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.grey),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 4. Bottom Action Item
  Widget _buildBottomActionItem(IconData icon, String label, {bool isSelected = false}) {
    final Color color = isSelected ? Colors.blueAccent : Colors.grey;
    final Color bgColor = isSelected ? Colors. white70 : Colors.transparent;

    return GestureDetector(
      onTap: (){
        setState(() {
          _loadTasks(label);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();
    String _status = 'New'; // default status

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                DropdownButtonFormField<String>(
                  value: _status,
                  items: ['New', 'Progress', 'Completed', 'Cancelled']
                      .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _status = value;
                    }
                  },
                  decoration: InputDecoration(labelText: 'Status'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final success = await createTask(
                _titleController.text,
                _descriptionController.text,
                _status,
              );

              if (success) {
                // Refresh the task list
                final updatedData = await fetchStatusWiseTask(_status);
                setState(() {
                  TaskData = updatedData;
                });
              }

              Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> createTask(String title, String description, String status) async {
    const String url = "http://35.73.30.144:2005/api/v1/createTask";
    final token = await TokenService.getToken();

    if (token == null) return false;

    final itemData = {
      "title": title,
      "description": description,
      "status": status,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "token": token,
          "Content-Type": "application/json",
        },
        body: jsonEncode(itemData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        log(jsonResponse.toString());
        return true; // Task created successfully
      } else {
        log("Error creating task: ${response.body}");
        return false;
      }
    } catch (e) {
      log("Exception creating task: $e");
      return false;
    }
  }


  Future<dynamic> fetchStatusWiseTask(String status) async {
    String url = "http://35.73.30.144:2005/api/v1/listTaskByStatus/$status";
    final token = await TokenService.getToken();

    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"token": token},
      );
      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      if (response.statusCode == 200) {
        return jsonResponse['data'];
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomHeader(context),
            Expanded(
              child: ListView.builder(
                itemCount: TaskData?.length ?? 0,
                itemBuilder: (context, index) {
                  return _buildTaskCard(
                    TaskData?[index]['title'] ?? "N/A",
                    TaskData?[index]['description'] ?? "N/A",
                    TaskData?[index]['status'] ?? "N/A",
                    TaskData?[index]['createdDate'] ?? "N/A",
                  );
                }
              )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog(context);
        },
        backgroundColor: Colors.blueAccent,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomActionItem(Icons.new_label_outlined, 'New', isSelected: true),
            _buildBottomActionItem(Icons.circle, 'Progress'),
            _buildBottomActionItem(Icons.cancel, 'Cancelled'),
            _buildBottomActionItem(Icons.done, 'Completed'),
          ],
        ),
      ),
    );
  }
}
