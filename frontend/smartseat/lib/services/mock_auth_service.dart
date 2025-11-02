class MockAuthService {
  // Mock users database
  static final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': '1',
      'email': 'student@my.jcu.edu.au',
      'password': 'student123',
      'role': 'student',
      'full_name': 'Jane Smith',
      'student_id': 'jd123456',
      'created_at': DateTime.now().toIso8601String(),
    },
    {
      'id': '2',
      'email': 'lecturer@example.com',
      'password': 'lecturer123',
      'role': 'lecturer',
      'full_name': 'Dr. John Doe',
      'created_at': DateTime.now().toIso8601String(),
    },
    {
      'id': '3',
      'email': 'admin@example.com',
      'password': 'admin123',
      'role': 'admin',
      'full_name': 'System Administrator',
      'created_at': DateTime.now().toIso8601String(),
    },
  ];

  /// Sign in with email and password (Mock version)
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      print('Mock Auth: Attempting login for $email');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Find user with matching email and password
      final user = _mockUsers.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
        orElse: () => {},
      );
      
      if (user.isEmpty) {
        print('Mock Auth: No user found');
        return null;
      }
      
      print('Mock Auth: User found - ${user['email']}');
      return Map<String, dynamic>.from(user);
    } catch (e) {
      print('Mock Auth Error: $e');
      return null;
    }
  }

  /// Get all users (for testing)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    return _mockUsers.map((user) => Map<String, dynamic>.from(user)).toList();
  }
}