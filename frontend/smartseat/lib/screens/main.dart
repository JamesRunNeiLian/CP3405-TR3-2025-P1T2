import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:smartseat/screens/studentsignin.dart';
import 'package:smartseat/screens/lecturersignin.dart';
import 'package:smartseat/screens/adminlogin.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://vqjtaaejsjovdiotacqe.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZxanRhYWVqc2pvdmRpb3RhY3FlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE4ODkyNTMsImV4cCI6MjA3NzQ2NTI1M30.FpbGZXWULKY4YqREvvaWy7D2BcgyO7RiFURAA6J_2js',
  );
  runApp(const SmartSeatApp());
}

class SmartSeatApp extends StatelessWidget {
  const SmartSeatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartSeat',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
 }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              // Top gradient header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 80,
                  horizontal: 24,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.location_on, color: Colors.white, size: 70),
                    SizedBox(height: 16),
                    Text(
                      'Welcome to SmartSeat',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Find your perfect seat and manage\nclassroom layouts with ease',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Role selection section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Text(
                      "Let's get started",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Select your role to continue",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    // Student option
                    RoleOption(
                      icon: Icons.school_outlined,
                      title: "I'm a Student",
                      subtitle: "Find and reserve your seats",
                      isSelected: selectedRole == 'student',
                      onTap: () {
                        setState(() => selectedRole = 'student');
                      },
                    ),
                    const SizedBox(height: 16),

                    // Lecturer option
                    RoleOption(
                      icon: Icons.person_outline,
                      title: "I'm a Lecturer",
                      subtitle: "Manage classroom layouts",
                      isSelected: selectedRole == 'lecturer',
                      onTap: () {
                        setState(() => selectedRole = 'lecturer');
                      },
                    ),

                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) => const AdminLoginPage(),
                              ),
                            );
                      },
                      child: const Text(
                        "I am an admin",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Why SmartSeat section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Why SmartSeat?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      BulletText('Real-time seat availability updates'),
                      BulletText('Smart recommendations based on preferences'),
                      BulletText('Easy classroom navigation and management'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Continue button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: ElevatedButton(
                  onPressed: selectedRole != null
                      ? () {
                          if (selectedRole == 'student') {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) => const StudentSignInPage(),
                              ),
                            );
                          }
                          else if (selectedRole == 'lecturer'){
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) => const LecturerLoginScreen(),
                              ),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedRole != null
                        ? Colors.blueAccent
                        : Colors.grey.shade300,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    selectedRole != null
                        ? "Continue as ${selectedRole!.capitalize()}"
                        : "Continue as ...",
                    style: TextStyle(
                      color: selectedRole != null
                          ? Colors.white
                          : Colors.grey.shade700,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const Text(
                'You can change your role anytime in settings',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleOption({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blueAccent : Colors.grey,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Colors.blueAccent : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class BulletText extends StatelessWidget {
  final String text;

  const BulletText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.blueAccent),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

extension StringCasing on String {
  String capitalize() => isEmpty ? this : this[0].toUpperCase() + substring(1);
}


