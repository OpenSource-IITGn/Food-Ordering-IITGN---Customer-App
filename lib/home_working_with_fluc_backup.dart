//References
//UI inspirations https://www.youtube.com/watch?v=GeMJz3EcBgs&t=2826s
//Misc https://www.youtube.com/results?search_query=raja+yogan+flutter
//LOGIN-SIGNUP-SYSTEM-CODE https://github.com/bizz84/firebase-login-flutter/
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth.dart';
import 'home.dart';
import 'loginpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "crud.dart";

import 'variables.dart';
class HomePage extends StatefulWidget {

  HomePage({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;
  final _pageOptions = [
Tab1(),Tab2(),Tab3()
  ];
  @override
  String fullname = "sdsdf";
  String email ="csd";
  void initState() {

    super.initState();
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    //*ref.child("customer_info/").onChildAdded.listen(_adduserinfo);
    /*.once().then((DataSnapshot snap){
      var data = snap.value;
      setState(() {
        fullname = data["fullname"].toString();
        email = data["email"].toString();
      });

    });*/
  }

  @override
  Widget build(BuildContext context) {

    _adduserinfo() async {
      FirebaseUser firebaseUser =  await FirebaseAuth.instance.currentUser();
      DatabaseReference ref1 = FirebaseDatabase.instance.reference();
      List<String> username = firebaseUser.email.toString().split("@");
      String _name = username[0].split(".")[0];
      String name = _name[0].toUpperCase()+_name.substring(1).toLowerCase();
      setState(() {
            fullname= name;
            email=firebaseUser.email.toString();
      });
    }
    //GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    _adduserinfo();
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
                    child: new Text(fullname.substring(0,1),style: TextStyle(fontSize: 35,color: Colors.black87),),
                  ),
                  accountName: new Text(fullname,style: TextStyle(fontSize: 20,color:Colors.white)),
                  accountEmail: new Text("("+email+") ",style: TextStyle(fontSize: 15,color:Colors.white))),
              new ListTile(
                title: new Text("About Us", style: TextStyle(fontSize: 15),),
                leading: new Icon(Icons.account_circle,),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutUs()),
                    );
                  }
              ),
              new Divider(),
              new ListTile(
                title: new Text("Sign Out", style: TextStyle(fontSize: 15),),
                leading: new Icon(Icons.power_settings_new),
                onTap: _signOut,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
        title: Text("Food Ordering App", style: TextStyle(fontSize: 18,color: Colors.orange,fontFamily: "Impact"),),
        backgroundColor: Colors.white,
        elevation: 1,
          ),
        body:  _pageOptions[_selectedPage],
        bottomNavigationBar:BottomNavigationBar(
          currentIndex: _selectedPage,
          fixedColor: Colors.white,
          // backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                title: new Text('Search',style: TextStyle(fontSize: 10),)
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.store),
                title: new Text('All Stores',style: TextStyle(fontSize: 10))
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                title: new Text('My Orders',style: TextStyle(fontSize: 10))
            )
          ],
          onTap: (int index){
            setState(() {
              _selectedPage = index;
            });
          },
        )
    );
  }
}
class Tab1 extends StatefulWidget {
  @override
  _Tab1State createState() => _Tab1State();
}
class _Tab1State extends State<Tab1> {
  var queryResultSet=[];
  var tempSearchStore=[];
  bool show_search_results = false;
  int total_no_of_items = 0;
  int no_of_shops = 0;
  bool show_items = false;
  var final_items_after_search;
  var item_list_final;
  String searchQueryFinal;
  bool isfirstfiltertrue = true;
  String searchResultsCount = "";
  //QuerySnapshot querySnapshot;
  CrudMethods crudObj = new CrudMethods();
  @override
  void initState() {


      super.initState();
      ;
  }
  @override

