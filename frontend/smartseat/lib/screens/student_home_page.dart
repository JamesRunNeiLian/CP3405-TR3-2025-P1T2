import 'package:flutter/material.dart';
import 'package:smartseat/screens/seat_layout_page.dart';
import 'package:smartseat/screens/seat_layout_page_c3_04.dart';
import 'package:smartseat/screens/my_reservations_page.dart';
import 'package:smartseat/screens/student_profile_page.dart';

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
      HomeTabContent(
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
              // Navigate to My Reservations page
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

class HomeTabContent extends StatelessWidget {
  final String userId;
  final String userEmail;
  final String userName;
  final String userJCUID;
  final String program;

  const HomeTabContent({
    super.key,
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.userJCUID,
    this.program = 'Bachelor of Information Technology',
  });

  @override
  Widget build(BuildContext context) {
    String displayName = userName.isNotEmpty ? userName.split(' ').first : 'Student';

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
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
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentProfilePage(
                                userId: userId,
                                userEmail: userEmail,
                                userName: userName,
                                userJCUID: userJCUID,
                                program: program,
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
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeatLayoutPage(
                          roomNumber: 'C4-14',
                          timeSlot: '2:00 PM - 4:00 PM',
                          userId: userId,
                          userEmail: userEmail,
                          userName: userName,
                          userJCUID: userJCUID,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
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
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'NEXT BOOKING',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                      letterSpacing: 1,
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
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 14,
                                          color: Colors.green.shade700,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '15 min',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Room C4-14',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '2:00 PM - 4:00 PM',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Venues',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See all',
                      style: TextStyle(
                        color: Color(0xFF1E88E5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  VenueCard(
                    roomNumber: 'C3-04',
                    availableSeats: '17/30 seats available',
                    icon: Icons.people_outline,
                    userId: userId,
                    userEmail: userEmail,
                    userName: userName,
                    userJCUID: userJCUID,
                  ),
                  const SizedBox(height: 12),
                  VenueCard(
                    roomNumber: 'C3-05',
                    availableSeats: '18/60 seats available',
                    icon: Icons.people_outline,
                    userId: userId,
                    userEmail: userEmail,
                    userName: userName,
                    userJCUID: userJCUID,

                  ),
                  const SizedBox(height: 12),
                  VenueCard(
                    roomNumber: 'C3-06',
                    availableSeats: '55/100 seats available',
                    icon: Icons.people_outline,
                    userId: userId,
                    userEmail: userEmail,
                    userName: userName,
                    userJCUID: userJCUID,

                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
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

class VenueCard extends StatelessWidget {
  final String roomNumber;
  final String availableSeats;
  final IconData icon;
  final String userId;
  final String userEmail;
  final String userName;
  final String userJCUID;

  const VenueCard({
    super.key,
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
        // Navigate to the appropriate layout based on room number
        Widget destination;
        if (roomNumber == 'C3-04') {
          destination = SeatLayoutPageC304(
            roomNumber: roomNumber,
            timeSlot: 'Available Now',
            userId: userId,
            userEmail: userEmail,
            userName: userName,
            userJCUID: userJCUID,
          );
        } else {
          destination = SeatLayoutPage(
            roomNumber: roomNumber,
            timeSlot: 'Available Now',
            userId: userId,
            userEmail: userEmail,
            userName: userName,
            userJCUID: userJCUID,

          );
        }
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
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
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}