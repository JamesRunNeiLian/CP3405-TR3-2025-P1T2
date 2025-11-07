import 'package:flutter/material.dart';
import 'package:smartseat/screens/seat_detail_page.dart';

class SeatLayoutPage extends StatefulWidget {
  final String roomNumber;
  final String timeSlot;
  final String userId;
  final String userEmail;
  final String userName;
  final String userJCUID;

  const SeatLayoutPage({
    super.key,
    required this.roomNumber,
    required this.timeSlot,
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.userJCUID,
  });

  @override
  State<SeatLayoutPage> createState() => _SeatLayoutPageState();
}

class _SeatLayoutPageState extends State<SeatLayoutPage> {
  int? selectedSeat;
  
  final Map<int, int> seatStatus = {
    1: 3, 2: 1, 3: 0, 4: 1, 5: 0, 6: 0, 7: 1, 8: 1, 9: 1, 10: 0,
    11: 1, 12: 1, 13: 1, 14: 0, 15: 1, 16: 0, 17: 1, 18: 0, 19: 1, 20: 0,
    21: 3, 22: 1, 23: 1, 24: 1, 25: 1, 26: 0, 27: 1, 28: 1, 29: 1, 30: 1,
    31: 1, 32: 1, 33: 0, 34: 0, 35: 0, 36: 0, 37: 1, 38: 0, 39: 1, 40: 0,
    41: 3, 42: 1, 43: 0, 44: 1, 45: 0, 46: 0, 47: 1, 48: 1, 49: 1, 50: 2,
    51: 0, 52: 0, 53: 0, 54: 1, 55: 0, 56: 1, 57: 0, 58: 0, 59: 0, 60: 0,
  };

  int getAvailableSeats() {
    return seatStatus.values.where((status) => status == 0).length;
  }

  Color getSeatColor(int seatNumber) {
    if (selectedSeat == seatNumber) {
      return Colors.blue;
    }
    
    switch (seatStatus[seatNumber]) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.red;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  bool isSeatClickable(int seatNumber) {
    return seatStatus[seatNumber] == 0;
  }

  void onSeatTap(int seatNumber) {
    if (isSeatClickable(seatNumber)) {
      setState(() {
        if (selectedSeat == seatNumber) {
          selectedSeat = null;
        } else {
          selectedSeat = seatNumber;
        }
      });
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('${widget.roomNumber} - Seat Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: getAvailableSeats() / 60,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${getAvailableSeats()}/60',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: Color(0xFF1E88E5)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tap any green seat to reserve\nPurple seats have wheelchair access',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
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

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
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
                  ),

                  ...List.generate(6, (rowIndex) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(10, (colIndex) {
                          int seatNumber = rowIndex * 10 + colIndex + 1;
                          
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () => onSeatTap(seatNumber),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: getSeatColor(seatNumber),
                                  borderRadius: BorderRadius.circular(6),
                                  border: selectedSeat == seatNumber
                                      ? Border.all(color: Colors.blue[900]!, width: 3)
                                      : null,
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
                            ),
                          );
                        }),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
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
                  ),

                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildLegendItem(Colors.green, 'Available'),
                        const SizedBox(height: 8),
                        _buildLegendItem(Colors.red, 'Occupied'),
                        const SizedBox(height: 8),
                        _buildLegendItem(Colors.blue, 'Reserved'),
                        const SizedBox(height: 8),
                        _buildLegendItem(Colors.purple, 'Accessible'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Accessibility Seats -',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Seat 1', style: TextStyle(fontSize: 14)),
                        Text('Seat 21', style: TextStyle(fontSize: 14)),
                        Text('Seat 41', style: TextStyle(fontSize: 14)),
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
      bottomNavigationBar: selectedSeat != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                            Icons.event_seat,
                            color: Color(0xFF1E88E5),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Seat $selectedSeat',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Available for booking',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeatDetailPage(
                                seatNumber: selectedSeat!,
                                roomNumber: widget.roomNumber,
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
                        child: Text(
                          'Reserve Seat $selectedSeat',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}