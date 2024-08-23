import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stock_app/model/stock.dart';

class StockProvider with ChangeNotifier {
  List<Stock> _stocks = [];
  Timer? _timer;

  List<Stock> get stocks => _stocks;

  StockProvider() {
    _startAutoUpdate();
  }

  Future<void> fetchStocks() async {
    final url = Uri.parse('https://stocktraders.vn/service/data/getTotalTradeReal');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "TotalTradeRealRequest": {"account": "StockTraders"}
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        
        if (data.containsKey('TotalTradeRealReply')) {
          final stockList = data['TotalTradeRealReply']['stockTotalReals'] as List;
          _stocks = stockList.map((stockData) => Stock.fromJson(stockData)).toList();
          notifyListeners(); 
        } else {
          throw Exception('Unexpected data structure in response.');
        }
      } else {
        throw Exception('Failed to load stock data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to fetch stocks: $error');
    }
  }

  void _startAutoUpdate() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      fetchStocks();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
