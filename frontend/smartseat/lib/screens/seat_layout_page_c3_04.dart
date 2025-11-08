import 'package:flutter/material.dart';
import 'seat_detail_page.dart';

class SeatLayoutPageC304 extends StatefulWidget {
  final String roomNumber;
  final String timeSlot;
  final String userId;
  final String userEmail;
  final String userName;
  final String userJCUID;

  const SeatLayoutPageC304({
    super.key,
    required this.roomNumber,
    required this.timeSlot,
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.userJCUID,
  });

  @override
  State<SeatLayoutPageC304> createState() => _SeatLayoutPageC304State();
}

class _SeatLayoutPageC304State extends State<SeatLayoutPageC304> {
  int? selectedSeat;
  
  // Seat status: 0 = Available, 1 = Occupied, 2 = Reserved, 3 = Accessible
  final Map<int, int> seatStatus = {
    // Table 1
    1: 3, 2: 3, 3: 3, 4: 0, 5: 0, 6: 2,
    // Table 2
    7: 1, 8: 0, 9: 0, 10: 1, 11: 0, 12: 0,
    // Table 3
    13: 1, 14: 1, 15: 1, 16: 0, 17: 1, 18: 1,
    // Table 4
    19: 1, 20: 1, 21: 0, 22: 2, 23: 0, 24: 0,
    // Table 5
    25: 1, 26: 1, 27: 2, 28: 3, 29: 3, 30: 3,
  };

  int getAvailableSeats() {
    return seatStatus.values.where((status) => status == 0).length;
  }

  Color getSeatColor(int seatNumber) {
    if (selectedSeat == seatNumber) {
      return Colors.blue[700]!;
    }
    
    switch (seatStatus[seatNumber]) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.red;
      case 2:
        return Colors.cyanAccent;
      default:
        return Colors.green;
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

  Widget _buildSeat(int seatNumber) {
    return GestureDetector(
      onTap: () => onSeatTap(seatNumber),
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
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTable(String tableName, List<int> seats) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 2),
      ),
      child: Column(
        children: [
          Text(
            tableName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: seats.map((seat) => _buildSeat(seat)).toList(),
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
          // Progress bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: getAvailableSeats() / 30,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${getAvailableSeats()}/30',
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

          // Info banner
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

          // Seating layout
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Podium
                  Container(
                    margin: const EdgeInsets.only(bottom: 32),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
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
                          'Podium',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E88E5),
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
                    ],
                  ),

                  // Tables Row 1
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildTable('Table 1', [1, 2, 3, 4, 5, 6]),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTable('Table 2', [7, 8, 9, 10, 11, 12]),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Tables Row 2
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildTable('Table 3', [13, 14, 15, 16, 17, 18]),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTable('Table 4', [19, 20, 21, 22, 23, 24]),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Table 5 (centered)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: _buildTable('Table 5', [25, 26, 27, 28, 29, 30]),
                  ),

                  const SizedBox(height: 16),

                  // Door indicator (right)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
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
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Legend
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
                        _buildLegendItem(Colors.cyanAccent, 'Reserved'),
                        // Deleted Accessible legend
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Accessibility Seats hardcodded list
                  Container(
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
                          children: [
                            _buildAccessibilitySeatChip('Seat 1'),
                            _buildAccessibilitySeatChip('Seat 2'),
                            _buildAccessibilitySeatChip('Seat 3'),
                            _buildAccessibilitySeatChip('Seat 28'),
                            _buildAccessibilitySeatChip('Seat 29'),
                            _buildAccessibilitySeatChip('Seat 30'),
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
                          'Reserve Selected Seat',
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

  Widget _buildAccessibilitySeatChip(String seatLabel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.purple[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple[300]!),
      ),
      child: Text(
        seatLabel,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.purple[900],
        ),
      ),
    );
  }
}