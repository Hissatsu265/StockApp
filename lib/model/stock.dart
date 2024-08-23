class Stock {
  final String ticker;
  final double open;
  final double high;
  final double low;
  final double close;
  final int volume;
  final String date;

  Stock({
    required this.ticker,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.date,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      open: (json['open'] as num).toDouble(), 
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      close: (json['close'] as num).toDouble(),
      volume: (json['vol']as num).toInt(), 
      ticker: json['ticker'],
      date: json['date'],
    );
  }
}
