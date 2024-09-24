import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test_app/add_customer_page.dart';
import 'package:test_app/product_page.dart';
import 'package:test_app/sale_history_page.dart';
import 'add_supplier_page.dart';
import 'purchase_history_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'stock_management_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _name = "হাফিজুল ইসলাম";
  String _mobile = "০১৫৫৮৯৯৩৩৪১";
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(255, 3, 171, 101),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(209, 255, 98, 0),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('হাতুড়ে স্টোর',
                style: TextStyle(color: Colors.black, fontSize: 20)),
            Text('সর্বশেষ ব্যাকআপঃ',
                style: TextStyle(color: Colors.black54, fontSize: 15)),
          ],
        ),
        actions: [
          Icon(Icons.notifications_none, color: Colors.black),
          SizedBox(width: 10),
        ],
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date and Backup Info Section
            _buildDateAndBackupSection(),
            SizedBox(height: 20),
            // Summary Card Section (Today's Sales, Profit, etc.)
            _buildSummaryCardSection(),
            SizedBox(height: 20),
            // Actions Grid Section
            _buildActionGrid(context),
            SizedBox(height: 20),
            // Support and Call Button Section
            _buildSupportSection(),
          ],
        ),
      ),
    );
  }

  // Drawer widget with editable profile information
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: GestureDetector(
              onTap: () {
                _showEditNameDialog();
              },
              child: Text(_name),
            ),
            accountEmail: Text('মোবাইলঃ $_mobile'),
            currentAccountPicture: GestureDetector(
              onTap: () {
                _pickImage();
              },
              child: CircleAvatar(
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!) as ImageProvider
                    : const AssetImage('assets/profile_picture.png'),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.green[400],
            ),
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('পাসওয়ার্ড পরিবর্তন'),
            onTap: () {
              // Handle password change action
            },
          ),
          ListTile(
            leading: Icon(Icons.refresh),
            title: Text('পাসওয়ার্ড রিসেট'),
            onTap: () {
              // Handle password reset action
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('লগ আউট'),
            onTap: () {
              // Handle log out action
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _showEditNameDialog() {
    final TextEditingController nameController =
        TextEditingController(text: _name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('নাম পরিবর্তন করুন'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: "নতুন নাম লিখুন"),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('সংরক্ষণ করুন'),
              onPressed: () {
                setState(() {
                  _name = nameController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Section 1: Date and Backup Section
  Widget _buildDateAndBackupSection() {
    return Card(
      color: Colors.green[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.security, size: 40, color: Colors.green),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ব্যাবসার পরিস্থিতি প্রিমিয়াম',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      'আজকের তারিখঃ ${DateTime.now().toString().substring(0, 10)}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 5),
                  Text(
                    'ক্লিক করে আপগ্রেড করুন',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('বিস্তারিত'),
            ),
          ],
        ),
      ),
    );
  }

  // Section 2: Summary Card Section
  Widget _buildSummaryCardSection() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem('আজকের বিক্রি', '৳ 0', true),
                _buildSummaryItem('আজকের লাভ', '৳ 0', false),
                _buildSummaryItem('আজকের বাকি', '৳ 0', false),
              ],
            ),
            Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem('স্টক সংখ্যা', '0', false),
                ElevatedButton(onPressed: () {}, child: Text('স্টক আপগ্রেড')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, bool isPrimary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 20, color: isPrimary ? Colors.black : Colors.black54),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: isPrimary ? Colors.blue : Colors.black),
        ),
      ],
    );
  }

  // Section 3: Action Grid Section
  Widget _buildActionGrid(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 4,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        _buildActionButton(Icons.shopping_cart, 'ক্রয়', context),
        _buildActionButton(Icons.shopping_bag, 'বিক্রয়', context),
        _buildActionButton(Icons.book, 'ক্রয় সমূহ', context),
        _buildActionButton(
            Icons.account_balance_wallet, 'বিক্রয় সমূহ', context),
        _buildActionButton(Icons.attach_money, 'খরচের হিসাব', context),
        _buildActionButton(Icons.people, 'সকল পার্টি', context),
        _buildActionButton(Icons.inventory, 'প্রোডাক্ট লিস্ট', context),
        _buildActionButton(Icons.stacked_bar_chart, 'স্টকের হিসাব', context),
        _buildActionButton(Icons.report, 'ব্যবসার রিপোর্ট', context),
        _buildActionButton(Icons.print, 'প্রিন্ট', context),
        _buildActionButton(Icons.payment, 'ডিজিটাল পেমেন্ট', context),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, BuildContext context) {
    return InkWell(
      onTap: () {
        if (label == 'বিক্রয়') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCustomersPage()),
          );
        }
        if (label == 'ক্রয়') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSuppliersPage()),
          );
        }
        if (label == 'ক্রয় সমূহ') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PurchaseHistoryPage()),
          );
        }
        if (label == 'বিক্রয় সমূহ') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SaleHistoryPage()),
          );
        }
        if (label == 'প্রোডাক্ট লিস্ট') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductPage()),
          );
        }
        if (label == 'স্টকের হিসাব') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StockManagementPage()),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.green[100],
            radius: 35,
            child: Icon(icon,
                size: 45, color: const Color.fromARGB(255, 0, 87, 3)),
          ),
          SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25),
          ),
        ],
      ),
    );
  }

  // Section 4: Support and Call Button Section
  Widget _buildSupportSection() {
    return Column(
      children: [
        Card(
          color: Colors.blue[100],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'যেকোনো প্রয়োজনে যোগাযোগ করুন',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.phone),
                  label: Text('০১৫৫৮৯৯৩৩৪১'),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
