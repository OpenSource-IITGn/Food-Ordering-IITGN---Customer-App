import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../crud.dart';
import 'getData.dart';

class ItemCart extends StatefulWidget {
  @override
  //OneItemDetails({this.item_id,this.shop_username,this.shop_name});
  _ItemCartState createState() => _ItemCartState();
}

class _ItemCartState extends State<ItemCart> {
  List<List<String>> finalCart;
  Set<String> keys;

  @override
  void initState() {
    getKeysfromCart().then((res) {
      keys = res;
      List<String> x = [];
      res.forEach((val) {
        if (val.contains('!')) {
          x.add(val);
        }
      });
      x.forEach((v) {
        keys.remove(v);
      });
      setState(() {});
      List<List<String>> carts = new List(res.length);
      int i = 0;

      for (String x in keys) {
        print(x.contains('!'));
        // if (!x.contains('!')) {
        if (true) {
          print(x);
          getfromCart(x).then((res2) {
            setState(() {
              carts[i] = res2;
              if (i == keys.length - 1) {
                finalCart = carts;
              }
              i++;
            });
          });
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 230, 204, 1),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Cart",
          style: TextStyle(fontSize: 18, color: Colors.orange),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: finalCart != null
                ? ListView.builder(
                    itemBuilder: (BuildContext context, int i) {
                      double bill = double.parse(finalCart[i][0]);
                      String date = finalCart[i][2];
                      String shop_name = finalCart[i][8];
                      String shop_username = finalCart[i][4];
                      String time = finalCart[i][6];
                      int status = int.parse(finalCart[i][5]);
                      int unique_no = int.parse(finalCart[i][7]);
                      String uusername = finalCart[i][1];
                      print(finalCart);
                      List<String> item_list =
                          finalCart[i][3].split("``newitem``");
                      List<String> itemIds = [];
                      item_list.forEach((x) {
                        itemIds.add(x.split("`##:##`")[2]);
                      });
                      List<int> qty;

                      List<Widget> itemList = [];
                      print(item_list);

                      qty = [];
                      item_list.forEach((x) {
                        qty.add(num.parse(x.split("`##:##`")[1]));
                      });

                      print(qty);
                      for (int i = 0; i < item_list.length; i++) {
                        itemList.add(new Card(
                          margin: EdgeInsets.all(3),
                          color: Colors.white,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      item_list[i].split("`##:##`")[0],
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    ),
                                  ),
                                  // SizedBox(width: 25),
                                  Container(
                                    child: Text(
                                      qty[i].toString(),
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 27),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));
                      }

                      return ConstrainedBox(
                        child: Card(
                          color: Colors.white,
                          margin: EdgeInsets.fromLTRB(7, 7, 7, 0),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: Text(
                                    "Order to " + shop_name,
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  color: Colors.white24,
                                  height:
                                      MediaQuery.of(context).size.height / 2 -
                                          50,
                                  child: Scrollbar(
                                    child: Column(
                                      // shrinkWrap: true,

                                      children: itemList,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Total Cost: ",
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      "Rs. " + bill.toString(),
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Time of ordering: ",
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      time,
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Date of ordering: ",
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      date,
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                status == 0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          //
                                          FlatButton(
                                            padding: EdgeInsets.all(8),
                                            shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        12.0)),
                                            onPressed: () {
                                              Map<String, Object> items =
                                                  new Map();
                                              item_list.forEach((x) {
                                                items[x.split("`##:##`")[0]] =
                                                    double.parse(
                                                        x.split("`##:##`")[1]);
                                              });
                                              Map<String, Object> item_ids =
                                                  new Map();
                                              item_list.forEach((x) {
                                                item_ids[
                                                        x.split("`##:##`")[2]] =
                                                    x.split("`##:##`")[2];
                                              });
                                              var data = {
                                                "bill": bill,
                                                "customer_username": uusername,
                                                "date": date,
                                                "items": items,
                                                "shop_username": shop_username,
                                                "status": 1,
                                                "time": time,
                                                "unique_no": unique_no,
                                                "shop_name": shop_name,
                                                "item_ids": item_ids
                                              };
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title:
                                                          Text("Are you sure?"),
                                                      content: Text(
                                                          "An order once confirmed cannot be cancelled. Kindly make sure that you have the correct items."),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          child: Text("Cancel"),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        FlatButton(
                                                          child:
                                                              Text("Confirm"),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            orderItem(
                                                                data,
                                                                shop_username,
                                                                false);
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  });
                                            },
                                            color: Colors.blue,
                                            child: Text(
                                              "Confirm order",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                          ),
                                          FlatButton(
                                            padding: EdgeInsets.all(8),
                                            shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        12.0)),
                                            onPressed: () {
                                              orderItem("nothing",
                                                  shop_username, true);
                                            },
                                            color: Colors.grey,
                                            child: Text(
                                              "Empty cart",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                        constraints: BoxConstraints(
                            minHeight: 0,
                            maxHeight:
                                MediaQuery.of(context).size.height - 100),
                      );
                    },
                    itemCount: finalCart.length,
                  )
                : Container(
                    margin: EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        "Your cart is empty.",
                        style: TextStyle(fontSize: 18),
                      ),
                    )),
          )
        ],
      ),
    );
  }

  orderItem(Object data, String shop_username, bool delete) async {
    if (!delete) {
      CrudMethods().addData("orders", data).then((result) {
        Fluttertoast.showToast(
            msg: "Order sent to shopkeeper, track in orders",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            fontSize: 16.0);
      });
    } else {
      Fluttertoast.showToast(
          msg: "Item Removed from cart.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 16.0);
    }

    SharedPreferences pre = await SharedPreferences.getInstance();

    setState(() {
      pre.remove(shop_username);
    });
    Navigator.pop(context);
  }
}
