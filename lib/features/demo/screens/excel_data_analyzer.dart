import 'package:flutter/material.dart';
import '../../../core/services/excel_service.dart';

class ExcelDataAnalyzer extends StatefulWidget {
  const ExcelDataAnalyzer({Key? key}) : super(key: key);

  @override
  State<ExcelDataAnalyzer> createState() => _ExcelDataAnalyzerState();
}

class _ExcelDataAnalyzerState extends State<ExcelDataAnalyzer> {
  final ExcelService _excelService = ExcelService();
  List<String> _columnHeaders = [];
  List<Map<String, dynamic>> _sampleData = [];
  Map<String, int> _stats = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _analyzeExcelStructure();
  }

  Future<void> _analyzeExcelStructure() async {
    try {
      // Get column headers
      _columnHeaders = await _excelService.getColumnHeaders('food_images_catalog_urls.xlsx');
      
      // Get first 5 rows as sample
      List<Map<String, dynamic>> allData = await _excelService.readExcelData('food_images_catalog_urls.xlsx');
      _sampleData = allData.take(5).toList();
      
      // Calculate statistics
      _stats = {
        'Total Rows': allData.length,
        'Total Columns': _columnHeaders.length,
        'Non-empty Image URLs': allData.where((row) => 
          row.values.any((value) => value.toString().contains('http') || value.toString().contains('www'))
        ).length,
      };
      
      setState(() {
        _isLoading = false;
      });
      
      // Print structure for debugging
      print('=== EXCEL STRUCTURE ANALYSIS ===');
      print('Columns: $_columnHeaders');
      print('Sample Data: $_sampleData');
      print('Stats: $_stats');
      
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
        title: const Text('Excel Structure Analysis'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatsSection(),
                      const SizedBox(height: 20),
                      _buildColumnsSection(),
                      const SizedBox(height: 20),
                      _buildSampleDataSection(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildStatsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ..._stats.entries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.key),
                  Text(
                    entry.value.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildColumnsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Columns (${_columnHeaders.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _columnHeaders.map((header) => Chip(
                label: Text(header),
                backgroundColor: Colors.blue[100],
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSampleDataSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sample Data (First 5 rows)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: _columnHeaders.map((header) => DataColumn(
                  label: Text(
                    header,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )).toList(),
                rows: _sampleData.map((row) => DataRow(
                  cells: _columnHeaders.map((header) => DataCell(
                    Container(
                      constraints: const BoxConstraints(maxWidth: 150),
                      child: Text(
                        row[header]?.toString() ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  )).toList(),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
