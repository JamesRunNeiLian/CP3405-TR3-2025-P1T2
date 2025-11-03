import 'package:flutter/material.dart';

class LecturerSeatLayoutViewPage extends StatefulWidget {
  final String roomNumber;
  final String userId;
  final String userEmail;
  final String userName;

  const LecturerSeatLayoutViewPage({
    super.key,
    required this.roomNumber,
    required this.userId,
    required this.userEmail,
    required this.userName,
  });

  @override
  State<LecturerSeatLayoutViewPage> createState() => _LecturerSeatLayoutViewPageState();
}

class _LecturerSeatLayoutViewPageState extends State<LecturerSeatLayoutViewPage> {
  // Seat status: 0 = Available, 1 = Occupied, 2 = Reserved, 3 = Accessible
  final Map<int, int> seatStatus = {
    1: 3, 2: 1, 3: 0, 4: 1, 5: 0, 6: 0, 7: 1, 8: 1, 9: 1, 10: 0,
    11: 1, 12: 1, 13: 1, 14: 0, 15: 1, 16: 0, 17: 1, 18: 0, 19: 1, 20: 0,
    21: 3, 22: 1, 23: 1, 24: 1, 25: 1, 26: 0, 27: 1, 28: 1, 29: 1, 30: 1,
    31: 1, 32: 1, 33: 0, 34: 0, 35: 0, 36: 0, 37: 1, 38: 0, 39: 1, 40: 0,
    41: 3, 42: 1, 43: 0, 44: 1, 45: 0, 46: 0, 47: 1, 48: 1, 49: 1, 50: 2,
    51: 0, 52: 0, 53: 0, 54: 1, 55: 0, 56: 1, 57: 0, 58: 0, 59: 0, 60: 0,
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

  int getFilledSeats() {
    return getOccupiedSeats() + getReservedSeats();
  }

  double getAttendancePercentage() {
    return (getFilledSeats() / getTotalCapacity() * 100);
  }

  Color getSeatColor(int seatNumber) {
    switch (seatStatus[seatNumber]) {
      case 0:
        return Colors.green;
      case 1:
        return const Color(0xFF2E7D32); // Dark green for occupied
      case 2:
        return Colors.grey;
      case 3:
        return Colors.purple;
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
    final filledCount = getFilledSeats();
    final attendancePercentage = getAttendancePercentage();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Lecturer Seat Layout View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Header section with stats
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF1E88E5),
            ),
            child: Column(
              children: [
                // Room title
                Row(
                  children: [
                    const Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.roomNumber} Seating',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Stats row
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

          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Lecturer Podium
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
                        Icon(Icons.school, color: Color(0xFF1E88E5)),
                        SizedBox(width: 8),
                        Text(
                          'Lecturer Podium',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E88E5),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Seat grid
                  ...List.generate(6, (rowIndex) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(10, (colIndex) {
                          int seatNumber = rowIndex * 10 + colIndex + 1;
                          
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
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
                                    fontSize: 11,
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

                  const SizedBox(height: 24),

                  // Legend
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildLegendItem(
                          Colors.green,
                          'Available',
                          Icons.circle,
                        ),
                        _buildLegendItem(
                          const Color(0xFF2E7D32),
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

                  const SizedBox(height: 24),

                  // Room Occupancy
                  Container(
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Progress bar
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: filledCount / totalCapacity,
                                  minHeight: 12,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color(0xFF1E88E5),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '${attendancePercentage.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 16,
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
                              '$filledCount filled',
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

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
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
              color: Color(0xFF1E88E5),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1E88E5),
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