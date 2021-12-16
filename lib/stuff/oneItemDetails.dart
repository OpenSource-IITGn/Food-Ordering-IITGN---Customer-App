import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../crud.dart';
import 'getData.dart';
import 'itemCart.dart';

class OneItemDetails extends StatefulWidget {
  @override
  final String item_id;
  final String shop_username;
  final String shop_name;
  OneItemDetails({this.item_id, this.shop_username, this.shop_name});
  _OneItemDetailsState createState() => _OneItemDetailsState();
}

class _OneItemDetailsState extends State<OneItemDetails> {
  @override
  int _itemCount = 1;
  double rating = 4;
  int cost = 20;
  String fullname;
  String email;
  String _username;
  String item_id_found;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add Item to Cart (" + widget.shop_name + ")",
          style: TextStyle(fontSize: 18, color: Colors.orange),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection(widget.shop_username)
              .document(widget.item_id)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                  child: Text(
                "Loading, please wait...",
                style: TextStyle(fontSize: 10),
              ));
            String item_name = snapshot.data["name"].toString();
            String item_id = snapshot.data.documentID;
            String item_category =
                snapshot.data["category"].toString() + "\n\nf";
            int item_cost = snapshot.data["cost"];

            bool item_checkbox = snapshot.data["checkbox"];
            double rating = snapshot.data["rating"].toDouble();
            int nRating = snapshot.data["nRating"];
            return Container(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(
                                  snapshot.data["name"].toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                snapshot.data["category"].toString(),
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Rs. " + snapshot.data["cost"].toString(),
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                              snapshot.data["checkbox"]
                                  ? Text(
                                      "Available",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.green),
                                    )
                                  : Text(
                                      "Not Available",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.red),
                                    ),
                            ],
                          ),
                        ),
                        Center(
                            child: Column(
                          children: <Widget>[
                            Text(
                              (rating).toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 22),
                            ),
                            SmoothStarRating(
                              rating: rating,
                              size: 15,
                              starCount: 5,
                            )
                          ],
                        ))
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Color.fromRGBO(255, 230, 204, 1)),
                  ),
                  Container(
                      child: Text(nRating.toString() +
                          " People have ordered this item.")),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Total Quantity",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                new IconButton(
                                    icon: new Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (_itemCount != 1) {
                                          _itemCount--;
                                        }
                                      });
                                    }),
                                Text(
                                  _itemCount.toString(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 19),
                                ),
                                new IconButton(
                                    icon: new Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        _itemCount++;
                                      });
                                    })
                              ],
                            ),
                          )
                        ]),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Total Amount",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 25, 0),
                            child: Text(
                              "Rs. " + (_itemCount * item_cost).toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ]),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      item_checkbox
                          ? Container(
                              margin: EdgeInsets.all(25),
                              child: Material(
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.orange,
                                child: FlatButton(
                                  padding: EdgeInsets.all(8),
                                  child: Text("Add to cart",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15)),
                                  onPressed: () {
                                    var now = new DateTime.now();
                                    var formatter =
                                        new DateFormat('yyyy-MM-dd');
                                    var formatter2 = new DateFormat('hh:mm a');
                                    String formattedDate =
                                        formatter.format(now);
                                    String formattedTime =
                                        formatter2.format(now);
                                    var rand =
                                        new Random(); // can get a seed as a parameter

                                    // Integer between 0 and 100 (0 can be 100 not)
                                    var num2 = rand.nextInt(100000);

                                    _adduserinfo().then((ss) {
                                      getKeysfromCart().then((res) {
                                        int lenghtofres = res.length;
                                        if (lenghtofres == 0) {
                                          String item_list = item_name +
                                              "`##:##`" +
                                              _itemCount.toString() +
                                              "`##:##`" +
                                              item_id;
                                          List<String> myCartOrderList = [
                                            (item_cost * _itemCount).toString(),
                                            _username,
                                            formattedDate,
                                            item_list,
                                            widget.shop_username,
                                            "0",
                                            formattedTime,
                                            num2.toString(),
                                            widget.shop_name
                                          ];

                                          savetoCart(myCartOrderList)
                                              .then((bool committed) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ItemCart()),
                                            );
                                          });
                                        }
                                        int i = 0;

                                        for (String x in res) {
                                          bool matched = false;
                                          if (x == widget.shop_username) {
                                            matched = true;
                                            getfromCart(x).then((listcame) {
                                              String newCost =
                                                  (double.parse(listcame[0]) +
                                                          item_cost *
                                                              _itemCount)
                                                      .toString();
                                              List<String> item_list =
                                                  listcame[3]
                                                      .split("``newitem``");
                                              for (int j = 0;
                                                  j < item_list.length;
                                                  j++) {
                                                if (item_list[j]
                                                        .split("`##:##`")[0] ==
                                                    item_name) {
                                                  String new_no_of_that_item =
                                                      (int.parse(item_list[j].split(
                                                                      "`##:##`")[
                                                                  1]) +
                                                              _itemCount)
                                                          .toString();
                                                  List<String> newList =
                                                      item_list;
                                                  newList.removeAt(j);
                                                  newList.add(item_name +
                                                      "`##:##`" +
                                                      new_no_of_that_item +
                                                      "`##:##`" +
                                                      item_id);
                                                  //done
                                                  String itemLIST = newList
                                                      .join("``newitem``");

                                                  //if no shop_existed_then
                                                  //String item_list = item_name+"`##:##`"+_itemCount.toString();
                                                  List<String> myCartOrderList =
                                                      [
                                                    newCost,
                                                    _username,
                                                    formattedDate,
                                                    itemLIST,
                                                    widget.shop_username,
                                                    "0",
                                                    formattedTime,
                                                    num2.toString(),
                                                    widget.shop_name
                                                  ];

                                                  savetoCart(myCartOrderList)
                                                      .then((bool committed) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ItemCart()),
                                                    );
                                                  });
                                                } else {
                                                  if (j ==
                                                      item_list.length - 1) {
                                                    //if no shop_existed_then
                                                    //String item_list = item_name+"`##:##`"+_itemCount.toString();
                                                    List<String>
                                                        myCartOrderList = [
                                                      newCost,
                                                      _username,
                                                      formattedDate,
                                                      listcame[3] +
                                                          "``newitem``" +
                                                          item_name +
                                                          "`##:##`" +
                                                          _itemCount
                                                              .toString() +
                                                          "`##:##`" +
                                                          item_id,
                                                      widget.shop_username,
                                                      "0",
                                                      formattedTime,
                                                      num2.toString(),
                                                      widget.shop_name
                                                    ];

                                                    savetoCart(myCartOrderList)
                                                        .then((bool committed) {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ItemCart()),
                                                      );
                                                    });
                                                  }
                                                }
                                                ;
                                              }
                                            });
                                          }
                                          if (i == res.length - 1) {
                                            if (!matched) {
                                              //no shop found
                                              //if no shop_existed_then
                                              String item_list = item_name +
                                                  "`##:##`" +
                                                  _itemCount.toString() +
                                                  "`##:##`" +
                                                  item_id;
                                              List<String> myCartOrderList = [
                                                (item_cost * _itemCount)
                                                    .toString(),
                                                _username,
                                                formattedDate,
                                                item_list,
                                                widget.shop_username,
                                                "0",
                                                formattedTime,
                                                num2.toString(),
                                                widget.shop_name
                                              ];
                                              print(myCartOrderList);

                                              savetoCart(myCartOrderList)
                                                  .then((bool committed) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ItemCart()),
                                                );
                                              });
                                            }
                                          }
                                          i++;
                                        }
                                      });
                                    });
                                    /*
                              var x = GetData2().get(widget.shop_username,_username);
                              x.then((QuerySnapshot docs){
                                int a = docs.documents.length;
                                int num=0;
                                //List<Object> orders_list = new List(a);
                                if(a==0){
                                  data = {
                                    "bill":item_cost*_itemCount,
                                    "customer_username":_username,
                                    "date":formattedDate,
                                    "items":{item_name:_itemCount},
                                    "shop_username":widget.shop_username,
                                    "status":0,
                                    "time":formattedTime,
                                    "unique_no":num2,
                                    "shop_name":widget.shop_name
                                  };
                                  orderItem(data);
                                } else {
                                  double bill_new = (item_cost*_itemCount).toDouble();
                                  Object item_id_found2 = docs.documents[0].documentID; //// First because not other possible
                                  Map items_old = docs.documents[0].data["items"];
                                  double bill_old = docs.documents[0].data["bill"].toDouble();
                                  if(items_old.containsKey(item_name)){
                                    items_old[item_name]+=_itemCount;
                                  }
                                  else {
                                    items_old[item_name]=_itemCount;
                                  }
                                  var data2 = {"items":items_old,"bill":bill_old+bill_new};
                                  Firestore.instance.collection("orders").document(item_id_found2).updateData(data2);
                                  Fluttertoast.showToast(
                                      msg: "Item updated, confirm in cart to proceed.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIos: 1,
                                      backgroundColor: Colors.black26,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );

                                }
                                data = {
                                  "bill":item_cost*_itemCount,
                                  "customer_username":_username,
                                  "date":formattedDate,
                                  "items":{item_name:_itemCount},
                                  "shop_username":widget.shop_username,
                                  "status":0,
                                  "time":formattedTime,
                                  "unique_no":num
                                };
                              } );
                            */
                                    //orderItem(data);
                                  },
                                ),
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.all(15),
                              child: Center(
                                  child: Text(
                                "Cannot order unavailable items",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.red),
                              )),
                            )
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }

  Future<String> _adduserinfo() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    List<String> username = firebaseUser.email.toString().split("@");
    String uid2 = firebaseUser.uid;
    String _name = username[0].split(".")[0];
    String name = _name[0].toUpperCase() + _name.substring(1).toLowerCase();
    setState(() {
      fullname = name;
      email = firebaseUser.email.toString();
      _username = uid2;
    });
    return name;
  }

  orderItem(Object data) {
    CrudMethods().addData("orders", data).then((result) {
      Fluttertoast.showToast(
          msg: "Item added, confirm in cart to proceed.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 16.0);
    });
    Navigator.pop(context);
  }
}
