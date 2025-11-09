import 'package:flutter/material.dart';
import 'package:smartseat/models/seat_model.dart';
import 'package:smartseat/screens/seat_detail_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SeatLayoutPage extends StatefulWidget {
  final int roomID;
  final String roomNumber;
  final String timeSlot;
  final String userId;
  final String userEmail;
  final String userName;
  final String userJCUID;

  const SeatLayoutPage({
    super.key,
    required this.roomID,
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
  List<SeatModel> seats = [];
  bool isLoading = true;
  int? selectedSeat;

  @override
  void initState() {
    super.initState();
    fetchSeats();
  }

  /// Fetch seats from Supabase
  Future<void> fetchSeats() async {
    setState(() => isLoading = true);
    try {
      final data = await Supabase.instance.client
          .from('seats')
          .select()
          .eq('roomID', widget.roomID)
          .order('number', ascending: true);

      debugPrint('Raw seat data: $data');

      if (data != null && data is List) {
        seats = data.map((seat) {
          return SeatModel.fromMap(seat); // SeatModel.fromMap will normalize status
        }).toList();
      } else {
        seats = [];
      }
    } catch (e) {
      debugPrint('Error fetching seats: $e');
      seats = [];
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// Handle seat tap
  void onSeatTap(int seatNumber) {
    final seat = seats.firstWhere(
      (s) => s.number == seatNumber,
      orElse: () => SeatModel(
        id: 0,
        number: seatNumber,
        type: '',
        status: 'unknown',
        features: [],
        roomId: widget.roomID,
      ),
    );

    if (seat.status.toLowerCase() == 'available') {
      setState(() {
        selectedSeat = selectedSeat == seatNumber ? null : seatNumber;
      });
    }
  }

  /// Get color based on seat status
  Color getSeatColor(SeatModel seat) {
    if (selectedSeat == seat.number) return Colors.blue;
    switch (seat.status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'occupied':
        return Colors.red;
      case 'reserved':
        return Colors.cyanAccent;
      default:
        return Colors.grey;
    }
  }

  /// Count available seats
  int getAvailableSeats() {
    return seats.where((seat) => seat.status.toLowerCase() == 'available').length;
  }

  /// Legend widget
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
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
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
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Availability Indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: seats.isEmpty ? 0 : getAvailableSeats() / seats.length,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${getAvailableSeats()}/${seats.length}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Info Text
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
                          'Tap any green seat to reserve. Red seats are occupied, cyan seats are reserved.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),

                // Seat Grid
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ...List.generate((seats.length / 10).ceil(), (rowIndex) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(10, (colIndex) {
                                final seatIndex = rowIndex * 10 + colIndex;
                                if (seatIndex >= seats.length) return const SizedBox(width: 36);
                                final seat = seats[seatIndex];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: GestureDetector(
                                    onTap: () => onSeatTap(seat.number),
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: getSeatColor(seat),
                                        borderRadius: BorderRadius.circular(6),
                                        border: selectedSeat == seat.number
                                            ? Border.all(color: Colors.blue[900]!, width: 3)
                                            : null,
                                      ),
                                      child: Center(
                                        child: Text(
                                          seat.number.toString(),
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

                        // Legend
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLegendItem(Colors.green, 'Available'),
                              const SizedBox(height: 8),
                              _buildLegendItem(Colors.red, 'Occupied'),
                              const SizedBox(height: 8),
                              _buildLegendItem(Colors.cyanAccent, 'Reserved'),
                              const SizedBox(height: 8),
                              _buildLegendItem(Colors.blue, 'Selected'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: selectedSeat != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      final seat = seats.firstWhere((s) => s.number == selectedSeat);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SeatDetailPage(
                            seatNumber: seat.number,
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
              ),
            )
          : null,
    );
  }
}
