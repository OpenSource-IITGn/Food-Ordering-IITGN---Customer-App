import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingapp/stuff/googleSheets.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'feedBack.dart';
import 'package:flutter_upi/flutter_upi.dart';

class Tab3 extends StatefulWidget {
  @override
  _Tab3State createState() => _Tab3State();
}

class _Tab3State extends State<Tab3> with AutomaticKeepAliveClientMixin<Tab3> {
  String fullname;
  String email;
  String _username;
  double ratingForItem = 2;
  double ratingForItemActual = 2;
  String token;
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  _adduserinfo() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    List<String> username = firebaseUser.email.toString().split("@");
    String uid2 = firebaseUser.uid;
    List<String> _name = username[0].split(".");
    String name = _name[0][0].toUpperCase() +
        _name[0].substring(1).toLowerCase() +" "+
        _name[1][0].toUpperCase() +
        _name[1].substring(1).toLowerCase();
    setState(() {
      fullname = name;
      email = firebaseUser.email.toString();
      _username = uid2;
    });
  }

  bool showDialogForRating = false;
  @override
  void initState() {
    _adduserinfo();
    showDialogForRating = false;
    super.initState();
  }

  void startPayment(
      double bill,
      String shop_username,
      String shop_name,
      String email,
      String order_id,
      Map item_ids,
      int type,
      String items,
      int unique_no,
      String upiID) async {
    String reply = await FlutterUpi.initiateTransaction(
      app: (type == 0)
          ? FlutterUpiApps.PayTM
          : (type == 1) ? FlutterUpiApps.GooglePay : FlutterUpiApps.BHIMUPI,
      pa: upiID,
      pn: shop_name,
      tr: order_id,
      tn: "Food Order IITGN",
      am: bill.toString(),
      mc: "YourMerchantId", // optional
      cu: "INR",
      url: "https://www.google.com",
    );
    print(reply);

    if (reply.contains("SUCCESS")) {
      Firestore.instance
          .collection('orders')
          .document(order_id)
          .get()
          .then((DocumentSnapshot orderData) {
        CloudFunctions.instance.call(
          functionName: 'orderTransaction',
          parameters: <String, dynamic>{
            'orderData': orderData.data,
            'customer_uid': _username,
            'customer_email': email,
            'customer_name': fullname
          },
        );
      });
      writeData([
        [
          DateTime.now().toString(),
          shop_name,
          order_id.toString(),
          unique_no.toString(),
          fullname,
          email,
          bill.toString(),
          items
        ]
      ], 'Sheet1!A:H');
      Firestore.instance
          .collection("orders")
          .document(order_id)
          .updateData({"status": 3});
      DocumentSnapshot storeData = await Firestore.instance
          .collection("store_data")
          .document(shop_username)
          .get();
      double earning_old = double.parse(storeData.data["earnings"].toString());

      double earning_new = earning_old + bill;
      Firestore.instance
          .collection("store_data")
          .document(shop_username)
          .updateData({"earnings": earning_new});
    }
  }

  showDialogforrating(Map item_ids) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FeedBacks(
                username: email,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    //_adduserinfo();
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 230, 204, 1),
      body: Column(
        children: <Widget>[
          Flexible(
            child: StreamBuilder(
              stream: Firestore.instance.collection('store_data').snapshots(),
              builder: (context, snapshot1) {
                
                String upiID = "";
                return StreamBuilder(
                    stream: Firestore.instance
                        .collection('orders')
                        .where("customer_username", isEqualTo: _username)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                            child: Text(
                          "Your cart is empty, please add some items.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ));
                      int len = snapshot.data.documents.length;
                      //sleep(Duration(seconds: 1));
                      if (len == 0) {
                        return Center(
                            child: Container(
                          child: Text(
                            "No orders",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ));
                      } else {
                        if (len != 0) {
                          if (len != 0) {
                            if (len != 0) {
                              return ListView.builder(
                                itemBuilder: (BuildContext context, int index) {
                                  double bill = double.parse(snapshot
                                      .data.documents[index]["bill"]
                                      .toString());
                                  String date = snapshot
                                      .data.documents[index]["date"]
                                      .toString();
                                  String shop_name = snapshot
                                      .data.documents[index]["shop_name"]
                                      .toString();
                                  String shop_username = snapshot
                                      .data.documents[index]["shop_username"]
                                      .toString();
                                  String time = snapshot
                                      .data.documents[index]["time"]
                                      .toString();
                                  String uusername = snapshot.data
                                      .documents[index]["customer_username"]
                                      .toString();
                                  int status =
                                      snapshot.data.documents[index]["status"];
                                  int unique_no = snapshot.data.documents[index]
                                      ["unique_no"];
                                  String order_id =
                                      snapshot.data.documents[index].documentID;
                                  Map items =
                                      snapshot.data.documents[index]["items"];
                                  Map item_ids = snapshot.data.documents[index]
                                      ["item_ids"];
                                  for (int i = 0;
                                      i < snapshot1.data.documents.length;
                                      i++) {
                                    if (snapshot1.data.documents[i]["shop_uid"]
                                            .toString() ==
                                        shop_username) {
                                      upiID =
                                          snapshot1.data.documents[i]["upiID"];
                                      break;
                                    }
                                  }
                                  List<Widget> itemList = [];
                                  String itemNames = '';
                                  items.forEach((k, v) {
                                    itemNames = itemNames +
                                        k.toString() +
                                        ":" +
                                        v.toString() +
                                        "\n";
                                    itemList.add(new Card(
                                      margin: EdgeInsets.all(3),
                                      color: Colors.white,
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: Text(
                                                  k.toString(),
                                                  overflow: TextOverflow.fade,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 20),
                                                ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    (double.parse(v.toString()))
                                                        .toInt()
                                                        .toString(),
                                                    overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontSize: 20),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                                  });

                                  if (!true) {
                                    return Text("hello");
                                  } else {
                                    return Container(
                                      padding: EdgeInsets.all(15),
                                      margin: EdgeInsets.fromLTRB(7, 7, 7, 0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          color: Colors.white,
                                          boxShadow: [
                                            new BoxShadow(
                                              color: Colors.black12,
                                              offset: new Offset(0, 1),
                                            )
                                          ]),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 0, 10),
                                            child: Text(
                                              shop_name + "",
                                              style: TextStyle(
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 0, 10),
                                            child: Text(
                                              "Order ID - " +
                                                  unique_no.toString(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Column(
                                            children: itemList,
                                          ),
                                          // Column(children: <Widget>[
                                          //   ListView.builder(
                                          //     itemBuilder: (context, index) {
                                          //       return itemList[index];
                                          //     },
                                          //     itemCount: itemList.length,
                                          //   ),
                                          // ]),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          status == 0
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    InkWell(
                                                      onTap: () {
                                                        Object data2 = {
                                                          "status": 1
                                                        };
                                                        Firestore.instance
                                                            .collection(
                                                                "orders")
                                                            .document(order_id)
                                                            .updateData(data2);
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Sent to shopkeeper",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            timeInSecForIos: 1,
                                                            fontSize: 16.0);
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0, 0, 0, 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          color:
                                                              Colors.blueAccent,
                                                        ),
                                                        child: Text(
                                                          "Confirm order",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Firestore.instance
                                                            .collection(
                                                                "orders")
                                                            .document(order_id)
                                                            .delete();
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Order deleted successfully",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            timeInSecForIos: 1,
                                                            fontSize: 16.0);
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0, 0, 0, 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          color: Colors.grey,
                                                        ),
                                                        child: Text(
                                                          "Cancel order",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                          status == 1
                                              ? InkWell(
                                                  child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 0, 0, 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color: Colors.black12,
                                                    ),
                                                    child: Text(
                                                      "Waiting for confirmation",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          status == 2
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                      Text(
                                                        "Pay With",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          startPayment(
                                                              bill,
                                                              shop_username,
                                                              shop_name,
                                                              email,
                                                              order_id,
                                                              item_ids,
                                                              1,
                                                              itemNames,
                                                              unique_no,
                                                              upiID);
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 0, 0, 10),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            color: Colors.green,
                                                          ),
                                                          child: Text(
                                                            "GPay", //TODO: Add Proper Buttons
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          startPayment(
                                                              bill,
                                                              shop_username,
                                                              shop_name,
                                                              email,
                                                              order_id,
                                                              item_ids,
                                                              0,
                                                              itemNames,
                                                              unique_no,
                                                              upiID);
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 0, 0, 10),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            color: Colors.green,
                                                          ),
                                                          child: Text(
                                                            "PayTM",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          startPayment(
                                                              bill,
                                                              shop_username,
                                                              shop_name,
                                                              email,
                                                              order_id,
                                                              item_ids,
                                                              2,
                                                              itemNames,
                                                              unique_no,
                                                              upiID);
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 0, 0, 10),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            color: Colors.green,
                                                          ),
                                                          child: Text(
                                                            "BHIM",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          ),
                                                        ),
                                                      )
                                                    ])
                                              : Container(),
                                          status == 3
                                              ? InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 0, 0, 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color: Colors.orange,
                                                    ),
                                                    child: Text(
                                                      "Order is being prepared",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          status == 4
                                              ? InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 0, 0, 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color: Colors.green,
                                                    ),
                                                    child: Text(
                                                      "Use code : '" +
                                                          unique_no.toString() +
                                                          "' to collect order",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          status == 5
                                              ? Container(
                                                  child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        Text(
                                                          ratingForItem
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                        SmoothStarRating(
                                                          onRatingChanged:
                                                              (value) {
                                                            setState(() {
                                                              if (value -
                                                                      value
                                                                          .floor() >
                                                                  0.5) {
                                                                ratingForItem =
                                                                    (value.floor() +
                                                                            0.5)
                                                                        .toDouble();
                                                              } else {
                                                                ratingForItem =
                                                                    (value.floor())
                                                                        .toDouble();
                                                              }
                                                              ratingForItemActual =
                                                                  value;
                                                            });
                                                          },
                                                          rating:
                                                              ratingForItemActual,
                                                          size: 32,
                                                          starCount: 5,
                                                        ),
                                                      ],
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        var pp = Firestore
                                                            .instance
                                                            .collection(
                                                                shop_username);
                                                        item_ids.forEach(
                                                            (key, val) {
                                                          Future<DocumentSnapshot>
                                                              snap = pp
                                                                  .document(key)
                                                                  .get();
                                                          snap.then((value) {
                                                            double nRating =
                                                                double.parse(value
                                                                    .data[
                                                                        "nRating"]
                                                                    .toString());
                                                            double rating =
                                                                double.parse(value
                                                                    .data[
                                                                        "rating"]
                                                                    .toString());
                                                            double new_nRating =
                                                                (nRating + 1)
                                                                    .toDouble();
                                                            double new_rating =
                                                                (rating * nRating +
                                                                        ratingForItem) /
                                                                    (new_nRating);
                                                            //double final_new_rating = 0;
                                                            if (new_rating -
                                                                    new_rating
                                                                        .floor() >
                                                                0.5) {
                                                              double
                                                                  final_new_rating =
                                                                  (new_rating.floor() +
                                                                          1)
                                                                      .toDouble();
                                                              pp
                                                                  .document(key)
                                                                  .updateData({
                                                                "nRating":
                                                                    new_nRating
                                                                        .toInt(),
                                                                "rating":
                                                                    final_new_rating
                                                                        .toInt(),
                                                                "actual_rating":
                                                                    new_rating
                                                              });
                                                            } else {
                                                              double
                                                                  final_new_rating =
                                                                  new_rating
                                                                      .floor()
                                                                      .toDouble();
                                                              pp
                                                                  .document(key)
                                                                  .updateData({
                                                                "nRating":
                                                                    new_nRating
                                                                        .toInt(),
                                                                "rating":
                                                                    final_new_rating
                                                                        .toInt(),
                                                                "actual_rating":
                                                                    new_rating
                                                              });
                                                            }
                                                          });
                                                        });
                                                        Firestore.instance
                                                            .collection(
                                                                "orders")
                                                            .document(order_id)
                                                            .delete();
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Thanks for rating",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIos: 1,
                                                            fontSize: 16.0);
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0, 15, 0, 0),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          color: Colors.green,
                                                        ),
                                                        child: Text(
                                                          "Done",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ))
                                              : Container(),
                                          status != 5
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        //Text(shop_name,style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),

                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                              "Time: ",
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                            Text(
                                                              time,
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  // fontWeight:
                                                                  //     FontWeight
                                                                  //         .bold,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic),
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                              "Date: ",
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                            Text(
                                                              date,
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  // fontWeight:
                                                                  //     FontWeight
                                                                  //         .bold,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      "Rs. " + bill.toString(),
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                itemCount:
                                    len, //snapshot.data.documents.length,
                              );
                            }
                          }
                        }
                      }
                    });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
