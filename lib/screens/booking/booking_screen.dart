import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_button.dart';
import 'passenger_info_screen.dart';

class BookingScreen extends StatefulWidget {
  final String origin;
  final String destination;
  final String time;
  final String price;
  final String bus;

  const BookingScreen({
    super.key,
    required this.origin,
    required this.destination,
    required this.time,
    required this.price,
    required this.bus,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final Set<int> _selectedSeats = {};
  final List<int> _occupiedSeats = [3, 5, 8, 12, 13, 20, 21];

  double get _totalPrice {
    final priceValue =
        double.tryParse(widget.price.replaceAll('\$', '')) ?? 0.0;
    return priceValue * _selectedSeats.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        title: const Text('Select Seat'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildTravelInfo(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildSeatLegend(),
                  const SizedBox(height: 32),
                  _buildBusLayout(),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildTravelInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.origin} → ${widget.destination}',
                  style: AppTextStyles.h4.copyWith(color: AppColors.darkNavy),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.directions_bus_filled_rounded,
                      size: 14,
                      color: AppColors.textGray,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${widget.bus} • ${widget.time}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textGray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.teal.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.price,
              style: AppTextStyles.h3.copyWith(color: AppColors.teal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLegendItem(
            'Available',
            AppColors.mediumGray.withValues(alpha: 0.5),
          ),
          _buildLegendItem('Selected', AppColors.teal),
          _buildLegendItem(
            'Occupied',
            AppColors.darkNavy.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildBusLayout() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkNavy.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Driver Section
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.radio_button_checked_rounded,
                  color: AppColors.textGray,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Seats Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
            ),
            itemCount: 28,
            itemBuilder: (context, index) {
              final seatNumber = index + 1;
              final isOccupied = _occupiedSeats.contains(seatNumber);
              final isSelected = _selectedSeats.contains(seatNumber);

              if (index % 4 == 2) return const SizedBox.shrink();

              return GestureDetector(
                onTap: isOccupied
                    ? null
                    : () {
                        setState(() {
                          if (isSelected) {
                            _selectedSeats.remove(seatNumber);
                          } else {
                            _selectedSeats.add(seatNumber);
                          }
                        });
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isOccupied
                        ? AppColors.darkNavy.withValues(alpha: 0.1)
                        : isSelected
                        ? AppColors.teal
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isOccupied
                          ? Colors.transparent
                          : isSelected
                          ? AppColors.teal
                          : AppColors.borderGray,
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.teal.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      '$seatNumber',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isOccupied
                            ? AppColors.textGray
                            : isSelected
                            ? Colors.white
                            : AppColors.textDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedSeats.length > 1
                          ? 'Total Price (${_selectedSeats.length} seats)'
                          : 'Total Price',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${_totalPrice.toStringAsFixed(2)}',
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.darkNavy,
                      ),
                    ),
                  ],
                ),
                _selectedSeats.isNotEmpty
                    ? Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: _selectedSeats
                                .map(
                                  (s) => Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.teal.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '#$s',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.teal,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Confirm Booking',
              onPressed: _selectedSeats.isEmpty
                  ? () {}
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PassengerInfoScreen(
                            seatNumbers: _selectedSeats.toList()..sort(),
                            origin: widget.origin,
                            destination: widget.destination,
                            time: widget.time,
                            price: '\$${_totalPrice.toStringAsFixed(2)}',
                            bus: widget.bus,
                          ),
                        ),
                      );
                    },
              type: _selectedSeats.isEmpty
                  ? AppButtonType.secondary
                  : AppButtonType.primary,
            ),
          ],
        ),
      ),
    );
  }
}
