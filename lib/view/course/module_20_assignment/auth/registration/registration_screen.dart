import 'dart:developer';

import 'package:basic_api_project/cors/routes/route_names.dart';
import 'package:basic_api_project/view/course/module_20_assignment/auth/otp/otp_verify.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../login/login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<bool> sendOtp(String email) async {

    final String apiUrl = 'http://35.73.30.144:2005/api/v1//RecoverVerifyEmail/$email';
    log("url: $apiUrl");
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String status = responseData['status'] ?? 'fail';
      final String message =
          responseData['data'] ?? 'An unknown error occurred.';

      log("response: $responseData");

      if (response.statusCode == 200 || response.statusCode == 201 && status == 'success') {
        _showSnackbar(message, Colors.green);
        return true;
      } else {
        _showSnackbar('Otp Send Failed: $message', Colors.red);
        return false;
      }
    } catch (e) {
      _showSnackbar('Network Error: Could not connect to server.', Colors.red);
      print('Registration error: $e');
      return false;
    }
  }

  Future<void> _registerUser(String email, String firstName, String lastName, String mobileNumber, String password) async {

    const String apiUrl = 'http://35.73.30.144:2005/api/v1/Registration';

    try {

      final Map<String, dynamic> requestBody = {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'mobile': mobileNumber,
        'password': password,
      };

      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String status = responseData['status'] ?? 'fail';
      final String message =
          responseData['data'] ?? 'An unknown error occurred.';

      if (response.statusCode == 200 || response.statusCode == 201 && status == 'success') {
        _showSnackbar('Registration Successful!', Colors.green);
      } else {
        _showSnackbar('Registration Failed: $message', Colors.red);
      }
    } catch (e) {
      _showSnackbar('Network Error: Could not connect to server.', Colors.red);
      print('Registration error: $e');
    }
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required.';
          }
          if (label == 'Email' && !value.contains('@')) {
            return 'Please enter a valid email.';
          }
          if (label == 'Password' && value.length < 6) {
            return 'Password must be at least 6 characters.';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter your $label',
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 20.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFF4DB6AC), width: 2.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:[
                const SizedBox(height: 40),

                Column(
                  children: [
                   Image.asset('assets/icons/splash_pic.png',scale: 10,),
                  ],
                ),
                const SizedBox(height: 20),

                const Text(
                  'Create new account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                _buildInputField(
                  'Email',
                  _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildInputField('First name', _firstNameController),
                _buildInputField('Last name', _lastNameController),
                _buildInputField(
                  'Mobile',
                  _mobileController,
                  keyboardType: TextInputType.phone,
                ),
                _buildInputField(
                  'Password',
                  _passwordController,
                  obscureText: true,
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill in all required fields.')),
                      );
                      return;
                    }
                    final registration = await _registerUser(
                        _emailController.text.trim(),
                        _firstNameController.text.trim(),
                        _lastNameController.text.trim(),
                        _mobileController.text.trim(),
                        _passwordController.text.trim()
                    );
                    final otpStatus = await sendOtp(_emailController.text.trim());
                    if(otpStatus) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ForgetPasswordVerifyOtpScreen(
                          email: _emailController.text.trim(),
                        )),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),

                const SizedBox(height: 24),

                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: const Text(
                    'Already registered? Sign In',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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
