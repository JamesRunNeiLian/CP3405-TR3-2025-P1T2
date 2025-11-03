import 'package:flutter/material.dart';

class RoomBookingDetailPage extends StatefulWidget {
  final String userId;
  final String userEmail;
  final String userName;
  final Map<String, dynamic> roomData;

  const RoomBookingDetailPage({
    super.key,
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.roomData,
  });

  @override
  State<RoomBookingDetailPage> createState() => _RoomBookingDetailPageState();
}

class _RoomBookingDetailPageState extends State<RoomBookingDetailPage> {
  DateTime selectedDate = DateTime.now();
  final Set<String> selectedTimeSlots = {};

  // Time slots data - marked as booked based on room
  final Map<String, Map<String, bool>> roomBookings = {
    'A2-08': {
      '08:00 - 09:00': false,
      '09:00 - 10:00': false,
      '10:00 - 11:00': true,
      '11:00 - 12:00': false,
      '12:00 - 13:00': false,
      '13:00 - 14:00': true,
      '14:00 - 15:00': false,
      '15:00 - 16:00': false,
      '16:00 - 17:00': false,
      '17:00 - 18:00': false,
    },
    'B3-06': {
      '08:00 - 09:00': false,
      '09:00 - 10:00': true,
      '10:00 - 11:00': false,
      '11:00 - 12:00': true,
      '12:00 - 13:00': false,
      '13:00 - 14:00': false,
      '14:00 - 15:00': true,
      '15:00 - 16:00': false,
      '16:00 - 17:00': true,
      '17:00 - 18:00': false,
    },
  };

  Map<String, bool> get currentRoomBookings {
    return roomBookings[widget.roomData['id']] ?? {};
  }

  @override
  Widget build(BuildContext context) {
    final room = widget.roomData;
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button and title
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Room ${room['name']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                room['type'],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Available',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Stats row
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: Row(
                      children: [
                        _buildStatBox(
                          'Capacity',
                          '${room['capacity']} seats',
                        ),
                        const SizedBox(width: 12),
                        _buildStatBox(
                          'Available',
                          '${room['slotsAvailable']} slots',
                        ),
                        const SizedBox(width: 12),
                        _buildStatBox(
                          'Occupied',
                          '${_getOccupiedSlots()} slots',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location card
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Color(0xFF1E88E5),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Location',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${room['building']}, ${room['level']}, Room ${room['name']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 8,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.people, size: 14, color: Colors.grey[600]),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${room['capacity']} seats',
                                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                    ...(room['features'] as List<String>).map((feature) {
                                      return Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.check, size: 14, color: Colors.blue[600]),
                                          const SizedBox(width: 4),
                                          Text(
                                            feature,
                                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Schedule section
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Schedule',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.calendar_month, color: Colors.grey[400]),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildCalendar(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Availability Legend
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Availability Legend:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildLegendItem(Colors.green, 'Available'),
                              const SizedBox(width: 20),
                              _buildLegendItem(Colors.orange, 'Limited'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildLegendItem(Colors.red, 'Full'),
                              const SizedBox(width: 20),
                              _buildLegendItem(Colors.grey, 'Unavailable'),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Available Time Slots
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 20, color: Colors.grey[700]),
                              const SizedBox(width: 8),
                              const Text(
                                'Available Time Slots',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...currentRoomBookings.entries.map((entry) {
                            return _buildTimeSlot(entry.key, entry.value);
                          }).toList(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Booking Information
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Booking Information',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoBullet(Colors.green, 'Click available slots to select'),
                          const SizedBox(height: 6),
                          _buildInfoBullet(Colors.blue, 'Selected slots will be booked under your name'),
                          const SizedBox(height: 6),
                          _buildInfoBullet(Colors.red, 'Red slots are already booked'),
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
      ),
      // Bottom booking button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: selectedTimeSlots.isEmpty ? null : _bookSelectedSlots,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedTimeSlots.isEmpty 
                    ? Colors.grey[300]
                    : const Color(0xFF1E88E5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_month, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    selectedTimeSlots.isEmpty
                        ? 'Select Time Slots to Book'
                        : 'Book ${selectedTimeSlots.length} Time Slot${selectedTimeSlots.length > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: selectedTimeSlots.isEmpty ? Colors.grey[600] : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Column(
      children: [
        // Month/Year header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {},
            ),
            const Text(
              'October 2025',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'].map((day) {
            return SizedBox(
              width: 40,
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        // Calendar grid
        ..._buildCalendarWeeks(),
      ],
    );
  }

  List<Widget> _buildCalendarWeeks() {
    final weeks = <Widget>[];
    final daysInMonth = [
      [28, 29, 30, 1, 2, 3, 4],
      [5, 6, 7, 8, 9, 10, 11],
      [12, 13, 14, 15, 16, 17, 18],
      [19, 20, 21, 22, 23, 24, 25],
      [26, 27, 28, 29, 30, 31, 1],
    ];

    for (final week in daysInMonth) {
      weeks.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: week.map((day) {
              final isToday = day == 8;
              final isCurrentMonth = day <= 31 && (week.first >= 5 || day <= 4);
              
              Color? textColor;
              Color? bgColor;
              
              if (isToday) {
                bgColor = Colors.black;
                textColor = Colors.white;
              } else if (day == 6 || day == 13 || day == 20 || day == 27) {
                textColor = Colors.green[700];
              } else if (day == 9 || day == 15 || day == 22) {
                textColor = Colors.red[700];
              } else if (day == 23 || day == 10 || day == 30) {
                textColor = Colors.orange[700];
              } else if (!isCurrentMonth) {
                textColor = Colors.grey[400];
              }

              return SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }

    return weeks;
  }

  Widget _buildTimeSlot(String timeSlot, bool isBooked) {
    final isSelected = selectedTimeSlots.contains(timeSlot);
    
    return GestureDetector(
      onTap: isBooked ? null : () {
        setState(() {
          if (isSelected) {
            selectedTimeSlots.remove(timeSlot);
          } else {
            selectedTimeSlots.add(timeSlot);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.blue.shade50 
              : (isBooked ? Colors.grey.shade50 : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF1E88E5)
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time,
              size: 20,
              color: isBooked ? Colors.grey[400] : Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                timeSlot,
                style: TextStyle(
                  fontSize: 14,
                  color: isBooked ? Colors.grey[500] : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isBooked)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Booked',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else if (isSelected)
              Icon(
                Icons.check_circle,
                color: const Color(0xFF1E88E5),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildInfoBullet(Color color, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }

  int _getOccupiedSlots() {
    return currentRoomBookings.values.where((isBooked) => isBooked).length;
  }

  void _bookSelectedSlots() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Booking'),
        content: Text(
          'Book ${selectedTimeSlots.length} time slot${selectedTimeSlots.length > 1 ? 's' : ''} for Room ${widget.roomData['name']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Successfully booked ${selectedTimeSlots.length} slot${selectedTimeSlots.length > 1 ? 's' : ''}!',
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              setState(() {
                selectedTimeSlots.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E88E5),
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}