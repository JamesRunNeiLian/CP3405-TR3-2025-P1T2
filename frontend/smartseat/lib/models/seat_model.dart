class SeatModel {
  final int id;                  // Primary key (integer)
  final DateTime? createdAt;     // Timestamp
  final int number;              // Seat number (integer)
  final String type;             // Type (e.g., "Non=accessible", "Accessible")
  final String status;           // Status (normalized to lowercase)
  final List<String> features;   // List of special features
  final int roomId;              // Foreign key from rooms table

  SeatModel({
    required this.id,
    this.createdAt,
    required this.number,
    required this.type,
    required this.status,
    required this.features,
    required this.roomId,
  });

  /// Convert Dart object → Map (for Supabase insert/update)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      'number': number,
      'type': type,
      'status': status,
      'features': features,
      'roomID': roomId,
    };
  }

  /// Convert Supabase response → Dart object
  factory SeatModel.fromMap(Map<String, dynamic> map) {
    // Normalize status to lowercase
    String normalizedStatus = (map['status'] as String?)?.toLowerCase() ?? 'unknown';

    return SeatModel(
      id: (map['id'] is int) 
          ? map['id'] as int 
          : int.tryParse(map['id'].toString()) ?? 0,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      number: (map['number'] is int)
          ? map['number'] as int
          : int.tryParse(map['number'].toString()) ?? 0,
      type: map['type'] as String? ?? '',
      status: normalizedStatus, // Use normalized lowercase status
      features: (map['features'] is List)
          ? List<String>.from(map['features'])
          : (map['features']?.toString().split(',') ?? []),
      roomId: (map['roomID'] is int)
          ? map['roomID'] as int
          : int.tryParse(map['roomID'].toString()) ?? 0,
    );
  }

  /// Create a modified copy (immutable pattern)
  SeatModel copyWith({
    int? id,
    DateTime? createdAt,
    int? number,
    String? type,
    String? status,
    List<String>? features,
    int? roomId,
  }) {
    return SeatModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      number: number ?? this.number,
      type: type ?? this.type,
      status: status ?? this.status,
      features: features ?? this.features,
      roomId: roomId ?? this.roomId,
    );
  }
}
