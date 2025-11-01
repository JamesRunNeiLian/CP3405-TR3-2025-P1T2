class ClassroomModel {
  final String? id; // UUID from Supabase
  final String name;
  final String building;
  final String roomNumber;
  final int capacity;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClassroomModel({
    this.id,
    required this.name,
    required this.building,
    required this.roomNumber,
    required this.capacity,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'building': building,
      'room_number': roomNumber,
      'capacity': capacity,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory ClassroomModel.fromMap(Map<String, dynamic> map) {
    return ClassroomModel(
      id: map['id'] as String?,
      name: map['name'] as String,
      building: map['building'] as String,
      roomNumber: map['room_number'] as String,
      capacity: map['capacity'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  ClassroomModel copyWith({
    String? id,
    String? name,
    String? building,
    String? roomNumber,
    int? capacity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClassroomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      building: building ?? this.building,
      roomNumber: roomNumber ?? this.roomNumber,
      capacity: capacity ?? this.capacity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}