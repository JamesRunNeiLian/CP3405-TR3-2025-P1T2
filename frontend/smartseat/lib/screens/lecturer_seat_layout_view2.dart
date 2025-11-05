// frontend/smartseat/lib/screens/lecturer_seat_layout_view2.dart
import 'package:flutter/material.dart';

class LecturerSeatLayoutView2 extends StatefulWidget {
  final String roomNumber;
  final String userId;
  final String userEmail;
  final String userName;

  const LecturerSeatLayoutView2({
    super.key,
    required this.roomNumber,
    required this.userId,
    required this.userEmail,
    required this.userName,
  });

  @override
  State<LecturerSeatLayoutView2> createState() => _LecturerSeatLayoutView2State();
}

class _LecturerSeatLayoutView2State extends State<LecturerSeatLayoutView2> {
  int? selectedSeat;

  // Seat status: 0 = Available, 1 = Occupied, 2 = Reserved, 3 = Accessible
  final Map<int, int> seatStatus = {
    // Table 1 (left top)
    1: 1, 2: 1, 3: 0, 
    4: 1, 5: 0, 6: 0,
    
    // Table 2 (right top)
    7: 1, 8: 0, 9: 3,
    10: 1, 11: 0, 12: 3,
    
    // Table 3 (left middle)
    13: 1, 14: 1,
    15: 1, 16: 0,
    17: 1, 18: 1,
    
    // Table 4 (right middle)
    19: 1, 20: 1,
    21: 0, 22: 2,
    23: 3, 24: 3,
    
    // Table 5 (bottom center)
    25: 0, 26: 1, 27: 3,
    28: 1, 29: 0, 30: 3,
  };

  // Accessibility seats
  final Map<String, String> accessibilitySeats = {
    'Seat 9': 'Seat 9',
    'Seat 12': 'Seat 12',
    'Seat 23': 'Seat 23',
    'Seat 24': 'Seat 24',
    'Seat 27': 'Seat 27',
    'Seat 30': 'Seat 30',
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
    if (selectedSeat == seatNumber) {
      return Colors.blue[900]!;
    }
    
    switch (seatStatus[seatNumber]) {
      case 0:
        return const Color(0xFF4CAF50); // Available - green
      case 1:
        return Colors.red; // Occupied - red
      case 2:
        return Colors.grey; // Reserved - grey
      case 3:
        return Colors.purple; // Accessible - purple
      default:
        return Colors.grey;
    }
  }

  void _onSeatTap(int seatNumber) {
    setState(() {
      if (selectedSeat == seatNumber) {
        selectedSeat = null;
      } else {
        selectedSeat = seatNumber;
      }
    });
  }

  Widget _buildSeat(int seatNumber) {
    return GestureDetector(
      onTap: () => _onSeatTap(seatNumber),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: getSeatColor(seatNumber),
          borderRadius: BorderRadius.circular(8),
          border: selectedSeat == seatNumber
              ? Border.all(color: Colors.blue[900]!, width: 3)
              : null,
        ),
        child: Center(
          child: Text(
            seatNumber.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTable(String tableName, List<int> topRowSeats, List<int> bottomRowSeats) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        children: [
          Text(
            tableName,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          // Top row of seats
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: topRowSeats.map((seat) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: _buildSeat(seat),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // Table rectangle
          Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[400]!, width: 1),
            ),
          ),
          const SizedBox(height: 8),
          // Bottom row of seats
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bottomRowSeats.map((seat) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: _buildSeat(seat),
              );
            }).toList(),
          ),
        ],
      ),
    );
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
        title: const Text('C3-04 - Seat Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section with Stats
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
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Design Thinking III',
                            style: TextStyle(
                              fontSize: 15,
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

            // Progress Bar
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: occupiedCount / totalCapacity,
                        minHeight: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF1976F3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '$occupiedCount/$totalCapacity',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Legend
            Container(
              margin: const EdgeInsets.all(16),
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
                    Colors.red,
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

            // Seating Layout
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  // Podium
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.school, color: Color(0xFF1976F3)),
                        SizedBox(width: 8),
                        Text(
                          'Podium',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1976F3),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Door indicator (left)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.door_front_door, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Door',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Top row - Table 1 and Table 2
                  Row(
                    children: [
                      Expanded(
                        child: _buildTable('Table 1', [1, 2, 3], [4, 5, 6]),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTable('Table 2', [7, 8, 9], [10, 11, 12]),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Middle row - Table 3 and Table 4
                  Row(
                    children: [
                      Expanded(
                        child: _buildTable('Table 3', [13, 14], [15, 16, 17, 18]),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTable('Table 4', [19, 20], [21, 22, 23, 24]),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Bottom row - Table 5 (centered)
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      Expanded(
                        flex: 2,
                        child: _buildTable('Table 5', [25, 26, 27], [28, 29, 30]),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Door indicator (right)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.door_front_door, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Door',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
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

            const SizedBox(height: 16),

            // Accessibility Seats
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Accessibility Seats -',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: accessibilitySeats.keys.map((seatLabel) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple[100],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.purple[300]!),
                        ),
                        child: Text(
                          seatLabel,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.purple[900],
                          ),
                        ),
                      );
                    }).toList(),
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