  @override
  Widget build(BuildContext context) {

    //_fetch();

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color.fromRGBO(255, 230, 204, 1),
      body:Column(
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.orange,
                ),
                Positioned(
                  bottom:50,
                  left:100
                  ,
                  child: Container(
                      width: 400,
                      height: 400,
                      decoration:BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(400)),
                          color: Colors.orangeAccent
                      )
                  ),

                ),
                Container(
                  
                  padding: EdgeInsets.fromLTRB(15, 25, 15, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Hello there"
                          ,style: TextStyle(fontSize: 31,color: Colors.white,fontWeight: FontWeight.bold),),
                      Container(

                          alignment: Alignment(-1, -3),
                          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                          child: Text(searchResultsCount.toString(),style: TextStyle(color: Colors.white),))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(18, 75, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(

                        child: Text("Search By :",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold),),
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      ),
                      InkWell(onTap: (){ setState(() {
                        isfirstfiltertrue =true;
                      });},child: ChioceChip(Icons.fastfood,"Name",isfirstfiltertrue)),
                      SizedBox(width: 20,),
                      InkWell(onTap: (){setState(() {
                        isfirstfiltertrue=false;
                      });},child: ChioceChip(Icons.category,"Category",!isfirstfiltertrue))

                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left:18,right:18,bottom:10,top:125),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(5),
                    child: TextField(
                      style: TextStyle(
                        color: Colors.black87,fontSize: 18,
                      ),
                      onChanged: (val){
                        _search(val);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.black45,size: 30,),
                        contentPadding: EdgeInsets.only(left: 30,right: 5,bottom: 5,top: 12),
                        hintText: "Search...",
                        hintStyle: TextStyle(
                          color: Colors.grey,fontSize: 18,
                        )

                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          //show_search_results ? Container(child: Text("Searching in "+no_of_shops.toString()+" shops"+", found "+total_no_of_items.toString()+" items."),):Container(child: Text(" "),)
          Flexible(

            child:  StreamBuilder(
                stream: Firestore.instance.collection('store_data').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container(child: Text("",style: TextStyle(fontSize: 0),));
                  List<String> usernames;
                  int no_of_shops =snapshot.data.documents.length;
                  int num =0;
                  List<String> shop_list = [];
                  List<String> shop_name_list = [];

                  for(var i=num; i<no_of_shops; i++){
                    String x= snapshot.data.documents[i].documentID.toString();
                    bool shop_open = snapshot.data.documents[i]["open"];
                    String shop_name = snapshot.data.documents[i]["shop_name"];
                    shop_name_list.add(shop_name);
                    shop_list.add(x);
                    if(i==no_of_shops-1){
                        //list formed

                       /* Fluttertoast.showToast(
                            msg: shop_list.toString()+i.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.black26,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );*/
                        int num2 = 0;
                        List<Object> item_list= [];
                        for(int i2 = num2; i2<no_of_shops; i2++){
                            Firestore.instance.collection(shop_list[i2]).getDocuments().then((QuerySnapshot docs) {
                                int no_of_items_in_this_shop = docs.documents.length;
                                int pp=0;
                                int item_index=0;
                                while(item_index<no_of_items_in_this_shop){
                                  List<Object> item =  [{"shop_details" : {
                              "username":shop_list[i2],
                              "shop_name":shop_name_list[i2]
                              }},{"item_details":docs.documents[item_index].data }]
                                    ;
                                  item_list.add(item);
                                  /*Fluttertoast.showToast(
                                      msg: item.toString()+" no of items in this shop :" +no_of_items_in_this_shop.toString()+" index:"+item_index.toString(),
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIos: 1,
                                      backgroundColor: Colors.black26,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );*/

                                  if(item_index==no_of_items_in_this_shop-1 && i2 == no_of_shops-1){
                                      setState(() {
                                          show_items = true;
                                          item_list_final=item_list;
                                      });
                                  }
                                  item_index++;
                                }

                            });

                        }
                    }
                  }
                  return Text(" ",style: TextStyle(fontSize: 0),); //FAKE

                })
          ),
          show_search_results && show_items ? Expanded(

        child: ListView.builder(itemBuilder: (context,i){

          /*String shop_username = item_list_final[i]["shop_details"]["username"];
            String shop_name = item_list_final[i]["shop_details"]["shop_name"];
            String item_name = item_list_final[i]["item_details"]["name"];
            String item_category = item_list_final[i]["item_details"]["category"];
            String item_cost = item_list_final[i]["item_details"]["cost"];
            bool item_checkbox = item_list_final[i]["item_details"]["checkbox"];*/

            String _shop_username = item_list_final[i][0]["shop_details"]["username"].toString();
            String _shop_name = item_list_final[i][0]["shop_details"]["shop_name"].toString();
            String item_name = item_list_final[i][1]["item_details"]["name"].toString();
            String item_cost = item_list_final[i][1]["item_details"]["cost"].toString();
            String item_category = item_list_final[i][1]["item_details"]["category"].toString();
            bool item_checkbox = item_list_final[i][1]["item_details"]["checkbox"];
            String searchKey;
            if(isfirstfiltertrue){
              searchKey = item_name;
            }
            else {
              searchKey = item_category;
            }
            int no_of_results = 0;
            if(searchKey.toLowerCase().contains(searchQueryFinal.toLowerCase())){
              no_of_results++;
              //_showSearchCount(no_of_results);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  InkWell(
                    //color: Colors.white,
                    //padding: EdgeInsets.only(left: 0,right: 0,top: 5,bottom: 1),
                    onTap: (){
                      //_open_shopmenu(shop_username);
                    },
                    child: Material(
                      borderOnForeground: true,
                      elevation: 0,
                      color: Colors.white,
                      child: Padding(

                        padding: EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: <Widget>[

                            Container(
                                child: Text(
                                  item_name +" ("+item_cost+")",

                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black87),
                                )

                            ),
                            Container(

                                padding: EdgeInsets.only(top: 0,right: 0,bottom: 0,left: 0)
                                ,
                                alignment: AlignmentDirectional(1,3),
                                child:  item_checkbox ? Material(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5,right: 5,top: 4,bottom: 4),
                                    child: Text("Available",style: TextStyle(color: Colors.white),textAlign: TextAlign.right,),
                                  ),
                                  color: Colors.green,

                                ):Material(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5,right: 5,top: 4,bottom: 4),
                                    child: Text("Not Available",style: TextStyle(color: Colors.white),textAlign: TextAlign.right,),
                                  ),
                                  color: Colors.red,

                                )


                            ),
                            Container(
                              padding: EdgeInsets.only(top: 0),
                              child: Text(
                                "Category : "+item_category,
                                style: TextStyle(fontSize: 16,color: Colors.black87),
                              ),

                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                ""+_shop_name+"",
                                style: TextStyle(fontSize: 18,color: Colors.black87),
                              ),


                            ),



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
              );

            }
            else {

              return Text("",style:TextStyle(fontSize: 0),); //Fake when no match

            }


        },itemCount: item_list_final.length,
          )
         ,
            flex: 500,
    ):Container(child: Container(
            padding: EdgeInsets.all(15),
            child: Text("This app provides you the facility to order food in campus with great ease. Search for any item you would like to eat. ",style: TextStyle(fontSize: 18),),
          ))

        ],
      ),
    );
  }
  _fetch(){
    GetData().get().then((QuerySnapshot docs) {
      int a = docs.documents.length;
      int num=0;
      List<String> shop_usernames_list = new List(a);
      for( var i = num ; i < a; i++ ) {
        String id = docs.documents[i].documentID.toString();

        shop_usernames_list[i]=id;
        /*Fluttertoast.showToast(
            msg:shop_usernames_list.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.white,
            fontSize: 16.0
        );*/
        if (i == a-1){
          SetList().set(shop_usernames_list);
          //shop_usernames_list;
        }
      }



    }
    );
  }
  void _search(String val){
    String searchquery = val.toLowerCase().trim();
    if (searchquery==""){
      setState(() {
        show_search_results = false;
      });
    }
    else {
          if(show_items){
            setState(() {
              searchQueryFinal = searchquery;
              show_search_results=true;
              //item_list_final=item_list_final;
            });
            }













      /*GetData().get().then((QuerySnapshot docs) {
        int a = docs.documents.length;
        int num=0;
        List<String> shop_usernames_list = new List(a);
        for( var i = num ; i < a; i++ ) {
          String id = docs.documents[i].documentID.toString();

          shop_usernames_list[i]=id;
          if (i == a-1){
            SetList().set(shop_usernames_list);
            setState(() {
              no_of_shops  = a;
              show_search_results = true;

            });
            int total_no_of_items = 0;

            for(String shop_username in shop_usernames_list){
              GetData().getItemData(shop_username).then((QuerySnapshot docs2){
                  int no_of_items_one_shop = docs2.documents.length;
                  total_no_of_items+=no_of_items_one_shop;
                  if() {

                  }
              });

            }

          }
        }



      });*/
    }


    }
}
class Tab2 extends StatefulWidget {
  @override
  _Tab2State createState() => _Tab2State();
}
class _Tab2State extends State<Tab2> {
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      color: Color.fromRGBO(255, 230, 204, 1),
      child: StreamBuilder(

          stream: Firestore.instance.collection('store_data').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: Text("Loading, please wait...",style: TextStyle(fontSize: 20),));
            return ListView.builder(
              controller: _controller,
              itemBuilder: (BuildContext context, int index) {
                String shop_username = snapshot.data.documents[index].documentID.toString();
                String close_time =
                snapshot.data.documents[index]['close_time'].toString();
                String open_time =
                snapshot.data.documents[index]['open_time'].toString();
                String shop_name =
                snapshot.data.documents[index]['shop_name'].toString();
                String shop_description=
                snapshot.data.documents[index]['shop_description'].toString();
                bool open = snapshot.data.documents[index]['open'];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    InkWell(
                      //color: Colors.white,
                      //padding: EdgeInsets.only(left: 0,right: 0,top: 5,bottom: 1),
                      onTap: (){
                        _open_shopmenu(shop_username);
                      },
                      child: Material(
                        borderOnForeground: true,
                        elevation: 0,
                        color: Colors.white,
                        child: Padding(

                          padding: EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: <Widget>[

                              Container(
                                child: Text(
                                  shop_name,

                                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black87),
                                )

                              ),
                              Container(

                                  padding: EdgeInsets.only(top: 0,right: 0,bottom: 0,left: 0)
                                  ,
                                  alignment: AlignmentDirectional(1,3),
                                  child:  open ? Material(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: Container(
                                      padding: EdgeInsets.only(left: 5,right: 5,top: 4,bottom: 4),
                                      child: Text("Open",style: TextStyle(color: Colors.white),textAlign: TextAlign.right,),
                                    ),
                                    color: Colors.green,

                                  ):Material(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: Container(
                                      padding: EdgeInsets.only(left: 5,right: 5,top: 4,bottom: 4),
                                      child: Text("Closed",style: TextStyle(color: Colors.white),textAlign: TextAlign.right,),
                                    ),
                                    color: Colors.red,

                                  )


                              ),
                              Container(
                                padding: EdgeInsets.only(top: 0),
                                child: Text(
                                  '('+open_time+" to "+close_time+')',
                                  style: TextStyle(fontSize: 15,color: Colors.grey,fontWeight: FontWeight.bold),
                                ),

                              ),

                                  Container(
                                  padding: EdgeInsets.only(top: 5),
                              child: Text(
                                shop_description,
                                style: TextStyle(fontSize: 15,color: Colors.black87),
                              ),

                            )

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
                );
              },
              itemCount: snapshot.data.documents.length,
            );
          }),
    );
  }
  _open_shopmenu(String shop_username){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ShopDetailsWithMenu(shop_username: shop_username)));
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
}
class ShopDetailsWithMenu extends StatefulWidget {
  @override
  final String shop_username;
  ShopDetailsWithMenu({this.shop_username});
  _ShopDetailsWithMenuState createState() => _ShopDetailsWithMenuState();
}

