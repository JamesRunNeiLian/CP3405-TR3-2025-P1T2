class SeatModel {
  final String? id; // UUID from Supabase
  final String classroomId;
  final String seatNumber;
  final int rowNumber;
  final int columnNumber;
  final bool isAvailable;

  SeatModel({
    this.id,
    required this.classroomId,
    required this.seatNumber,
    required this.rowNumber,
    required this.columnNumber,
    this.isAvailable = true,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'classroom_id': classroomId,
      'seat_number': seatNumber,
      'row_number': rowNumber,
      'column_number': columnNumber,
      'is_available': isAvailable,
    };
  }

  factory SeatModel.fromMap(Map<String, dynamic> map) {
    return SeatModel(
      id: map['id'] as String?,
      classroomId: map['classroom_id'] as String,
      seatNumber: map['seat_number'] as String,
      rowNumber: map['row_number'] as int,
      columnNumber: map['column_number'] as int,
      isAvailable: map['is_available'] as bool? ?? true,
    );
  }

  SeatModel copyWith({
    String? id,
    String? classroomId,
    String? seatNumber,
    int? rowNumber,
    int? columnNumber,
    bool? isAvailable,
  }) {
    return SeatModel(
      id: id ?? this.id,
      classroomId: classroomId ?? this.classroomId,
      seatNumber: seatNumber ?? this.seatNumber,
      rowNumber: rowNumber ?? this.rowNumber,
      columnNumber: columnNumber ?? this.columnNumber,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}