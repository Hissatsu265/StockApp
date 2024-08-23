import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:stock_app/model/stock.dart';
import 'package:stock_app/providers/stock_provider.dart';
import 'package:stock_app/view/dashboard/Widget/stock_list.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;
  List<Stock> _filteredStocks = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchStocks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchStocks() async {
    await Provider.of<StockProvider>(context, listen: false).fetchStocks();
    setState(() {
      _filteredStocks =
          Provider.of<StockProvider>(context, listen: false).stocks;
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
      _searchQuery = _searchController.text.toLowerCase();
      _filteredStocks = Provider.of<StockProvider>(context, listen: false)
          .stocks
          .where((stock) {
        final tickerLower = stock.ticker.toLowerCase();
        return tickerLower.contains(_searchQuery);
      }).toList();
      _sortStocks(1);
    });
  }

  void _resetSearch() {
    setState(() {
      _isSearching = false;
      _searchQuery = '';
      _searchController.clear();
      _filteredStocks =
          Provider.of<StockProvider>(context, listen: false).stocks;
      _sortStocks(1);
    });
  }

  void _sortStocks(int? idx) {
    setState(() {
      switch (_tabController.index) {
        case 0: // Volume ↑
          _filteredStocks.sort((a, b) => a.volume.compareTo(b.volume));
          break;
        case 1: // Volume ↓
          _filteredStocks.sort((a, b) => b.volume.compareTo(a.volume));
          break;
        case 2: // Close ↑
          _filteredStocks.sort((a, b) => a.close.compareTo(b.close));
          break;
        case 3: // Close ↓
          _filteredStocks.sort((a, b) => b.close.compareTo(a.close));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stock Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF3b82f6),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Search by ticker',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          floatingLabelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      color: Colors.white,
                      onPressed: _startSearch,
                    ),
                    if (_isSearching)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        color: Colors.white,
                        onPressed: _resetSearch,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    text: 'Volume ↑',
                  ),
                  Tab(text: 'Volume ↓'),
                  Tab(text: 'Close ↑'),
                  Tab(text: 'Close ↓'),
                ],
                labelStyle:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                onTap: _sortStocks,
              ),
            ],
          ),
        ),
      ),
      body: _filteredStocks.isEmpty
          ? _isSearching == true
              ? const Center(child: Text("No data"))
              : const Center(child: CircularProgressIndicator())
          : StockList(stocks: _filteredStocks),
    );
  }
}
