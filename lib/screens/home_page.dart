import 'package:flutter/material.dart';
import 'package:manage_expense/screens/category_page.dart';
import 'package:manage_expense/screens/home_view.dart';
import 'package:manage_expense/screens/expense_page.dart';
import 'package:manage_expense/screens/report_page.dart';
import 'package:manage_expense/screens/sub_page.dart';
import 'package:manage_expense/screens/CategoryReport.dart';
import 'package:manage_expense/screens/PaymentModeReport.dart';
import 'package:manage_expense/screens/view_expense.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<String> _tabs = ["Home", "Category","Sub-Category","Expense","Report","Category Wise Report","Mode Report","All expenses"];
  @override
  void initState() {
    super.initState();

    _tabController = new TabController(vsync: this, length: _tabs.length);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Manager"),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          tabs: [
            Tab(text: 'Payment Mode',),
            Tab(text: 'Category',),
            Tab(text: 'Sub-Category'),
            Tab(text: 'Expense',),
            Tab(text: 'Report',),
            Tab(text: 'Category Report',),
            Tab(text: 'Payment Wise Report',),
            Tab(text: 'All expenses')
          ],
        ),
      ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            HomeView(),
            CategoryPage(),
            SubCategoryPage(),
            ExpensePage(),
            ReportPage(),
            CategoryReport(),
            PaymentReport(),
            ViewExpense()
          ],
        ));

  }
}