class _ShopDetailsWithMenuState extends State<ShopDetailsWithMenu> {
  @override

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: CustomScrollView(

        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 175,
            backgroundColor: Color.fromRGBO(255, 230, 204, 1),
            title: Container(
              child: StreamBuilder(

            stream: Firestore.instance.collection('store_data').document(widget.shop_username).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: Text(
                  "Loading...", style: TextStyle(fontSize: 20),));
                String one_shop_name = snapshot.data["shop_name"].toString();
                return new Text(one_shop_name);
              })),
            centerTitle: true,
            elevation: 1,
            pinned: true,

            flexibleSpace: new FlexibleSpaceBar(
              background: new Column(
                  children: <Widget>[
              StreamBuilder(

              stream: Firestore.instance.collection('store_data').document(widget.shop_username).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: Text(
                    "Loading...", style: TextStyle(fontSize: 20),));

                  String one_shop_name = snapshot.data["shop_name"].toString();
                  String one_close_time = snapshot.data["close_time"].toString();
                  String one_open_time = snapshot.data["open_time"].toString();
                  String one_shop_description = snapshot.data["shop_description"].toString();
                  bool one_shop_open= snapshot.data["open"];
                  return Column(

                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding:EdgeInsets.only(top: 80,left: 15,right: 15),
                        child: Text(one_shop_description,style: TextStyle(fontSize: 18),),
                      ),
                      Container(
                        padding:EdgeInsets.only(top: 10),
                        child: Text("Timings:"+one_open_time+" to "+one_close_time ,style: TextStyle(fontSize: 18),),
                      ),
                      Container(
                        padding:EdgeInsets.only(top: 10),
                        child: one_shop_open ? Material(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Container(
                            padding: EdgeInsets.only(left: 5,right: 5,top: 4,bottom: 4),
                            child: Text("Open",style: TextStyle(color: Colors.white),textAlign: TextAlign.right,),
                          ),
                          color: Colors.green,

                        ):Material(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Container(
                            padding: EdgeInsets.only(left: 5,right: 5,top: 4,bottom: 4),
                            child: Text("Closed",style: TextStyle(color: Colors.white),textAlign: TextAlign.right,),
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
          SliverFillRemaining(
            child: StreamBuilder(

                stream: Firestore.instance.collection(widget.shop_username).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: Text("Loading, please wait...",style: TextStyle(fontSize: 20),));
                  return ListView.builder(
                    padding: EdgeInsets.only(left: 5,right: 5),

                    itemBuilder: (BuildContext context, int index) {
                      String item_id = snapshot.data.documents[index].documentID.toString();
                      String category =
                      snapshot.data.documents[index]['category'].toString();
                      String cost =
                      snapshot.data.documents[index]['cost'].toString();
                      String name =
                      snapshot.data.documents[index]['name'].toString();
                      bool check_box =
                      snapshot.data.documents[index]['checkbox'];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          InkWell(
                            //color: Colors.white,
                            //padding: EdgeInsets.only(left: 0,right: 0,top: 5,bottom: 1),
                            onTap: (){
                              //_open_shopmenu(shop_username);
                            },
                            child: Material(
                              borderOnForeground: true,
                              elevation: 0,
                              color: Colors.white,
                              child: Padding(

                                padding: EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: <Widget>[

                                    Container(
                                        child: Text(
                                          name,

                                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black87),
                                        )

                                    ),
                                    Container(

                                        padding: EdgeInsets.only(top: 0,right: 0,bottom: 0,left: 0)
                                        ,
                                        alignment: AlignmentDirectional(1,3),
                                        child:  check_box ? Material(
                                          borderRadius: BorderRadius.circular(50.0),
                                          child: Container(
                                            padding: EdgeInsets.only(left: 5,right: 5,top: 4,bottom: 4),
                                            child: Text("Available",style: TextStyle(color: Colors.white),textAlign: TextAlign.right,),
                                          ),
                                          color: Colors.green,

                                        ):Material(
                                          borderRadius: BorderRadius.circular(50.0),
                                          child: Container(
                                            padding: EdgeInsets.only(left: 5,right: 5,top: 4,bottom: 4),
                                            child: Text("Not Available",style: TextStyle(color: Colors.white),textAlign: TextAlign.right,),
                                          ),
                                          color: Colors.red,

                                        )


                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 0),
                                      child: Text(
                                        category,
                                        style: TextStyle(fontSize: 16,color: Colors.grey,fontWeight: FontWeight.bold),
                                      ),

                                    ),

                                    Container(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        cost,
                                        style: TextStyle(fontSize: 16,color: Colors.black87,fontWeight: FontWeight.bold),
                                      ),

                                    )

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
                      );;
                    },
                    itemCount: snapshot.data.documents.length,
                  );
                }),
          )
          /*StreamBuilder(
              stream: Firestore.instance.collection(widget.shop_username).snapshots(),
              builder: (context, snapshot) => SliverList(
                  delegate: SliverChildBuilderDelegate(

                        (context, index) =>

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                InkWell(
                                  //color: Colors.white,
                                  //padding: EdgeInsets.only(left: 0,right: 0,top: 5,bottom: 1),
                                  onTap: (){
                                    //_open_shopmenu(shop_username);
                                  },
                                  child: Material(
                                    borderOnForeground: true,
                                    elevation: 0,
                                    color: Colors.white,
                                    child: Padding(

                                      padding: EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,

                                        children: <Widget>[

                                          Container(
                                              child: Text(
                                                snapshot.data.documents[index]["name"],

                                                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black87),
                                              )

                                          ),
                                          Container(

                                              padding: EdgeInsets.only(top: 0,right: 0,bottom: 0,left: 0)
                                              ,
                                              alignment: AlignmentDirectional(1,3),
                                              child:  snapshot.data.documents[index]["checkbox"] ? Material(
                                                borderRadius: BorderRadius.circular(50.0),
                                                child: Container(
                                                  padding: EdgeInsets.only(left: 5,right: 5,top: 4,bottom: 4),
                                                  child: Text("Available",style: TextStyle(color: Colors.white),textAlign: TextAlign.right,),
                                                ),
                                                color: Colors.green,

                                              ):Material(
                                                borderRadius: BorderRadius.circular(50.0),
                                                child: Container(
                                                  padding: EdgeInsets.only(left: 5,right: 5,top: 4,bottom: 4),
                                                  child: Text("Not Available",style: TextStyle(color: Colors.white),textAlign: TextAlign.right,),
                                                ),
                                                color: Colors.red,

                                              )


                                          ),
                                          Container(
                                            padding: EdgeInsets.only(top: 0),
                                            child: Text(
                                                snapshot.data.documents[index]["category"],
                                              style: TextStyle(fontSize: 18,color: Colors.black87),
                                            ),

                                          ),

                                          Container(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              snapshot.data.documents[index]["cost"],
                                              style: TextStyle(fontSize: 18,color: Colors.black87),
                                            ),

                                          )

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
                    childCount: snapshot.data.documents.length,
                  )
              )
          )*/
        ],
      )
    );
  }
}
class Tab3 extends StatefulWidget {
  @override
  _Tab3State createState() => _Tab3State();
}

