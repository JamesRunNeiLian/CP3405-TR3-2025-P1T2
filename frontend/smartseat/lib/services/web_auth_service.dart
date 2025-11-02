import '../models/user_model.dart';

class WebAuthService {
  // In-memory user storage for web
  static final List<Map<String, dynamic>> _users = [
    {
      'id': 1,
      'email': 'student@my.jcu.edu.au',
      'password': 'student123',
      'role': 'student',
      'full_name': 'Jane Smith',
      'student_id': 'jd123456',
      'created_at': DateTime.now().toIso8601String(),
    },
    {
      'id': 2,
      'email': 'lecturer@example.com',
      'password': 'lecturer123',
      'role': 'lecturer',
      'full_name': 'Dr. John Doe',
      'created_at': DateTime.now().toIso8601String(),
    },
    {
      'id': 3,
      'email': 'admin@example.com',
      'password': 'admin123',
      'role': 'admin',
      'full_name': 'System Administrator',
      'created_at': DateTime.now().toIso8601String(),
    },
  ];

  Future<User?> login(String email, String password) async {
    try {
      print('Web Auth: Attempting login for $email');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      final userMap = _users.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
        orElse: () => {},
      );
      
      if (userMap.isEmpty) {
        print('Web Auth: No user found');
        return null;
      }
      
      print('Web Auth: User found - ${userMap['email']}');
      return User.fromMap(userMap);
    } catch (e) {
      print('Web Auth Error: $e');
      return null;
    }
  }

  Future<bool> register(User user) async {
    try {
      final userMap = user.toMap();
      userMap['id'] = _users.length + 1;
      _users.add(userMap);
      return true;
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  Future<User?> getUserById(int id) async {
    try {
      final userMap = _users.firstWhere(
        (user) => user['id'] == id,
        orElse: () => {},
      );
      return userMap.isNotEmpty ? User.fromMap(userMap) : null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      return _users.map((map) => User.fromMap(map)).toList();
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }
}