// frontend/smartseat/lib/screens/admin_seat_details_page.dart
import 'package:flutter/material.dart';

class AdminSeatDetailsPage extends StatefulWidget {
  final String roomNumber;
  final String subject;
  final int occupancy;
  final int bookings;

  const AdminSeatDetailsPage({
    super.key,
    required this.roomNumber,
    required this.subject,
    required this.occupancy,
    required this.bookings,
  });

  @override
  State<AdminSeatDetailsPage> createState() => _AdminSeatDetailsPageState();
}

class _AdminSeatDetailsPageState extends State<AdminSeatDetailsPage> {
  // Seat status: 0 = Available, 1 = Occupied, 2 = Reserved, 3 = Accessible
  final Map<int, int> seatStatus = {
    1: 0, 2: 1, 3: 0, 4: 1, 5: 0, 6: 0, 7: 1, 8: 1, 9: 1, 10: 1,
    11: 1, 12: 1, 13: 1, 14: 1, 15: 1, 16: 0, 17: 1, 18: 0, 19: 1, 20: 1,
    21: 0, 22: 1, 23: 1, 24: 1, 25: 1, 26: 0, 27: 1, 28: 1, 29: 1, 30: 1,
    31: 0, 32: 1, 33: 0, 34: 0, 35: 0, 36: 0, 37: 1, 38: 0, 39: 0, 40: 1,
    41: 0, 42: 1, 43: 0, 44: 1, 45: 0, 46: 0, 47: 1, 48: 0, 49: 0, 50: 1,
    51: 1, 52: 0, 53: 1, 54: 1, 55: 0, 56: 1, 57: 1, 58: 1, 59: 0, 60: 1,
  };

  int getOccupiedSeats() {
    return seatStatus.values.where((status) => status == 1).length;
  }

  int getReservedSeats() {
    return seatStatus.values.where((status) => status == 2).length;
  }

  int getAvailableSeats() {
    return seatStatus.values.where((status) => status == 0).length;
  }

  int getTotalCapacity() {
    return seatStatus.length;
  }

  double getAttendancePercentage() {
    return (getOccupiedSeats() / getTotalCapacity() * 100);
  }

  Color getSeatColor(int seatNumber) {
    switch (seatStatus[seatNumber]) {
      case 0:
        return const Color(0xFF4CAF50); // Available - green
      case 1:
        return const Color(0xFF1B5E20); // Occupied - dark green
      case 2:
        return Colors.grey; // Reserved
      case 3:
        return Colors.purple; // Accessible
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final occupiedCount = getOccupiedSeats();
    final reservedCount = getReservedSeats();
    final availableCount = getAvailableSeats();
    final totalCapacity = getTotalCapacity();
    final attendancePercentage = getAttendancePercentage();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Admin Seat Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1976F3), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.roomNumber} Seating',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.subject,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_list, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Occupied',
                          '$occupiedCount/$totalCapacity',
                          Colors.blue[100]!,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Reserved',
                          '$reservedCount',
                          Colors.blue[100]!,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Attendance',
                          '${attendancePercentage.toStringAsFixed(0)}%',
                          Colors.blue[100]!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Seat Details Button
            Container(
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Seat details feature coming soon!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.people, color: Color(0xFF1976F3)),
                label: const Text(
                  'Seat Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1976F3),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF1976F3), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
            ),

            // Legend
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLegendItem(
                    const Color(0xFF4CAF50),
                    'Available',
                    Icons.circle,
                  ),
                  _buildLegendItem(
                    const Color(0xFF1B5E20),
                    'Occupied',
                    Icons.circle,
                  ),
                  _buildLegendItem(
                    Colors.grey,
                    'Reserved',
                    Icons.circle,
                  ),
                  _buildLegendItem(
                    Colors.purple,
                    'Accessible',
                    Icons.circle_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Seat Grid
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: List.generate(6, (rowIndex) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(10, (colIndex) {
                        int seatNumber = rowIndex * 10 + colIndex + 1;
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: getSeatColor(seatNumber),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                seatNumber.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),

            // Room Occupancy
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Room Occupancy',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Progress bar
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: attendancePercentage / 100,
                            minHeight: 12,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF1976F3),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${attendancePercentage.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Available and Filled stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$availableCount available',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '$occupiedCount filled',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF1976F3),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1976F3),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}