import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:stock_app/model/stock.dart';
import 'package:stock_app/navigation/navigation_helper.dart';
import 'package:stock_app/providers/stock_provider.dart';
import 'package:stock_app/view/stockdetail/stockdetail_screen.dart';

class StockList extends StatelessWidget {
  
  final List<Stock> stocks;
  final ScrollController scrollController;
  
  const StockList({Key? key, required this.stocks,required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: stocks.length,
      controller: scrollController,
      itemBuilder: (ctx, index) {
        final stock = stocks[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            contentPadding:const  EdgeInsets.all(10.0),
            title: Text(
              stock.ticker,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.arrow_upward,
                              color: Colors.green,
                              size: 18.0,
                            ),
                            const SizedBox(width: 4.0),
                            Text('High: ${stock.high}'),
                          ],
                        ),
                        const SizedBox(height: 4.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.arrow_downward,
                              color: Colors.red,
                              size: 18.0,
                            ),
                            const SizedBox(width: 4.0),
                            Text('Low: ${stock.low}'),
                          ],
                        ),
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Close: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black, 
                            ),
                          ),
                          TextSpan(
                            text: '${stock.close}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: stock.close > stock.low
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    )
                  ],
                )),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Volume',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${stock.volume}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            onTap: (){
              NavigationHelper.navigatePushSlideFromRight(context,StockDetailScreen(ticker: stock.ticker));
            },
          ),
        );
      },
    );
  }
}
