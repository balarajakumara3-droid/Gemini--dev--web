import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PriceRangeFilterScreen extends StatefulWidget {
  const PriceRangeFilterScreen({super.key});

  @override
  State<PriceRangeFilterScreen> createState() => _PriceRangeFilterScreenState();
}

class _PriceRangeFilterScreenState extends State<PriceRangeFilterScreen> {
  RangeValues _currentRangeValues = const RangeValues(250, 450);
  final double _min = 0;
  final double _max = 1000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Price Range',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _currentRangeValues = const RangeValues(250, 450);
              });
            },
            child: const Text(
              'Reset',
              style: TextStyle(
                color: Color(0xFF4CAF50),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Range Display
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildPriceBox('\$${_currentRangeValues.start.round()}'),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'to',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          _buildPriceBox('\$${_currentRangeValues.end.round()}'),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Range Slider
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: const Color(0xFF4CAF50),
                      inactiveTrackColor: Colors.grey[200],
                      thumbColor: const Color(0xFF4CAF50),
                      overlayColor: const Color(0xFF4CAF50).withOpacity(0.2),
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                      trackHeight: 4,
                      rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 12),
                      rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
                    ),
                    child: RangeSlider(
                      values: _currentRangeValues,
                      min: _min,
                      max: _max,
                      divisions: 100,
                      onChanged: (RangeValues values) {
                        setState(() {
                          _currentRangeValues = values;
                        });
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Min and Max labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${_min.round()}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '\$${_max.round()}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Quick Select Options
                  const Text(
                    'Quick Select',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildQuickSelectChip('\$0 - \$250', 0, 250),
                      _buildQuickSelectChip('\$250 - \$500', 250, 500),
                      _buildQuickSelectChip('\$500 - \$750', 500, 750),
                      _buildQuickSelectChip('\$750 - \$1000', 750, 1000),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Apply Button
          Container(
            padding: const EdgeInsets.all(20),
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
                  onPressed: () {
                    // Apply filter and go back
                    context.pop({
                      'minPrice': _currentRangeValues.start.round(),
                      'maxPrice': _currentRangeValues.end.round(),
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Apply Filter',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBox(String price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4CAF50).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        price,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4CAF50),
        ),
      ),
    );
  }

  Widget _buildQuickSelectChip(String label, double min, double max) {
    final isSelected = _currentRangeValues.start == min && _currentRangeValues.end == max;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentRangeValues = RangeValues(min, max);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4CAF50) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
