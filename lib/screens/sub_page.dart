import 'package:flutter/material.dart';
import 'package:manage_expense/category_database_helper.dart';
class SubCategoryPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SubCategoryPage> {
  final dbHelper = DatabaseHelper.instance;
  String _selectedvalue;
  String sub_category_name;
  final myController = TextEditingController();
  final List<String> lst = new List<String>();
  String ll;
  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnCategoryName : sub_category_name,
      DatabaseHelper.columnCategoryType :2,
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }
  showAlertDialog(BuildContext context,String ss) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        _selectedvalue = ss;
        setState(() {

        });
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Select"),
      content: Text("Are you sure want to select  $ss"),
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
  Future<List> _query() async {
    final allRows = await dbHelper.queryonlycat();
    print('query all rows:');
    //allRows.forEach((row) => lst.add(row['categoryname']));
    return allRows.toList();
  }
  @override
  void initState() {
    _query();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Center(child: Text('Select Category(Long press to select)'),),
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
                          ll = rr['categoryname'];
                          showAlertDialog(context,ll);

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
                  hintText: 'Enter the sub category',
                  helperText: '',
                  labelText: 'Sub Category',
                ),
                controller: myController,


              ),
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(_selectedvalue != null && myController.text != null) {
            sub_category_name = _selectedvalue + "/" + myController.text;
            _insert();
            setState(() {
              myController.text = '';
            });
          }
        },
        tooltip: 'Create Category',
        child: Icon(Icons.category),
      ),
    );
  }
}

