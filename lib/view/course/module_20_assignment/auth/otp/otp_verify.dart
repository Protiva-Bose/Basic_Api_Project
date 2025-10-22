import 'dart:convert';
import 'dart:developer';

import 'package:basic_api_project/cors/service/token_service.dart';
import 'package:basic_api_project/view/course/module_20_assignment/auth/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class ForgetPasswordVerifyOtpScreen extends StatefulWidget {
  final String email;
  const ForgetPasswordVerifyOtpScreen({
    super.key,
    required this.email,
  });

  @override
  State<ForgetPasswordVerifyOtpScreen> createState() => _ForgetPasswordVerifyOtpScreenState();
}

class _ForgetPasswordVerifyOtpScreenState extends State<ForgetPasswordVerifyOtpScreen> {
  late TextEditingController _pinController;
  late FocusNode _pinFocus;
  bool isLoading = false;

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<bool> verifyOtp(String email, String otp) async {

    final String apiUrl = 'http://35.73.30.144:2005/api/v1/RecoverVerifyOtp/$email/$otp';
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
        _showSnackbar('Email verified successful: $message', Colors.green);
        return true;
      } else {
        _showSnackbar('Email verification Failed: $message', Colors.red);
        return false;
      }
    } catch (e) {
      _showSnackbar('Network Error: Could not connect to server.', Colors.red);
      print('Registration error: $e');
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pinController = TextEditingController();
    _pinFocus = FocusNode();
  }
  @override
  void dispose() {
    _pinController.dispose();
    _pinFocus.dispose();
    super.dispose();
  }

  void _submitOtp() {
    String otp = _pinController.text.trim();
    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter OTP')));
      return;
    }
    setState(() => isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP submitted: $otp')));
    });
  }

  Widget _buildPinField() {
    return SizedBox(
      width: 300.w,
      child: TextField(
        controller: _pinController,
        focusNode: _pinFocus,
        keyboardType: TextInputType.number,
        maxLength: 6,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
          hintText: 'Enter 6-digit OTP',
        ),
      ),
    );
  }

  Widget _buildResendRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Didn't receive OTP? "),
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP resent')));
          },
          child: const Text('Resend'),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.h),
              SizedBox(
                height: 120.h,
                width: 120.w,
                child: CircleAvatar(
                  radius: 60.r,
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(Icons.lock_outline, size: 48.sp, color: Colors.blue),
                ),
              ),
              SizedBox(height: 24.h),
              Text('Enter Verification Code', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 8.h),
              Text('We have sent a 6-digit code to your number', style: TextStyle(fontSize: 14.sp), textAlign: TextAlign.center),
              SizedBox(height: 24.h),
              _buildPinField(),
              SizedBox(height: 16.h),
              isLoading
                  ? SizedBox(height: 48.h, width: 48.w, child: const CircularProgressIndicator())
                  : SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () async {
                    final status = await verifyOtp(widget.email, _pinController.text.trim());
                    if(status) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen())
                      );
                    }
                    _submitOtp();
                  },
                  child: Text('Verify', style: TextStyle(fontSize: 16.sp)),
                ),
              ),
              SizedBox(height: 12.h),
              _buildResendRow(),
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () {
                  _pinController.clear();
                },
                child: Text('Clear', style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