class _Tab3State extends State<Tab3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 230, 204, 1),
      body: Container(
        child: Text("Soon.."),
      ),
    );
  }
}
class SearchService {
  searchByName(String searchField) {

    return Firestore.instance.collection("mahavir");
  }
}
class GetData {
  get(){
  return Firestore.instance.collection("store_data").getDocuments();

}
  getItemData(String shop_username){
    return Firestore.instance.collection("shop_username").getDocuments();
  }
}
class SetList{
  List<String> shop_username_list;
  set(List<String> shop_username_list){
    this.shop_username_list = shop_username_list;
  }
  get(){
    return this.shop_username_list;
  }
}
class ChioceChip extends StatefulWidget{
  final IconData icon;
  final String text;
  final bool selected;
  ChioceChip(this.icon,this.text,this.selected);
  @override
  CCState createState() => CCState();
}
class CCState extends State<ChioceChip>{
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18,vertical: 8),
      decoration: widget.selected ? BoxDecoration(color:Colors.white.withOpacity(0.25 ),borderRadius: BorderRadius.circular(20)):null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            widget.icon,
            size: 20,
            color: Colors.white,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            widget.text,
            style:TextStyle(
              color: Colors.white,
            )
          )
        ],
      ),
    );
  }
}

class AboutUs extends StatefulWidget{


  @override
  AboutUsS createState() => AboutUsS();
}
class AboutUsS extends State<AboutUs>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Food Ordering App", style: TextStyle(fontSize: 18,color: Colors.orange),),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Container(
        child: Text("Soon"),
      ),
    );
  }
}

