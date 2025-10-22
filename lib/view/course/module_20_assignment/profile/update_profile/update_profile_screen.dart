import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../cors/service/token_service.dart';
import '../profile_details/profile_screen.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  static const String _profileUpdateUrl = 'http://35.73.30.144:2005/api/v1/ProfileUpdate';

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final String? token = await TokenService.getToken();
    debugPrint('Token read from storage: $token');

    if (token == null || token.isEmpty) {
      _showSnackbar('No token found, please log in again.', Colors.red);
      setState(() => _isLoading = false);
      return;
    }

    final Map<String, dynamic> requestBody = {
      'email': _emailController.text.trim(),
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'mobile': _mobileController.text.trim(),
      'password': _passwordController.text.trim(),
    };

    final uri = Uri.parse(_profileUpdateUrl);

    try {
      final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};

      debugPrint('POST $uri');
      debugPrint('Headers: $headers');
      debugPrint('Body: $requestBody');

      http.Response response = await http.post(uri, headers: headers, body: jsonEncode(requestBody)).timeout(const Duration(seconds: 15));

      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 401) {
        debugPrint('401 received. Retrying with "token" header format.');
        final altHeaders = {'Content-Type': 'application/json', 'token': token};
        response = await http.post(uri, headers: altHeaders, body: jsonEncode(requestBody)).timeout(const Duration(seconds: 15));
        debugPrint('Retry Status Code: ${response.statusCode}');
        debugPrint('Retry Response Body: ${response.body}');
      }

      if (response.statusCode == 401) {
        _showSnackbar('Unauthorized! Token expired or invalid. Please login again.', Colors.red);
        await TokenService.removeToken();
        return;
      }

      if (response.body.isEmpty) {
        _showSnackbar('Server returned empty response', Colors.red);
        return;
      }

      final responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
        _showSnackbar('Profile Updated Successfully!', Colors.green);

        if (responseData.containsKey('token') && responseData['token'] != null) {
          await TokenService.setToken(responseData['token'].toString());
        }

        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  ProfileScreen()));
        });
      } else {
        _showSnackbar('Failed: ${responseData['data'] ?? responseData['message'] ?? 'Unknown error'}', Colors.red);
      }
    } on TimeoutException {
      _showSnackbar('Request timed out. Please try again.', Colors.red);
    } on SocketException {
      _showSnackbar('No internet connection.', Colors.red);
    } catch (e, st) {
      _showSnackbar('Network Error! Please try again.', Colors.red);
      debugPrint('Update error: $e\n$st');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, duration: const Duration(seconds: 3)),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: (value) => value == null || value.isEmpty ? "$label is required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                Image.asset('assets/icons/splash_pic.png', scale: 10),
                const SizedBox(height: 30),
                const Text("Update Profile Details", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                _buildInputField('Email', _emailController, keyboardType: TextInputType.emailAddress),
                _buildInputField('First Name', _firstNameController),
                _buildInputField('Last Name', _lastNameController),
                _buildInputField('Mobile', _mobileController, keyboardType: TextInputType.phone),
                _buildInputField('Password', _passwordController, obscureText: true),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent.shade700, // blue background
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      minimumSize: const Size.fromHeight(48), // ensures a good tappable height
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                        : const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
