import 'package:flutter/services.dart';
import 'package:excel/excel.dart';

class ExcelService {
  static final ExcelService _instance = ExcelService._internal();
  factory ExcelService() => _instance;
  ExcelService._internal();

  /// Load Excel file from assets
  Future<Excel> loadExcelFromAssets(String fileName) async {
    try {
      ByteData data = await rootBundle.load('assets/data/$fileName');
      var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      return Excel.decodeBytes(bytes);
    } catch (e) {
      throw Exception('Failed to load Excel file: $fileName. Error: $e');
    }
  }

  /// Read all data from Excel file and return as List of Maps
  Future<List<Map<String, dynamic>>> readExcelData(String fileName, {String? sheetName}) async {
    try {
      Excel excel = await loadExcelFromAssets(fileName);
      List<Map<String, dynamic>> data = [];
      
      // Get the sheet to read from
      Sheet? sheet;
      if (sheetName != null) {
        sheet = excel.tables[sheetName];
      } else {
        // Use first sheet if no sheet name specified
        sheet = excel.tables[excel.tables.keys.first];
      }
      
      if (sheet == null) {
        throw Exception('Sheet not found: ${sheetName ?? 'first sheet'}');
      }

      if (sheet.rows.isEmpty) {
        return data;
      }

      // Get headers from first row
      List<String> headers = [];
      for (var cell in sheet.rows.first) {
        headers.add(cell?.value?.toString() ?? '');
      }
      
      // Process data rows (skip header row)
      for (int i = 1; i < sheet.rows.length; i++) {
        Map<String, dynamic> row = {};
        for (int j = 0; j < headers.length && j < sheet.rows[i].length; j++) {
          var cellValue = sheet.rows[i][j]?.value;
          row[headers[j]] = cellValue?.toString() ?? '';
        }
        data.add(row);
      }
      
      return data;
    } catch (e) {
      throw Exception('Failed to read Excel data: $e');
    }
  }

  /// Get all sheet names from Excel file
  Future<List<String>> getSheetNames(String fileName) async {
    try {
      Excel excel = await loadExcelFromAssets(fileName);
      return excel.tables.keys.toList();
    } catch (e) {
      throw Exception('Failed to get sheet names: $e');
    }
  }

  /// Read specific columns from Excel file
  Future<List<Map<String, dynamic>>> readSpecificColumns(
    String fileName, 
    List<String> columnNames, 
    {String? sheetName}
  ) async {
    try {
      List<Map<String, dynamic>> allData = await readExcelData(fileName, sheetName: sheetName);
      
      return allData.map((row) {
        Map<String, dynamic> filteredRow = {};
        for (String column in columnNames) {
          filteredRow[column] = row[column] ?? '';
        }
        return filteredRow;
      }).toList();
    } catch (e) {
      throw Exception('Failed to read specific columns: $e');
    }
  }

  /// Convert Excel data to specific model objects
  Future<List<T>> convertToModels<T>(
    String fileName,
    T Function(Map<String, dynamic>) fromJson,
    {String? sheetName}
  ) async {
    try {
      List<Map<String, dynamic>> data = await readExcelData(fileName, sheetName: sheetName);
      return data.map((row) => fromJson(row)).toList();
    } catch (e) {
      throw Exception('Failed to convert to models: $e');
    }
  }

  /// Search for rows containing specific value in any column
  Future<List<Map<String, dynamic>>> searchInExcel(
    String fileName,
    String searchTerm,
    {String? sheetName, bool caseSensitive = false}
  ) async {
    try {
      List<Map<String, dynamic>> allData = await readExcelData(fileName, sheetName: sheetName);
      
      return allData.where((row) {
        return row.values.any((value) {
          String valueStr = value.toString();
          String searchStr = caseSensitive ? searchTerm : searchTerm.toLowerCase();
          String compareStr = caseSensitive ? valueStr : valueStr.toLowerCase();
          return compareStr.contains(searchStr);
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to search in Excel: $e');
    }
  }

  /// Get row count from Excel file
  Future<int> getRowCount(String fileName, {String? sheetName}) async {
    try {
      Excel excel = await loadExcelFromAssets(fileName);
      Sheet? sheet;
      
      if (sheetName != null) {
        sheet = excel.tables[sheetName];
      } else {
        sheet = excel.tables[excel.tables.keys.first];
      }
      
      return sheet?.rows.length ?? 0;
    } catch (e) {
      throw Exception('Failed to get row count: $e');
    }
  }

  /// Get column headers from Excel file
  Future<List<String>> getColumnHeaders(String fileName, {String? sheetName}) async {
    try {
      Excel excel = await loadExcelFromAssets(fileName);
      Sheet? sheet;
      
      if (sheetName != null) {
        sheet = excel.tables[sheetName];
      } else {
        sheet = excel.tables[excel.tables.keys.first];
      }
      
      if (sheet == null || sheet.rows.isEmpty) {
        return [];
      }

      List<String> headers = [];
      for (var cell in sheet.rows.first) {
        headers.add(cell?.value?.toString() ?? '');
      }
      
      return headers;
    } catch (e) {
      throw Exception('Failed to get column headers: $e');
    }
  }
}
