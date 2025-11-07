// frontend/smartseat/lib/screens/venue_page.dart
import 'package:flutter/material.dart';
import 'package:smartseat/screens/seat_layout_page.dart';
import 'package:smartseat/screens/seat_layout_page_c3_04.dart';
import 'package:smartseat/screens/my_reservations_page.dart';

class VenuePage extends StatefulWidget {
  final String userId;
  final String userEmail;
  final String userName;

  const VenuePage({
    super.key,
    required this.userId,
    required this.userEmail,
    required this.userName,
  });

  @override
  State<VenuePage> createState() => _VenuePageState();
}

class _VenuePageState extends State<VenuePage> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Venue data
  final List<Map<String, dynamic>> _venues = [
    {
      'id': 'C4-14',
      'name': 'C4-14',
      'available': 23,
      'total': 60,
      'building': 'Building C4',
      'level': 'Level 1',
    },
    {
      'id': 'C3-03',
      'name': 'C3-03',
      'available': 25,
      'total': 60,
      'building': 'Building C3',
      'level': 'Level 3',
    },
    {
      'id': 'C3-04',
      'name': 'C3-04',
      'available': 17,
      'total': 30,
      'building': 'Building C3',
      'level': 'Level 3',
    },
    {
      'id': 'C3-05',
      'name': 'C3-05',
      'available': 18,
      'total': 60,
      'building': 'Building C3',
      'level': 'Level 3',
    },
    {
      'id': 'C3-06',
      'name': 'C3-06',
      'available': 55,
      'total': 100,
      'building': 'Building C3',
      'level': 'Level 3',
    },
    {
      'id': 'C4-13',
      'name': 'C4-13',
      'available': 29,
      'total': 60,
      'building': 'Building C4',
      'level': 'Level 1',
    },
  ];

  List<Map<String, dynamic>> get _filteredVenues {
    if (_searchQuery.isEmpty) {
      return _venues;
    }
    return _venues.where((venue) {
      final query = _searchQuery.toLowerCase();
      return venue['name'].toLowerCase().contains(query) ||
          venue['building'].toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        const Text(
                          'Venues',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Stats section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Find Your Perfect Seat',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Browse available classrooms',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Stats row
                        Row(
                          children: [
                            _buildStatBox('Venues', _venues.length.toString()),
                            const SizedBox(width: 12),
                            _buildStatBox(
                              'Available',
                              _venues
                                  .fold(0, (sum, v) => sum + (v['available'] as int))
                                  .toString(),
                            ),
                            const SizedBox(width: 12),
                            _buildStatBox('Today', 'Oct 6'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search by venue name or building...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            // Venue count
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Text(
                    'Showing ${_filteredVenues.length} venues',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'All available now',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Venue list
            Expanded(
              child: _filteredVenues.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No venues found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredVenues.length,
                      itemBuilder: (context, index) {
                        final venue = _filteredVenues[index];
                        return _buildVenueCard(venue);
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            if (index == 1) {
              // Navigate to My Reservations page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyReservationsPage(
                    userId: widget.userId,
                    userEmail: widget.userEmail,
                    userName: widget.userName,
                  ),
                ),
              );
            } else {
              setState(() {
                _selectedIndex = index;
              });
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF1E88E5),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          backgroundColor: Colors.transparent,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Find',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_seat_outlined),
              activeIcon: Icon(Icons.event_seat),
              label: 'My Seats',
            ),
          ],
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
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVenueCard(Map<String, dynamic> venue) {
    final available = venue['available'] as int;
    final total = venue['total'] as int;
    final percentage = (available / total * 100).round();
    
    return GestureDetector(
      onTap: () {
        // Navigate to the appropriate seat layout page
        if (venue['id'] == 'C3-04') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SeatLayoutPageC304(
                roomNumber: venue['id'],
                timeSlot: 'Available Now',
                userId: widget.userId,
                userEmail: widget.userEmail,
                userName: widget.userName,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SeatLayoutPage(
                roomNumber: venue['id'],
                timeSlot: 'Available Now',
                userId: widget.userId,
                userEmail: widget.userEmail,
                userName: widget.userName,
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Room name and availability badge
                  Row(
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
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              venue['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${venue['building']}, ${venue['level']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
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
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Available',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Seats available info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Seats Available',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '$available/$total seats',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: available / total,
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        percentage > 50
                            ? Colors.green
                            : percentage > 25
                                ? Colors.orange
                                : Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$percentage% available',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // View Seats button
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Same navigation logic as tapping the card
                    if (venue['id'] == 'C3-04') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SeatLayoutPageC304(
                            roomNumber: venue['id'],
                            timeSlot: 'Available Now',
                            userId: widget.userId,
                            userEmail: widget.userEmail,
                            userName: widget.userName,
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SeatLayoutPage(
                            roomNumber: venue['id'],
                            timeSlot: 'Available Now',
                            userId: widget.userId,
                            userEmail: widget.userEmail,
                            userName: widget.userName,
                          ),
                        ),
                      );
                    }
                  },
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.visibility,
                          size: 18,
                          color: Color(0xFF1E88E5),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'View Seats',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E88E5),
                          ),
                        ),
                      ],
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