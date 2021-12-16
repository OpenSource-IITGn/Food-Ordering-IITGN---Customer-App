//References
//UI inspirations https://www.youtube.com/watch?v=GeMJz3EcBgs&t=2826s
//Misc https://www.youtube.com/results?search_query=raja+yogan+flutter
//LOGIN-SIGNUP-SYSTEM-CODE https://github.com/bizz84/firebase-login-flutter/
//https://github.com/rxlabz/speech_recognition/blob/master/example/lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:foodorderingapp/stuff/aboutUs.dart';
import 'package:foodorderingapp/stuff/feedBack.dart';
import 'package:foodorderingapp/stuff/itemCart.dart';
import 'package:foodorderingapp/stuff/notify.dart';
import 'package:foodorderingapp/stuff/pastOrders.dart';
import 'package:foodorderingapp/stuff/tab1.dart';
import 'package:foodorderingapp/stuff/tab2.dart';
import 'package:foodorderingapp/stuff/tab3.dart';
import 'auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;
  NotifShow notify = new NotifShow();
  bool showBadge = false;
  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  final _pageOptions = [Tab1(), Tab2(), Tab3()];

  String fullname = "sdsdf";
  String email = "csd";
  String userid = '';
 
  // @override
  void initState() {
    _adduserinfo();
    super.initState();
    Future<FirebaseUser> fu = FirebaseAuth.instance.currentUser();
    fu.then((fu) {
      email = fu.email;
      print(email);
      Firestore.instance
          .collection('orders')
          .where("customer_username", isEqualTo: fu.uid)
          .snapshots()
          .listen((querySnapshot) {
        querySnapshot.documentChanges.forEach((change) {
          int status = change.document.data["status"];
          int pin = change.document.data["unique_no"];
          switch (status) {
            case 1:
              print(showBadge.toString());
              notify.showNotification(
                  "Order placed! Waiting for approval from shop.");
              setState(() {
                showBadge = true;
              });
              break;
            case 2:
              notify
                  .showNotification("Order approved, Please pay to continue.");
              setState(() {
                showBadge = true;
              });
              break;
            case 3:
              notify.showNotification(
                  "Payment received. Your order is being prepared!.");
              setState(() {
                showBadge = true;
              });
              break;
            case 4:
              notify.showNotification(
                  "Order is ready! Please collect your order with pin: " +
                      pin.toString());
              setState(() {
                showBadge = true;
              });
              break;
            case 5:
              notify.showNotification("Order collected! Rate your experience.");
              setState(() {
                showBadge = true;
              });
              break;
            //"Payment Received. Your order is being prepared"

          }
        });
      });

      setState(() {
        firebaseMessaging.subscribeToTopic(fu.uid);
      });
    });

    DatabaseReference ref = FirebaseDatabase.instance.reference();
  }

  _adduserinfo() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    String uid2 = firebaseUser.uid;
    DatabaseReference ref1 = FirebaseDatabase.instance.reference();
    List<String> username = firebaseUser.email.toString().split("@");
    String _name = username[0].split(".")[0];
    String name = _name[0].toUpperCase() + _name.substring(1).toLowerCase();
    setState(() {
      fullname = name;
      email = firebaseUser.email.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    //GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    void _signOut() async {
      try {
        await widget.auth.signOut();
        widget.onSignOut();
      } catch (e) {
        print(e);
      }
    }

    return new Scaffold(
        drawer: new Drawer(
          elevation: 0,
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                  currentAccountPicture: new CircleAvatar(
                    backgroundColor: Colors.white,
                    child: new Text(
                      fullname.substring(0, 1),
                      style: TextStyle(fontSize: 35, color: Colors.black87),
                    ),
                  ),
                  accountName: new Text(fullname,
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  accountEmail: new Text( email ,
                      style: TextStyle(fontSize: 15, color: Colors.white))),
              new ListTile(
                  title: new Text(
                    "Past Orders",
                    style: TextStyle(fontSize: 15),
                  ),
                  leading: new Icon(
                    Icons.list,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PastOrders(email)),
                    );
                  }),
              new ListTile(
                  title: new Text(
                    "My Cart",
                    style: TextStyle(fontSize: 15),
                  ),
                  leading: new Icon(
                    Icons.add_shopping_cart,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ItemCart()),
                    );
                  }),
              new ListTile(
                  title: new Text(
                    "Feedback",
                    style: TextStyle(fontSize: 15),
                  ),
                  leading: new Icon(
                    Icons.feedback,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FeedBacks(
                                username: email,
                              )),
                    );
                  }),
              new Divider(),
              new ListTile(
                  title: new Text(
                    "Developers",
                    style: TextStyle(fontSize: 15),
                  ),
                  leading: new Icon(
                    Icons.account_circle,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutUs()),
                    );
                  }),
              new ListTile(
                title: new Text(
                  "Sign Out",
                  style: TextStyle(fontSize: 15),
                ),
                leading: new Icon(Icons.power_settings_new),
                onTap: _signOut,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Food Ordering App",
              style: TextStyle(fontSize: 18, color: Colors.white)),
          backgroundColor: Colors.orange,
          elevation: 1,
          /*actions: <Widget>[
            InkWell(
                  onTap:(){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ItemCart()),
                    );
                  },
                  child: Container(
                    padding:EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                    child: Row(children: <Widget>[
                      Icon(Icons.add_shopping_cart,size: 18,color: Colors.black,),
                      SizedBox(width: 5,),
                      Text("My Cart",style: TextStyle(fontSize: 15,color: Colors.black),)
                    ],),
                  ),
            )

          ],*/
        ),
        body: _pageOptions[_selectedPage],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ItemCart()),
            );
          },
          mini: true,
          child: Container(child: Icon(Icons.add_shopping_cart)),
          elevation: 1,
          backgroundColor: Colors.white,
          foregroundColor: Colors.orange,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedPage,
          fixedColor: Colors.orange,
          // backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                title: new Text(
                  'Explore',
                  style: TextStyle(fontSize: 10),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.store),
                title: new Text('All Stores', style: TextStyle(fontSize: 10))),
            BottomNavigationBarItem(
                icon: Stack(
                  children: <Widget>[
                    Icon(Icons.shopping_cart),
                  ],
                ),
                title: new Text('Orders', style: TextStyle(fontSize: 10))),
          ],
          onTap: (int index) {
            setState(() {
              _selectedPage = index;
            });
          },
        ));
  }
}
