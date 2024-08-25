import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:stock_app/providers/stock_provider.dart';
import 'package:stock_app/view/stockdetail/Widget/chart.dart';
import 'package:stock_app/view/stockdetail/Widget/stockdetail_item.dart';

class StockDetailScreen extends StatelessWidget {
  final String ticker;

  const StockDetailScreen({Key? key, required this.ticker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);
    final historystock = stockProvider.stockHistory;
    final histotystock_filterticker = historystock.map((stockList) {
      return stockList.firstWhere((stock) => stock.ticker == ticker);
    }).toList();
    final stock = histotystock_filterticker.last;
    return Scaffold(
      appBar: AppBar(
        title: Text(stock.ticker),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '↑ ${stock.high}',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('Today\'s High'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '↓ ${stock.low}',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('Today\'s Low'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Close: ${stock.close}', // Replace with actual data
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color:
                          stock.close > stock.open ? Colors.green : Colors.red,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            '  open: ${stock.open}', // Replace with actual data
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                //  Graph
                Container(
                  height: 200,
                  
                  child: Center(
                      child: LineChartSample21(
                    stocks: histotystock_filterticker,
                  )),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Bottom Section - List of Stocks
            const Text(
              'Stocks',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: historystock.length,
                itemBuilder: (ctx, index) {
                  // final stockIdx = historystock[index]
                  //     .firstWhere((stock) => stock.ticker == ticker);
                  return StockDetailItem(stock: histotystock_filterticker[index]);
                },
              ),
            )
            //----------------------------------------
          ],
        ),
      ),
    );
  }
}
