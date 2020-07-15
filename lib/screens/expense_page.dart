import 'dart:async';
import 'package:flutter/material.dart';
import 'package:manage_expense/expense_database_helper.dart';
import 'package:manage_expense/category_database_helper.dart';
import 'package:manage_expense/payment_database_helper.dart';
class ExpensePage extends StatefulWidget {
  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  DateTime selectedDate = DateTime.now();
  String expenseAmount,_selectedvalue1,_selectedvalue3;
  String ss,desc;
  final List<String> lst = new List<String>();
   List<String> lst1 = new List<String>();
  final List<String> lst2 = new List<String>();
  final dbHelper = DatabaseHelper.instance;
  final dbHelpers = DatabaseHelpers.instance;
  final myController = TextEditingController();
  final myControllerdes = TextEditingController();
  final modedbhelper = PaymentDatabaseHelper.instance;
  String _selectedvalue;
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

   _query() async {
    final allRows = await dbHelper.queryonlycat();
    print('query all rows:');
    allRows.forEach((row) => lst.add(row['categoryname']));
    // return allRows.toList();
  }
  _query1() async {
    final allRows = await dbHelper.queryonlysubcat();
    print('query all rows:');
    allRows.forEach((row) => lst1.add(row['categoryname']));
    // return allRows.toList();
  }
  _query2() async {
    final allRows = await modedbhelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => lst2.add(row['paymentname']));
    // return allRows.toList();
  }
  @override
  void initState() {
    _query();
    _query1();
    _query2();
    super.initState();
  }
  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelpers.columnExpenseAmount : expenseAmount,
      DatabaseHelpers.columnDate: ss,
      DatabaseHelpers.columnCategory:_selectedvalue,
      DatabaseHelpers.columnMonth:ss.substring(5,7),
      DatabaseHelpers.columnCattype:1,
      DatabaseHelpers.columnSubtype:'main',
      DatabaseHelpers.columnPaytype:_selectedvalue3,
      DatabaseHelpers.columnDescription:desc
    };
    final id = await dbHelpers.insert(row);
    print('inserted row id: $id');
  }

  void _insert1() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelpers.columnExpenseAmount : expenseAmount,
      DatabaseHelpers.columnDate: ss,
      DatabaseHelpers.columnCategory:_selectedvalue1,
      DatabaseHelpers.columnMonth:ss.substring(5,7),
      DatabaseHelpers.columnCattype:2,
      DatabaseHelpers.columnSubtype:_selectedvalue,
      DatabaseHelpers.columnPaytype:_selectedvalue3,
      DatabaseHelpers.columnDescription:desc
    };
    final id = await dbHelpers.insert(row);
    print('inserted row id: $id');
  }
  @override
  Widget build(BuildContext context) {


      return SingleChildScrollView(
        child:Column(
          children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: new Theme(
                    data: new ThemeData(
                      primaryColor: Colors.redAccent,
                      primaryColorDark: Colors.red,
                    ),

                    child: TextField(
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal)),
                        hintText: 'Enter your Expense amount',
                        helperText: 'Think twice before you spend',
                        labelText: 'Expense',
                      ),
                      controller: myController,
                      keyboardType: TextInputType.number,

                  ),
                  ),
                ),

            Row(

              children: [Expanded(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  onPressed: () => _selectDate(context),
                  child: Text('Select date'),
                ),
              ),]
            ),
            Container(

                child: Text("Selected Date : "+"${selectedDate.toLocal()}".split(' ')[0])),
            SizedBox(height: 20.0,),

            Row(
              children:[ Expanded(

                child: new DropdownButton<String>(
                  value: _selectedvalue,
                  hint:Text('Select the Category of Expense to be added!'),
                  items: lst.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                        child: new Text(value)

                    );
                  }).toList(),
                  onChanged: (newval) {

                    setState(() {

                      _selectedvalue = newval;
                    });
                  },
                )
              ),]
            ),
            Row(
                children:[ Expanded(

                    child: new DropdownButton<String>(
                      value: _selectedvalue1,
                      hint:Text('Select the Sub-Category of Expense to add!'),
                      items: lst1.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (newval) {

                        setState(() {
                          _selectedvalue1 = newval;
                        });
                      },
                    )
                ),]
            ),
            Row(
                children:[ Expanded(

                    child: new DropdownButton<String>(
                      value: _selectedvalue3,
                      hint:Text('Select the Mode of payment to be added!'),
                      items: lst2.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (newval) {

                        setState(() {
                          _selectedvalue3 = newval;
                        });
                      },
                    )
                ),]
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: new Theme(
                data: new ThemeData(
                  primaryColor: Colors.redAccent,
                  primaryColorDark: Colors.red,
                ),

                child: TextField(
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                    hintText: 'Enter Expense description',
                    helperText: '',
                    labelText: 'Description',
                  ),
                  controller: myControllerdes,

                ),
              ),
            ),
            RaisedButton(
              onPressed: () {
                if(_selectedvalue != null && _selectedvalue1 == null) {
                  expenseAmount = myController.text;
                  desc = myControllerdes.text;
                  ss = "${selectedDate.toLocal()}".split(' ')[0];
                  _insert();
                }
                else if(_selectedvalue1!=null && _selectedvalue!=null){
                  expenseAmount = myController.text;
                  ss = "${selectedDate.toLocal()}".split(' ')[0];
                  desc = myControllerdes.text;
                  _insert();
                  _insert1();
                }
                setState(() {
                  myController.text ='';
                  myControllerdes.text ='';
                });
              },
              child: Text('Add Expense'),
            ),
          ],
        ),
      );
  }
}
