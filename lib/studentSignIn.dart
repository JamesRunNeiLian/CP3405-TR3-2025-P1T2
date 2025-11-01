import 'package:flutter/material.dart';
import 'package:smartseat/services/auth_service.dart';
import 'package:smartseat/student_home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentSignInPage extends StatefulWidget {
  const StudentSignInPage({super.key});

  @override
  State<StudentSignInPage> createState() => StudentSignInPageState();
}

class StudentSignInPageState extends State<StudentSignInPage> {
  bool rememberMe = false;
  bool obscurePassword = true;
  bool isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    print('=== SUPABASE LOGIN ATTEMPT ===');
    print('Email entered: $email');
    print('Password length: ${password.length}');

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please enter email and password', isError: true);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      print('Attempting Supabase authentication...');
      final userData = await _authService.login(email, password);

      print('Login result: ${userData != null ? "Success" : "Failed"}');
      
      if (userData != null) {
        print('User role: ${userData['role']}');
        print('User email: ${userData['email']}');
        
        if (userData['role'] == 'student') {
          _showSnackBar('Login successful! Welcome ${userData['full_name'] ?? email}');
          
          // Navigate to student home page
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => StudentHomePage(
                  userId: userData['id'],
                  userEmail: userData['email'],
                  userName: userData['full_name'] ?? 'Student',
                ),
              ),
            );
          }
        } else {
          _showSnackBar('Please use the correct portal for your role (${userData['role']})', isError: true);
        }
      } else {
        _showSnackBar('Invalid email or password', isError: true);
      }
    } catch (e) {
      print('Login error: $e');
      String errorMessage = 'An error occurred during login';
      
      if (e.toString().contains('Invalid login credentials')) {
        errorMessage = 'Invalid email or password';
      } else if (e.toString().contains('Email not confirmed')) {
        errorMessage = 'Please confirm your email address';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error. Please check your connection';
      }
      
      _showSnackBar(errorMessage, isError: true);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E88E5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header section with blue background
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        label: const Text(
                          'Back to role selection',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Icon(Icons.location_on, color: Colors.white, size: 80),
                    const SizedBox(height: 8),
                    const Text(
                      'SmartSeat',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Find your perfect seat, instantly',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),

              // White form section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Student ID / Email',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        hintText: 'jd123456 or yourname@my.jcu.edu.au',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    const Text(
                      'Password',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: obscurePassword,
                      enabled: !isLoading,
                      onSubmitted: (_) => _handleSignIn(),
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Remember me + forgot password
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: isLoading ? null : (value) {
                            setState(() {
                              rememberMe = value ?? false;
                            });
                          },
                        ),
                        const Text('Remember me'),
                        const Spacer(),
                        TextButton(
                          onPressed: isLoading ? null : () {
                            // TODO: Implement password reset
                            _showSnackBar('Password reset feature coming soon!');
                          },
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Sign in button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleSignIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Demo credentials info
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '📋 Test Credentials:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Create a test user in Supabase Dashboard:\n'
                            'Authentication > Users > "Add User"',
                            style: TextStyle(fontSize: 11),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Email: student@my.jcu.edu.au',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                    Text(
                                      'Role: student',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Footer
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          text: 'By signing in, you agree to our ',
                          style: TextStyle(color: Colors.grey),
                          children: [
                            TextSpan(
                              text: 'Terms & Privacy Policy',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}