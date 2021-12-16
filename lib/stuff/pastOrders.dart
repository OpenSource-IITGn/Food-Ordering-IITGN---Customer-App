import 'package:flutter/material.dart';
import 'package:foodorderingapp/stuff/googleSheets.dart';

class PastOrders extends StatefulWidget {
  String email;
  PastOrders(this.email);
  @override
  _PastOrdersState createState() => _PastOrdersState();
}

class _PastOrdersState extends State<PastOrders> {
  var transactions = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() async {
    transactions = [];
    await getData('Transactions!A2:H').then((val) {
      val.forEach((l) {
        print(widget.email.toString());
        if (l[5] == widget.email.toString()) {
          var x = [];
          x.add(l[0].toString()); //timestamp
          x.add(l[1].toString()); //shop
          x.add(l[3].toString()); //uid
          x.add(l[6].toString()); //Cost
          x.add(l[7].toString()); //Items
          transactions.add(x);
          print(x[0]);
          print(transactions[0]);
        }
      });

      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Past Orders"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                loading = true;
              });
              refresh();
            },
          )
        ],
        centerTitle: true,
      ),
      body: Center(
        child: (loading)
            ? CircularProgressIndicator()
            : Container(
                child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(child: Text(transactions[index][4],style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 25),),),
                        
                       
                        
                        Text(
                          "Cost: Rs. " + transactions[index][3],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          transactions[index][1],
                          style: TextStyle(color: Colors.black.withAlpha(100),
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          "Timestamp: " + transactions[index][0],
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 15),
                        ),
                         Text("PIN:" + transactions[index][2]),
                        
                      ],
                    ),
                  ));
                },
                itemCount: transactions.length,
              )),
      ),
    );
  }
}
