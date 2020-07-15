import 'package:flutter/material.dart';
import 'package:manage_expense/payment_database_helper.dart';
import 'package:manage_expense/expense_database_helper.dart';
import 'package:pie_chart/pie_chart.dart';
class PaymentReport extends StatefulWidget {
  @override
  _PaymentReportState createState() => _PaymentReportState();
}

class _PaymentReportState extends State<PaymentReport> {
  String _selectedmonth,_selectedmonth1;
  bool _loadChar = false;
  final paydbHelper = PaymentDatabaseHelper.instance;
  final dbhelper = DatabaseHelpers.instance;
  Map<String, double> data = new Map();
  List<String> months = ['JAN', 'FEB', 'MAR', 'APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC']; // Option 2
  var monmap = {'JAN':1, 'FEB':2, 'MAR':3, 'APR':4,'MAY':5,'JUN':6,'JUL':7,'AUG':8,'SEP':9,'OCT':10,'NOV':11,'DEC':12};
  Future<List> _query(int mon,int mon1) async {
    final allRows = await dbhelper.getpayreport(mon,mon1);
    print('query all rows:');
    //allRows.forEach((row) => lst.add(row['categoryname']));
    return allRows.toList();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Center(
            child: DropdownButton(
              hint: Text('Please choose a starting month'), // Not necessary for Option 1
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
            child: DropdownButton(
              hint: Text('Please choose a ending month'), // Not necessary for Option 1
              value: _selectedmonth1,
              onChanged: (newValue) {
                setState(() {
                  _selectedmonth1 = newValue;
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
          FutureBuilder<List>(
            future: _query(monmap[_selectedmonth],monmap[_selectedmonth1]),
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
                  String ff = item['paytype'];
                  int dd = item['sum(expenseamount)'];
                  data.addAll({ff:dd.toDouble()});
                  return Card(
                    child: ListTile(
                      onLongPress: (){

                        final rr = snapshot.data[position];




                      },
                      title: Text(
                          "$ff" + "        --        " + "$dd"),
                    ),
                  );

                },
              )
                  : Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          RaisedButton(
            color: Colors.blue,
            child: Text('Click to Show Chart', style: TextStyle(
                color: Colors.white
            ),),
            onPressed: () {
              setState(() {
                _loadChar = true;
              });
            },

          ),
          _loadChar ? Center(
            child: PieChart(
              dataMap: data,
              // if not declared, random colors will be chosen
              animationDuration: Duration(milliseconds: 1500),
              chartLegendSpacing: 32.0,
              chartRadius: MediaQuery.of(context).size.width /
                  2.7, //determines the size of the chart
              showChartValuesInPercentage: true,
              showChartValues: true,
              showChartValuesOutside: false,
              chartValueBackgroundColor: Colors.grey[200],
              showLegends: true,
              legendPosition:
              LegendPosition.right, //can be changed to top, left, bottom
              decimalPlaces: 1,
              showChartValueLabel: true,
              initialAngle: 0,
              chartValueStyle: defaultChartValueStyle.copyWith(
                color: Colors.blueGrey[900].withOpacity(0.9),
              ),
              chartType: ChartType.disc, //can be changed to ChartType.ring
            ),
          ) : SizedBox(
            height: 150,
          ),

        ],
      ),
    );
  }
}
