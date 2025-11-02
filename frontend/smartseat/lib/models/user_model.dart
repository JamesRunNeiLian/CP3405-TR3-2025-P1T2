class UserModel {
  final String? id; // UUID from Supabase
  final String email;
  final String password;
  final String role; // 'student', 'lecturer', 'admin'
  final String? fullName;
  final String? studentId;
  final DateTime createdAt;

  UserModel({
    this.id,
    required this.email,
    required this.password,
    required this.role,
    this.fullName,
    this.studentId,
    required this.createdAt,
  });

  /// Convert to Map for Supabase
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'email': email,
      'password': password,
      'role': role,
      'full_name': fullName,
      'student_id': studentId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Create from Map (Supabase response)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String?,
      email: map['email'] as String,
      password: map['password'] as String,
      role: map['role'] as String,
      fullName: map['full_name'] as String?,
      studentId: map['student_id'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : DateTime.now(),
    );
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? id,
    String? email,
    String? password,
    String? role,
    String? fullName,
    String? studentId,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      studentId: studentId ?? this.studentId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}