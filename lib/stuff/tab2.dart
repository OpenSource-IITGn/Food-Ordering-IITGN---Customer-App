
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'shopDetailsWithMenu.dart';

class Tab2 extends StatefulWidget {
  @override
  _Tab2State createState() => _Tab2State();
}

class _Tab2State extends State<Tab2> with AutomaticKeepAliveClientMixin<Tab2> {
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(255, 230, 204, 1),
      // color: Colors.white,
      child: StreamBuilder(
          stream: Firestore.instance.collection('store_data').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                  child: Text(
                "Loading, please wait...",
                style: TextStyle(fontSize: 20),
              ));
            return ListView.builder(
              controller: _controller,
              itemBuilder: (BuildContext context, int index) {
                String shop_username =
                    snapshot.data.documents[index].documentID.toString();
                String close_time =
                    snapshot.data.documents[index]['close_time'].toString();
                String open_time =
                    snapshot.data.documents[index]['open_time'].toString();
                String shop_name =
                    snapshot.data.documents[index]['shop_name'].toString();
                String shop_description = snapshot
                    .data.documents[index]['shop_description']
                    .toString();
                bool open = snapshot.data.documents[index]['open'];
                return Card(
                  margin: EdgeInsets.fromLTRB(1,0,1,2),
                  elevation: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      InkWell(
                        //color: Colors.white,
                        //padding: EdgeInsets.only(left: 0,right: 0,top: 5,bottom: 1),
                        onTap: () {
                          _open_shopmenu(shop_username, shop_name);
                        },
                        child: Material(
                          borderOnForeground: false,
                          elevation: 0,
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, top: 15, bottom: 15),
                            child: Stack(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        child: Text(
                                      shop_name,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87),
                                    )),
                                    Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        open_time + " to " + close_time,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        shop_description,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black87),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                    padding: EdgeInsets.all(8),
                                    alignment: AlignmentDirectional(1, 3),
                                    child: open
                                        ? Material(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              child: Text(
                                                "Open",
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
                                                "Closed",
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
    );
  }

  _open_shopmenu(String shop_username, String shop_name) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ShopDetailsWithMenu(
                  shop_username: shop_username,
                  shop_name: shop_name,
                )));

    /*Fluttertoast.showToast(
        msg: shop_username,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black26,
        textColor: Colors.white,
        fontSize: 16.0
        );*/
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

