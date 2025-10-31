import 'package:flutter/material.dart';
import 'package:smartseat/database/database_helper.dart';

class DatabaseTestPage extends StatefulWidget {
  const DatabaseTestPage({super.key});

  @override
  State<DatabaseTestPage> createState() => _DatabaseTestPageState();
}

class _DatabaseTestPageState extends State<DatabaseTestPage> {
  List<Map<String, dynamic>> users = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final dbHelper = DatabaseHelper();
      final allUsers = await dbHelper.getAllUsers();
      
      setState(() {
        users = allUsers;
        isLoading = false;
      });
      
      print('Loaded ${users.length} users from database');
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      print('Error loading users: $e');
    }
  }

  Future<void> _addSampleUsers() async {
    try {
      final dbHelper = DatabaseHelper();
      
      // Add student
      await dbHelper.insertUser({
        'email': 'student@my.jcu.edu.au',
        'password': 'student123',
        'role': 'student',
        'full_name': 'Dennis',
        'student_id': 'jd123456',
        'created_at': DateTime.now().toIso8601String(),
      });
      
      // Add lecturer
      await dbHelper.insertUser({
        'email': 'lecturer@example.com',
        'password': 'lecturer123',
        'role': 'lecturer',
        'full_name': 'Dr. Tan',
        'created_at': DateTime.now().toIso8601String(),
      });
      
      // Add admin
      await dbHelper.insertUser({
        'email': 'admin@example.com',
        'password': 'admin123',
        'role': 'admin',
        'full_name': 'System Administrator',
        'created_at': DateTime.now().toIso8601String(),
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sample users added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      _loadUsers(); // Reload users
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding users: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _clearDatabase() async {
    try {
      final dbHelper = DatabaseHelper();
      await dbHelper.clearAllTables();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Database cleared successfully!'),
          backgroundColor: Colors.orange,
        ),
      );
      
      _loadUsers(); // Reload users
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error clearing database: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (errorMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.red.shade100,
                    child: Text(
                      'Error: $errorMessage',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Users in Database: ${users.length}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _addSampleUsers,
                              icon: const Icon(Icons.add),
                              label: const Text('Add Sample Users'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _clearDatabase,
                              icon: const Icon(Icons.delete),
                              label: const Text('Clear Database'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _loadUsers,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: users.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inbox, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'No users in database',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Click "Add Sample Users" to create test accounts',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: user['role'] == 'student'
                                      ? Colors.blue
                                      : user['role'] == 'lecturer'
                                          ? Colors.green
                                          : Colors.orange,
                                  child: Icon(
                                    user['role'] == 'student'
                                        ? Icons.school
                                        : user['role'] == 'lecturer'
                                            ? Icons.person
                                            : Icons.admin_panel_settings,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  user['email'] ?? 'No email',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Password: ${user['password']}'),
                                    Text('Role: ${user['role']}'),
                                    if (user['full_name'] != null)
                                      Text('Name: ${user['full_name']}'),
                                  ],
                                ),
                                isThreeLine: true,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}