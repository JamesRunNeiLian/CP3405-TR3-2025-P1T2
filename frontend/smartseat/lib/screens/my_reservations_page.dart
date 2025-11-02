import 'package:flutter/material.dart';
import 'package:smartseat/screens/student_home_page.dart';

class MyReservationsPage extends StatefulWidget {
  final String userId;
  final String userEmail;
  final String userName;

  const MyReservationsPage({
    super.key,
    required this.userId,
    required this.userEmail,
    required this.userName,
  });

  @override
  State<MyReservationsPage> createState() => _MyReservationsPageState();
}

class _MyReservationsPageState extends State<MyReservationsPage> {
  String selectedFilter = 'All';

  // Sample reservation data
  final List<Map<String, dynamic>> allReservations = [
    {
      'seatNumber': 55,
      'room': 'C4-14',
      'date': 'Today, Oct 6',
      'time': '2:00 PM - 4:00 PM',
      'status': 'Confirmed',
      'confirmationId': 'SR-2025-1006-055',
    },
    {
      'seatNumber': 32,
      'room': 'C3-14',
      'date': 'Yesterday, Oct 5',
      'time': '10:00 AM - 12:00 PM',
      'status': 'Completed',
      'confirmationId': 'SR-2024-1005-032',
    },
    {
      'seatNumber': 18,
      'room': 'C4-06',
      'date': 'Oct 4, 2024',
      'time': '2:00 PM - 4:00 PM',
      'status': 'Completed',
      'confirmationId': 'SR-2024-1004-018',
    },
    {
      'seatNumber': 45,
      'room': 'C3-14',
      'date': 'Oct 3, 2024',
      'time': '1:00 PM - 3:00 PM',
      'status': 'Completed',
      'confirmationId': 'SR-2025-1003-045',
    },
    {
      'seatNumber': 23,
      'room': 'C4-14',
      'date': 'Oct 2, 2024',
      'time': '9:00 AM - 11:00 AM',
      'status': 'Cancelled',
      'confirmationId': 'SR-2024-1002-023',
    },
    {
      'seatNumber': 67,
      'room': 'C4-14',
      'date': 'Oct 1, 2024',
      'time': '2:00 PM - 4:00 PM',
      'status': 'Completed',
      'confirmationId': 'SR-2024-1001-067',
    },
    {
      'seatNumber': 29,
      'room': 'C3-05',
      'date': 'Sep 30, 2024',
      'time': '11:00 AM - 1:00 PM',
      'status': 'Completed',
      'confirmationId': 'SR-2024-0930-029',
    },
    {
      'seatNumber': 51,
      'room': 'C3-04',
      'date': 'Sep 28, 2024',
      'time': '3:00 PM - 5:00 PM',
      'status': 'Completed',
      'confirmationId': 'SR-2024-0928-051',
    },
  ];

  List<Map<String, dynamic>> get filteredReservations {
    if (selectedFilter == 'All') return allReservations;
    return allReservations
        .where((r) => r['status'] == selectedFilter)
        .toList();
  }

  int get upcomingCount =>
      allReservations.where((r) => r['status'] == 'Confirmed').length;
  int get completedCount =>
      allReservations.where((r) => r['status'] == 'Completed').length;
  int get cancelledCount =>
      allReservations.where((r) => r['status'] == 'Cancelled').length;

  @override
  Widget build(BuildContext context) {
    String displayName = widget.userName.split(' ').first;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header with stats
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // App bar
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'My Reservations',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_list, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  // Subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "$displayName's Booking History",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Stats
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(upcomingCount.toString(), 'Upcoming'),
                        _buildStatCard(completedCount.toString(), 'Completed'),
                        _buildStatCard(cancelledCount.toString(), 'Canceled'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Filter tabs
                  Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        _buildFilterTab('All'),
                        _buildFilterTab('Upcoming'),
                        _buildFilterTab('Completed'),
                        _buildFilterTab('Cancelled'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Reservations list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredReservations.length + 1, // +1 for stats card at bottom
              itemBuilder: (context, index) {
                if (index == filteredReservations.length) {
                  // Stats card at bottom
                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Your SmartSeat Stats',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      allReservations.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E88E5),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Total Bookings',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: const [
                                    Text(
                                      '4.3',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E88E5),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Avg Rating',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Book Another Seat button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navigate back to student home page
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentHomePage(
                                  userId: widget.userId,
                                  userEmail: widget.userEmail,
                                  userName: widget.userName,
                                ),
                              ),
                              (route) => false,
                            );
                          },
                          icon: const Icon(Icons.location_on, color: Colors.white),
                          label: const Text(
                            'Book Another Seat',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E88E5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }

                final reservation = filteredReservations[index];
                return _buildReservationCard(reservation);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String number, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label) {
    final isSelected = selectedFilter == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFF1E88E5) : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF1E88E5) : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReservationCard(Map<String, dynamic> reservation) {
    final status = reservation['status'] as String;
    final isUpcoming = status == 'Confirmed';
    final isCancelled = status == 'Cancelled';
    final isCompleted = status == 'Completed';

    Color statusColor;
    Color statusBgColor;
    if (isUpcoming) {
      statusColor = Colors.blue[700]!;
      statusBgColor = Colors.blue[50]!;
    } else if (isCancelled) {
      statusColor = Colors.red[700]!;
      statusBgColor = Colors.red[50]!;
    } else {
      statusColor = Colors.green[700]!;
      statusBgColor = Colors.green[50]!;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E88E5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seat ${reservation['seatNumber']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      reservation['room'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.more_vert, color: Colors.grey[400]),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                reservation['date'],
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                reservation['time'],
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            reservation['confirmationId'],
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[400],
            ),
          ),
          if (isUpcoming) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Modify feature coming soon!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Modify',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _showCancelDialog(reservation);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showCancelDialog(Map<String, dynamic> reservation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel Reservation'),
        content: Text(
          'Are you sure you want to cancel Seat ${reservation['seatNumber']} in ${reservation['room']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Keep',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                reservation['status'] = 'Cancelled';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reservation cancelled'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }
}