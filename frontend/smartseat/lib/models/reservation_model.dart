class ReservationModel {
  final String? id; // UUID from Supabase
  final String userId;
  final String seatId;
  final String classroomId;
  final DateTime reservationDate;
  final String startTime;
  final String endTime;
  final String status; // 'pending', 'confirmed', 'cancelled', 'completed'
  final DateTime createdAt;

  ReservationModel({
    this.id,
    required this.userId,
    required this.seatId,
    required this.classroomId,
    required this.reservationDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'seat_id': seatId,
      'classroom_id': classroomId,
      'reservation_date': reservationDate.toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ReservationModel.fromMap(Map<String, dynamic> map) {
    return ReservationModel(
      id: map['id'] as String?,
      userId: map['user_id'] as String,
      seatId: map['seat_id'] as String,
      classroomId: map['classroom_id'] as String,
      reservationDate: DateTime.parse(map['reservation_date'] as String),
      startTime: map['start_time'] as String,
      endTime: map['end_time'] as String,
      status: map['status'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  ReservationModel copyWith({
    String? id,
    String? userId,
    String? seatId,
    String? classroomId,
    DateTime? reservationDate,
    String? startTime,
    String? endTime,
    String? status,
    DateTime? createdAt,
  }) {
    return ReservationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      seatId: seatId ?? this.seatId,
      classroomId: classroomId ?? this.classroomId,
      reservationDate: reservationDate ?? this.reservationDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}