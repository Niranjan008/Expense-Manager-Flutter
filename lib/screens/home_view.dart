import 'package:flutter/material.dart';
import 'package:manage_expense/payment_database_helper.dart';
class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final dbHelper = PaymentDatabaseHelper.instance;
  String payment_mode;
  int ss;
  void _delete(id) async {
    // Assuming that the number of rows is the id for the last row
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }
  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      PaymentDatabaseHelper.columnPaymentName : payment_mode,
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }
  @override
  void initState() {
    super.initState();
  }
  Future<List> _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    return allRows.toList();
  }
  @override
  Widget build(BuildContext context)  {
    final myController = TextEditingController();
    showAlertDialog(BuildContext context,int ss) {
      // Create button
      Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
          _delete(ss);
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

    return Scaffold(
      body: Column(
        children: <Widget>[
          Center(child: Text('Add Payment Type',style:
            TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),),
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
                  hintText: 'Enter your Payment Mode',
                  helperText: '',
                  labelText: 'Payment Mode',
                ),
                controller: myController,

              ),
            ),
          ),
          Center(
            child: Text(
              "Existing Modes",style: TextStyle(fontSize: 30,fontWeight:FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List>(
              future: _query(),
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
                    String ff = item['paymentname'];
                    return Card(
                      child: ListTile(
                        onLongPress: (){

                          final rr = snapshot.data[position];
                          ss = rr['_id'];
                          showAlertDialog(context,ss);

                        },
                        title: Text(
                            "$ff"),
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          payment_mode  = myController.text;
          _insert();
          setState(() {
            myController.text = '';
          });
        },
        tooltip: 'Create Payment Mode',
        child: Icon(Icons.payment),
      ),
    );
  }
}

