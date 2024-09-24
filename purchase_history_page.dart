import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'add_supplier_page.dart';

// Assuming the purchaseHistory list is globally available

class PurchaseHistoryPage extends StatefulWidget {
  @override
  _PurchaseHistoryPageState createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  String _searchQuery = '';
  List<Map<String, dynamic>> _filteredPurchases = [];

  @override
  void initState() {
    super.initState();
    // Initially display all purchases
    _filteredPurchases = purchaseHistory;
  }

  // Function to handle the search query and filter results
  void _searchPurchases(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredPurchases = purchaseHistory
          .where((purchase) =>
              purchase['name'].toLowerCase().contains(_searchQuery))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('সকল ক্রয়সমূহ'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'সাপ্লায়ারের নাম দিয়ে সার্চ করুন',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => _searchPurchases(value), // Trigger search
            ),
          ),

          Expanded(
            child: _filteredPurchases.isEmpty
                ? Center(
                    child: Text('কোন তথ্য পাওয়া যায় নি'),
                  )
                : ListView.builder(
                    itemCount: _filteredPurchases.length,
                    itemBuilder: (context, index) {
                      final supplier = _filteredPurchases[index];
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'সাপ্লায়ার: ${supplier['name']}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'তারিখ: ${DateFormat('dd-MM-yyyy').format(supplier['purchaseDate'])}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'সর্বমোট মূল্য: ৳${supplier['totalAmount'].toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'প্রোডাক্ট:',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              for (var product in supplier['products'])
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    '${product['productName']} - ৳${product['productPrice'].toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
