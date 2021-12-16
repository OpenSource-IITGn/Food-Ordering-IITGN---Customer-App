import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'oneItemDetails.dart';

class ShopDetailsWithMenu extends StatefulWidget {
  @override
  final String shop_username;
  final String shop_name;
  ShopDetailsWithMenu({this.shop_username, this.shop_name});
  _ShopDetailsWithMenuState createState() => _ShopDetailsWithMenuState();
}

class _ShopDetailsWithMenuState extends State<ShopDetailsWithMenu>
    with AutomaticKeepAliveClientMixin<ShopDetailsWithMenu> {
  @override
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 175,
              backgroundColor: Color.fromRGBO(255, 230, 204, 1),
              title: Container(
                  child: StreamBuilder(
                      stream: Firestore.instance
                          .collection('store_data')
                          .document(widget.shop_username)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                              child: Text(
                            "Loading...",
                            style: TextStyle(fontSize: 20),
                          ));
                        String one_shop_name =
                            snapshot.data["shop_name"].toString();
                        return new Text(
                          one_shop_name,
                          style: TextStyle(fontWeight: FontWeight.normal),
                        );
                      })),
              centerTitle: true,
              elevation: 1,
              floating: false,
              pinned: true,
              snap: false,
              flexibleSpace: new FlexibleSpaceBar(
                background: new Column(
                  children: <Widget>[
                    StreamBuilder(
                        stream: Firestore.instance
                            .collection('store_data')
                            .document(widget.shop_username)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                                child: Text(
                              "Loading...",
                              style: TextStyle(fontSize: 20),
                            ));

                          String one_shop_name =
                              snapshot.data["shop_name"].toString();
                          String one_close_time =
                              snapshot.data["close_time"].toString();
                          String one_open_time =
                              snapshot.data["open_time"].toString();
                          String one_shop_description =
                              snapshot.data["shop_description"].toString();
                          bool one_shop_open = snapshot.data["open"];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    top: 80, left: 15, right: 15),
                                child: Text(
                                  one_shop_description,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Open from " +
                                      one_open_time +
                                      " to " +
                                      one_close_time,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 10),
                                child: one_shop_open
                                    ? Material(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            "Now Open",
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                        color: Colors.green,
                                      )
                                    : Material(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            "Closed",
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                        color: Colors.red,
                                      ),
                              )
                            ],
                          );
                        })
                  ],
                ),
              ),
            ),
          ];
        },
        body: Container(
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection(widget.shop_username)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                      child: Text(
                    "Loading, please wait...",
                    style: TextStyle(fontSize: 20),
                  ));
                return ListView.builder(
                  // padding: EdgeInsets.only(left: 5, right: 5),
                  itemBuilder: (BuildContext context, int index) {
                    String item_id =
                        snapshot.data.documents[index].documentID.toString();
                    String category =
                        snapshot.data.documents[index]['category'].toString();
                    String cost = "Rs. " +
                        snapshot.data.documents[index]['cost'].toString();
                    String name =
                        snapshot.data.documents[index]['name'].toString();
                    bool check_box = snapshot.data.documents[index]['checkbox'];
                    return Card(
                      color: Colors.orange,
                      elevation: 0,
                      margin: EdgeInsets.all(1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          InkWell(
                            //color: Colors.white,
                            //padding: EdgeInsets.only(left: 0,right: 0,top: 5,bottom: 1),
                            onTap: () {
                              //_open_oneitempage(item_id);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OneItemDetails(
                                          item_id: item_id,
                                          shop_username: widget.shop_username,
                                          shop_name: widget.shop_name,
                                        )),
                              );
                            },
                            child: Material(
                              borderOnForeground: true,
                              elevation: 0,
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, top: 15, bottom: 15),
                                child: Stack(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: Text(
                                              name,
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87),
                                            )),
                                        Container(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(
                                            category,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(
                                            cost,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(
                                            top: 30,
                                            right: 0,
                                            bottom: 0,
                                            left: 0),
                                        alignment: AlignmentDirectional(1, 3),
                                        child: check_box
                                            ? Material(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Container(
                                                  padding: EdgeInsets.all(8),
                                                  child: Text(
                                                    "Available",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                                color: Colors.green,
                                              )
                                            : Material(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Container(
                                                  padding: EdgeInsets.all(8),
                                                  child: Text(
                                                    "Unavailable",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                                color: Colors.red,
                                              )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            color: Color.fromRGBO(230, 230, 230, 1),
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: snapshot.data.documents.length,
                );
              }),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
