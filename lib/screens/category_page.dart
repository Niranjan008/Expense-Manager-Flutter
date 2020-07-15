import 'package:flutter/material.dart';
import 'package:manage_expense/category_database_helper.dart';
class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  final myController = TextEditingController();
  final dbHelper = DatabaseHelper.instance;
  String category_name;
  int ss;
  var lst = new List();
@override
  void initState() {

    super.initState();
  }
  void _delete(id) async {
    // Assuming that the number of rows is the id for the last row
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }
  Future<List> _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    //allRows.forEach((row) => lst.add(row['categoryname']));
    return allRows.toList();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(height: 32.0,),
          Expanded(
            child: TextField(
              controller: myController,
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
                hintText: 'Enter a new Category',
                helperText: '',
                labelText: 'Category',
              ),
            ),
          ),
            Center(
              child: Text(
                "Existing Categories",style: TextStyle(fontSize: 30,fontWeight:FontWeight.bold),
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
                      String ff = item['categoryname'];
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
        ]

        ),
    floatingActionButton: FloatingActionButton(
      onPressed: (){
        category_name  = myController.text;
        _insert();
        setState(() {
          myController.text = '';
        });
      },
      tooltip: 'Create Category',
      child: Icon(Icons.category),
    ),
    );

  }
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
  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnCategoryName : category_name,
      DatabaseHelper.columnCategoryType :1,
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

}

