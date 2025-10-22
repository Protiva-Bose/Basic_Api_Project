import 'dart:convert';
import 'dart:developer';
import 'package:basic_api_project/cors/service/token_service.dart';
import 'package:basic_api_project/view/course/module_20_assignment/profile/update_profile/update_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Map<String, dynamic>? profileData;
  late bool loading;

  Future<Map<String, dynamic>?> fetchProfileDetails() async {
    const String url = "http://35.73.30.144:2005/api/v1/ProfileDetails";
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
        return jsonResponse['data'][0];
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    Future.microtask(() async {
      profileData = await fetchProfileDetails();
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Profile Details"),
              centerTitle: true,
              backgroundColor: Colors.blue,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.shade50,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icons/splash_pic.png',
                          fit: BoxFit.cover,
                          width: 110,
                          height: 110,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateProfileScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.edit),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildProfileRow(
                            "Email",
                            profileData?['email'] ?? '',
                          ),

                          const Divider(height: 20),

                          _buildProfileRow(
                            "First Name",
                            profileData?['firstName']?.toString() ?? '',
                          ),
                          const SizedBox(height: 8),
                          _buildProfileRow(
                            "Last Name",
                            profileData?['lastName']?.toString() ?? '',
                          ),

                          const Divider(height: 20),

                          _buildProfileRow(
                            "Mobile",
                            profileData?['mobile']?.toString() ?? '',
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildProfileRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '-',
              style: const TextStyle(fontSize: 17),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
