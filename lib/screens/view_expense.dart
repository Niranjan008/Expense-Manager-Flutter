import 'package:flutter/material.dart';
import 'package:manage_expense/expense_database_helper.dart';
class ViewExpense extends StatefulWidget {
  @override
  _ViewExpenseState createState() => _ViewExpenseState();
}
class _ViewExpenseState extends State<ViewExpense> {
  final dbHelper = DatabaseHelpers.instance;
  int ss;
  List<String> months = ['JAN', 'FEB', 'MAR', 'APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC']; // Option 2
  var monmap = {'JAN':1, 'FEB':2, 'MAR':3, 'APR':4,'MAY':5,'JUN':6,'JUL':7,'AUG':8,'SEP':9,'OCT':10,'NOV':11,'DEC':12};
  String _selectedmonth;
  Future<List> _query(int month) async{
    final allRows = await dbHelper.getAllExpense(month);
    print('query all rows:');
    return allRows.toList();
  }
  void _delete(id) async {
    // Assuming that the number of rows is the id for the last row
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }
  void _delete1(id) async {
    // Assuming that the number of rows is the id for the last row
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }
  showAlertDialog(BuildContext context,int ss) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        _delete(ss);
        _delete1(ss-1);
        setState(() {

        });
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete"),
      content: Text("Are you sure want to delete."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Center(
            child: DropdownButton(
              hint: Text('Please choose a month'), // Not necessary for Option 1
              value: _selectedmonth,
              onChanged: (newValue) {
                setState(() {
                  _selectedmonth = newValue;
                });
              },
              items: months.map((location) {
                return DropdownMenuItem(
                  child: new Text(location),
                  value: location,
                );
              }).toList(),
            ),
          ),
          Center(
            child: Text('Expenses for selected month'),
          ),
          Expanded(
            child: FutureBuilder<List>(
              future: _query(monmap[_selectedmonth]),
              initialData: List(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(

                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, int position) {
                    final item = snapshot.data[position];
                    //get your item data here ...
                    String cat = item['category'];
                    String des = item['description'];
                    String am = item['expenseamount'];
                    String drt = item['expensedate'];
                    return Card(
                      child: ListTile(
                        onLongPress: (){

                          final rr = snapshot.data[position];
                          ss = rr['_id'];
                          showAlertDialog(context,ss);

                        },
                        title: Text(
                            "$des"+"   -  " + "Rs.$am"+"   -  " + "  $cat" + " on "+ "$drt"),
                      ),
                    );

                  },
                )
                    : Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),

    );

  }
}
