import 'package:flutter/material.dart';
import '../../../core/services/excel_service.dart';

class ExcelDemoScreen extends StatefulWidget {
  const ExcelDemoScreen({Key? key}) : super(key: key);

  @override
  State<ExcelDemoScreen> createState() => _ExcelDemoScreenState();
}

class _ExcelDemoScreenState extends State<ExcelDemoScreen> {
  final ExcelService _excelService = ExcelService();
  List<Map<String, dynamic>> _excelData = [];
  List<String> _sheetNames = [];
  List<String> _columnHeaders = [];
  bool _isLoading = false;
  String? _error;
  String _fileName = 'food_images_catalog_urls.xlsx'; // Your food images catalog file

  @override
  void initState() {
    super.initState();
    _loadExcelData();
  }

  Future<void> _loadExcelData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Get sheet names
      _sheetNames = await _excelService.getSheetNames(_fileName);
      
      // Get column headers
      _columnHeaders = await _excelService.getColumnHeaders(_fileName);
      
      // Load all data
      _excelData = await _excelService.readExcelData(_fileName);
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _searchInExcel(String searchTerm) async {
    if (searchTerm.isEmpty) {
      _loadExcelData();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      _excelData = await _excelService.searchInExcel(_fileName, searchTerm);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excel Data Viewer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.pushNamed(context, '/excel-data-analyzer');
            },
            tooltip: 'Analyze Data Structure',
          ),
          IconButton(
            icon: const Icon(Icons.restaurant_menu),
            onPressed: () {
              Navigator.pushNamed(context, '/excel-food-display');
            },
            tooltip: 'View Food Catalog',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadExcelData,
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick action buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/excel-food-display');
                    },
                    icon: const Icon(Icons.restaurant_menu),
                    label: const Text('Food Catalog'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/excel-data-analyzer');
                    },
                    icon: const Icon(Icons.analytics),
                    label: const Text('Analyze Data'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search in Excel data...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Debounce search
                Future.delayed(const Duration(milliseconds: 500), () {
                  _searchInExcel(value);
                });
              },
            ),
          ),
          const SizedBox(height: 16),

          // Info cards
          if (_sheetNames.isNotEmpty || _columnHeaders.isNotEmpty)
            Container(
              height: 100,
              child: Row(
                children: [
                  // Sheet names
                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sheets (${_sheetNames.length})',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 4),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  _sheetNames.join(', '),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Column count
                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Columns (${_columnHeaders.length})',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rows: ${_excelData.length}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Data display
          Expanded(
            child: _buildDataDisplay(),
          ),
        ],
      ),
    );
  }

  Widget _buildDataDisplay() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading Excel file',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.red[600],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadExcelData,
              child: const Text('Retry'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                _showInstructions();
              },
              child: const Text('How to add Excel file?'),
            ),
          ],
        ),
      );
    }

    if (_excelData.isEmpty) {
      return const Center(
        child: Text('No data found'),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: _columnHeaders
              .map((header) => DataColumn(
                    label: Text(
                      header,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ))
              .toList(),
          rows: _excelData
              .map((row) => DataRow(
                    cells: _columnHeaders
                        .map((header) => DataCell(
                              Text(row[header]?.toString() ?? ''),
                            ))
                        .toList(),
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to add Excel file'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('1. Copy your Excel file to:'),
              SizedBox(height: 4),
              Text(
                'assets/data/your_file.xlsx',
                style: TextStyle(
                  fontFamily: 'monospace',
                  backgroundColor: Color(0xFFE0E0E0),
                ),
              ),
              SizedBox(height: 12),
              Text('2. Update the file name in the code:'),
              SizedBox(height: 4),
              Text(
                '_fileName = "your_actual_file_name.xlsx"',
                style: TextStyle(
                  fontFamily: 'monospace',
                  backgroundColor: Color(0xFFE0E0E0),
                ),
              ),
              SizedBox(height: 12),
              Text('3. Run flutter pub get'),
              SizedBox(height: 12),
              Text('4. Restart the app'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
