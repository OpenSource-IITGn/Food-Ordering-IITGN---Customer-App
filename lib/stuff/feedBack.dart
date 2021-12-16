

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class FeedBacks extends StatefulWidget {
  String username;

  @override
  FeedBacks({this.username});
  //OneItemDetails({this.item_id,this.shop_username,this.shop_name});
  _FeedBacksState createState() => _FeedBacksState();
}

class _FeedBacksState extends State<FeedBacks> {
  TextEditingController feedbacktext = new TextEditingController();
  TextEditingController titleText = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.s,
          children: <Widget>[
            
            Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                  "Do let us know what you think about any eatery or this app. We will try to improve your experience :)",
                  style: TextStyle(fontSize: 18)),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: TextField(
                maxLines: 1,
                controller: titleText,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(13, 13, 13, 13),
                  hintText: "Title",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.black26)),
                  hintStyle: TextStyle(color: Colors.black54, fontSize: 15),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: TextField(
                maxLines: 5,
                controller: feedbacktext,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(13, 13, 13, 13),
                  hintText: "Feedback",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.black26)),
                  hintStyle: TextStyle(color: Colors.black54, fontSize: 15),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 1, horizontal: 15),
              child: Material(
                elevation: 0.0,
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.deepOrangeAccent,
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  onPressed: () {
                    send_feedback();
                  },
                  child: Text("Send",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 17)),
                ),
              ),
            )
          ],
        ),
        appBar: AppBar(
          title: Text(
            "Feedback",
            style: TextStyle(
                fontSize: 18, color: Colors.orange, fontFamily: "Lobster_Two"),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
        ));
  }

  send_feedback() {
    String _feedbacktext = feedbacktext.text.toString().trim();
    String _titleText = titleText.text.toString().trim();

    if (_feedbacktext == "") {
      Fluttertoast.showToast(
          msg: "Please type something",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 16.0);
    } else {
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      var formatter2 = new DateFormat('hh:mm a');
      String formattedDate = formatter.format(now);
      String formattedTime = formatter2.format(now);
      var data = {
        "title": _titleText,
        "date": formattedDate,
        "time": formattedTime,
        "email": widget.username,
        "report": _feedbacktext
      };
      Firestore.instance.collection("feedbacks").add(data).then((response) {
        Fluttertoast.showToast(
            msg: "Thanks for your feedback. ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            fontSize: 16.0);
        Navigator.pop(context);
      });
    }
  }
}
