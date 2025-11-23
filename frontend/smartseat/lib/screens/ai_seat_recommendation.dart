import 'package:flutter/material.dart';
import 'package:smartseat/screens/seat_detail_page.dart';

class SeatFinderPage extends StatefulWidget {
  final String userId;
  final String userEmail;
  final String userName;
  final String userJCUID;
  final String roomNumber;
  final String timeSlot;

  const SeatFinderPage({
    super.key,
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.userJCUID,
    this.roomNumber = 'C4-14',
    this.timeSlot = 'Today 2:00 PM',
  });

  @override
  State<SeatFinderPage> createState() => _SeatFinderPageState();
}

class _SeatFinderPageState extends State<SeatFinderPage> {
  // Recommendation data
  final List<Map<String, dynamic>> recommendations = [
    {
      'seatNumber': 12,
      'room': 'C4-14',
      'matchPercentage': 89,
      'matchType': 'Best Match',
      'features': [
        {'icon': Icons.lightbulb, 'label': 'Optimal view of board', 'color': Colors.green},
        {'icon': Icons.electrical_services, 'label': 'Power outlet nearby', 'color': Colors.blue},
        {'icon': Icons.volume_off, 'label': 'Quiet zone area', 'color': Colors.purple},
      ],
    },
    {
      'seatNumber': 9,
      'room': 'C4-14',
      'matchPercentage': 85,
      'matchType': 'Good Match',
      'features': [
        {'icon': Icons.visibility_good, 'label': 'Clear board visibility', 'color': Colors.green},
        {'icon': Icons.electrical_services, 'label': 'Power outlet nearby', 'color': Colors.blue},
        {'icon': Icons.signal_cellular_4_bar, 'label': 'Strong Wifi signal', 'color': Colors.orange},
      ],
    },
    {
      'seatNumber': 15,
      'room': 'C4-14',
      'matchPercentage': 92,
      'matchType': 'Best Match',
      'features': [
        {'icon': Icons.chair, 'label': 'Easy exit access', 'color': Colors.green},
        {'icon': Icons.lightbulb, 'label': 'Good natural light', 'color': Colors.blue},
        {'icon': Icons.signal_cellular_4_bar, 'label': 'Strong Wifi signal', 'color': Colors.orange},
      ],
    },
    {
      'seatNumber': 5,
      'room': 'C4-14',
      'matchPercentage': 88,
      'matchType': 'Good Match',
      'features': [
        {'icon': Icons.monitor, 'label': 'Front row advantage', 'color': Colors.green},
        {'icon': Icons.lightbulb, 'label': 'Low distraction zone', 'color': Colors.purple},
        {'icon': Icons.signal_cellular_4_bar, 'label': 'Strong Wifi signal', 'color': Colors.orange},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1976F3), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Color(0xFF1976F3),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Seat Finder',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Personalized recommendations based on your preferences',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Programming III • Next class: Today 2:00 PM',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Recommendations List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  final rec = recommendations[index];
                  return _buildRecommendationCard(rec, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(Map<String, dynamic> recommendation, int index) {
    final seatNumber = recommendation['seatNumber'];
    final matchPercentage = recommendation['matchPercentage'];
    final matchType = recommendation['matchType'];
    final features = recommendation['features'] as List;
    final room = recommendation['room'];

    // Determine match color
    Color matchColor;
    if (matchPercentage >= 90) {
      matchColor = const Color(0xFF4CAF50); // Green
    } else if (matchPercentage >= 85) {
      matchColor = const Color(0xFFFFC107); // Amber
    } else {
      matchColor = const Color(0xFFFF9800); // Orange
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SeatDetailPage(
              seatNumber: seatNumber,
              roomNumber: room,
              timeSlot: widget.timeSlot,
              userId: widget.userId,
              userEmail: widget.userEmail,
              userName: widget.userName,
              userJCUID: widget.userJCUID,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
          children: [
            // Top Section - Match Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Match Percentage Badge
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: matchColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: matchColor, width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${matchPercentage}%',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: matchColor,
                              ),
                            ),
                            Text(
                              'Match',
                              style: TextStyle(
                                fontSize: 10,
                                color: matchColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Seat $seatNumber',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: matchColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    matchType,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: matchColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Middle Left, Row 1',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Divider
            Divider(height: 1, color: Colors.grey[200]),

            // Features Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Why this seat?',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${features.length} Key Benefits',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: features.asMap().entries.map((entry) {
                      int featureIndex = entry.key;
                      Map<String, dynamic> feature = entry.value;
                      bool isLast = featureIndex == features.length - 1;

                      return Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: (feature['color'] as Color).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  feature['icon'],
                                  color: feature['color'],
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  feature['label'],
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (!isLast) const SizedBox(height: 12),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Reserve Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeatDetailPage(
                          seatNumber: seatNumber,
                          roomNumber: room,
                          timeSlot: widget.timeSlot,
                          userId: widget.userId,
                          userEmail: widget.userEmail,
                          userName: widget.userName,
                          userJCUID: widget.userJCUID,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Reserve This Seat',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}