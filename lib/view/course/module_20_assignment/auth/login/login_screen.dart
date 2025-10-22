import 'dart:developer';
import 'dart:convert';

import 'package:basic_api_project/cors/service/token_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../profile/profile_details/profile_screen.dart';
import '../registration/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  static const String _loginUrl = 'http://35.73.30.144:2005/api/v1/Login';

  Future<http.Response> _postLogin(String url, Map<String, dynamic> body) {
    return http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final Map<String, dynamic> requestBody = {
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
    };

    try {
      log('Attempt login: $_loginUrl');
      final response = await _postLogin(_loginUrl, requestBody);

      log('Login status: ${response.statusCode}');
      log('Login body: ${response.body}');

      await _handleLoginResponse(response);
    } catch (e, st) {
      _showSnackbar(
        'Network Error: Please check your internet connection.',
        Colors.red,
      );
      log('Login exception: $e\n$st');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLoginResponse(http.Response response) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      String? token;
      if (responseData.containsKey('token'))
        token = responseData['token']?.toString();
      if (token == null && responseData['data'] is Map)
        token = responseData['data']?['token']?.toString();
      if (token == null && responseData.containsKey('accessToken'))
        token = responseData['accessToken']?.toString();
      if (token == null && responseData['data'] is Map) {
        final data = responseData['data'] as Map;
        if (data['user'] is Map) token = data['user']?['token']?.toString();
      }

      if (token != null && token.isNotEmpty) {
        await TokenService.setToken(token);
        log('Saved token: $token');

        _showSnackbar('Login Successful! Welcome back.', Colors.green);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
      } else {
        _showSnackbar(
          'Login succeeded but token missing in response.',
          Colors.red,
        );
        log('Token missing in login response: $responseData');
      }
    } else if (response.statusCode == 400 || response.statusCode == 401) {
      String errorMessage = 'Invalid email or password.';
      try {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        errorMessage =
            errorData['data']?.toString() ??
            errorData['message']?.toString() ??
            errorMessage;
      } catch (_) {}
      _showSnackbar('Login Failed: $errorMessage', Colors.red);
    } else if (response.statusCode == 404) {
      _showSnackbar(
        'Login endpoint not found (404). Check API URL.',
        Colors.red,
      );
    } else {
      _showSnackbar(
        'Server Error (${response.statusCode}): Could not complete login.',
        Colors.red,
      );
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
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
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter your $label',
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 20.0,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
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
              children: [
                const SizedBox(height: 80),
                Column(
                  children: [
                    Image.asset('assets/icons/splash_pic.png', scale: 8),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  'Email',
                  _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildInputField(
                  'Password',
                  _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      /* TODO: forgot password */
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.blueAccent.shade700,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
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
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistrationScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.blueAccent.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
