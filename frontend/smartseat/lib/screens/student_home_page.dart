import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smartseat/screens/seat_layout_page.dart';
import 'package:smartseat/screens/my_reservations_page.dart';
import 'package:smartseat/screens/student_profile_page.dart';
import 'package:smartseat/screens/venue_page.dart';

class StudentHomePage extends StatefulWidget {
  final String userId;
  final String userEmail;
  final String userName;
  final String userJCUID;
  final String program;

  const StudentHomePage({
    super.key,
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.userJCUID,
    this.program = 'Bachelor of Information Technology',
  });

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeTab(
        userId: widget.userId,
        userEmail: widget.userEmail,
        userName: widget.userName,
        userJCUID: widget.userJCUID,
        program: widget.program,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _pages[_selectedIndex],
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyReservationsPage(
                    userId: widget.userId,
                    userEmail: widget.userEmail,
                    userName: widget.userName,
                    userJCUID: widget.userJCUID,
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
}

// ------------------ HomeTab ------------------
class HomeTab extends StatefulWidget {
  final String userId;
  final String userEmail;
  final String userName;
  final String userJCUID;
  final String program;

  const HomeTab({
    super.key,
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.userJCUID,
    this.program = 'Bachelor of Information Technology',
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late Future<List<Map<String, dynamic>>> _roomsFuture;

  @override
  void initState() {
    super.initState();
    _roomsFuture = _fetchRooms();
  }

  Future<List<Map<String, dynamic>>> _fetchRooms() async {
    final response = await Supabase.instance.client
        .from('rooms')
        .select('id, name, capacity, features');
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    String displayName =
        widget.userName.isNotEmpty ? widget.userName.split(' ').first : 'Student';

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome back,',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentProfilePage(
                            userId: widget.userId,
                            userEmail: widget.userEmail,
                            userName: widget.userName,
                            userJCUID: widget.userJCUID,
                            program: widget.program,
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      child: Text(
                        displayName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Rooms list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _roomsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('No rooms available.'),
                    );
                  }

                  final rooms = snapshot.data!;
                  return Column(
                    children: rooms.map((room) {
                      final roomID = room['id'] ?? 0;
                      final name = room['name'] ?? 'Unnamed';
                      final capacity = room['capacity'] ?? 0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: VenueCard(
                          roomID: roomID,
                          roomNumber: name,
                          availableSeats: '$capacity seats available',
                          icon: Icons.people_outline,
                          userId: widget.userId,
                          userEmail: widget.userEmail,
                          userName: widget.userName,
                          userJCUID: widget.userJCUID,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),

            // Find a Seat Now button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VenuePage(
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
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Find a Seat Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ------------------ VenueCard ------------------
class VenueCard extends StatelessWidget {
  final int roomID;
  final String roomNumber;
  final String availableSeats;
  final IconData icon;
  final String userId;
  final String userEmail;
  final String userName;
  final String userJCUID;

  const VenueCard({
    super.key,
    required this.roomID,
    required this.roomNumber,
    required this.availableSeats,
    required this.icon,
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.userJCUID,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SeatLayoutPage(
              roomID: roomID,
              roomNumber: roomNumber,
              timeSlot: 'Available Now',
              userId: userId,
              userEmail: userEmail,
              userName: userName,
              userJCUID: userJCUID,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
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
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF1E88E5),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roomNumber,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    availableSeats,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
