import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'choiceChip.dart' as cc;
import '../crud.dart';
import 'getData.dart';
import 'googleSheets.dart';
import 'oneItemDetails.dart';
import 'package:carousel_slider/carousel_slider.dart';
class Tab1 extends StatefulWidget {
  @override
  _Tab1State createState() => _Tab1State();
}
class _Tab1State extends State<Tab1> {

  String token = "no_token";
  var queryResults=[];
  //SpeechRecognition _speech;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  String transcription = '';
  var tempSearchStore=[];
  bool show_search_results = false;
  int total_no_of_items = 0;
  int no_of_shops = 0;
  bool show_items = false;
  var final_items_after_search;
  List item_list_final;
  var category_list_final;
  String searchQueryFinal;
  bool isfirstfiltertrue = true;
  bool issecondfiltertrue = false;
  bool isthirdfiltertrue = false;
  bool atleastoneresultfound = false;
  String searchResultsCount = "";
  double opacityforhellothere = 1;
  List<String> shop_names_list2;
  FocusNode fNode = new FocusNode();
  bool FocusOnSearch = false;
  SharedPreferences s;
  bool sortByRating = true;
  int i = 0;
  TextEditingController controllerforSearch = new TextEditingController();
  //QuerySnapshot querySnapshot;
  Widget templ = Center(child:CircularProgressIndicator());
  CrudMethods crudObj = new CrudMethods();
  @override
  void initState() {
    // activateSpeechRecognizer()
    startPrefs();
    fNode.addListener(focusChange);
    _fetch();
    setState(() {
      opacityforhellothere = 1;
    });
    
    super.initState();
  }
  void startPrefs() async{
    s = await SharedPreferences.getInstance();
  }
  @override
  focusChange(){
    setState(() {
      FocusOnSearch = fNode.hasFocus;
    });
  }
  Widget messMenu(){
    // getData('messMenu!'+)
    DateTime date = DateTime.now();
    TimeOfDay time = TimeOfDay.now();
    // DateTime cutoffBF = DateTime.parse("11:00:00");
    // DateTime cutoffLunch = DateTime.parse("15:00");
    // DateTime cutoffSnacks = DateTime.parse("18:30");
    // DateTime cutoffDinner = DateTime.parse("23:00");
    List<String> tempx = [];
    double nowTime = time.hour.toDouble() +
            (time.minute.toDouble() / 60);
    // print(nowTime );
    String range = 'messMenu';
    if( nowTime - 11.0 < 0 ){
      range = range + 'BF!';
    }
    else if(nowTime - 15.0 < 0 ){
      range = range + 'Lunch!';
    }
    else if(nowTime - 18.5 < 0 ){
      range = range + 'Snacks!';
    }
    else{
      range = range + 'Dinner!';
    }
    range = range + String.fromCharCode(date.weekday + 65) + "2:"  + String.fromCharCode(date.weekday + 65);
    // print(range);
    tempx = s.getStringList(range);
    if(i == 0){getData(range).then((val) async {
      tempx = [];
      for(int i= 0; i<val.length; i++){
        tempx.add(val[i][0]);
      }
      // print(x);
      s.setStringList(range, tempx);
      setState((){});
    });}
    i = 1;
    if(tempx == null){
      return Center(child:CircularProgressIndicator());
    }
    templ = CarouselSlider(autoPlay: true,
                          height: 100.0,
                          items: tempx.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white
                                  ),
                                  child: Center(child: Container(child: Text(i, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20.0),)))
                                );
                              },
                            );
                          }).toList(),
                        );
    return templ;
  }

  @override
  Widget build(BuildContext context) {
    Widget afterSearch = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InkWell(onTap: (){ setState(() {
          isfirstfiltertrue =true;
          issecondfiltertrue = false;
          isthirdfiltertrue = false;
        });},child: cc.ChoiceChip(icon: Icons.fastfood,text:"Name",selected: isfirstfiltertrue)),
        SizedBox( width: 10,),
        InkWell(onTap: (){setState(() {
          isfirstfiltertrue =false;
          issecondfiltertrue = true;
          isthirdfiltertrue = false;
        });},child: cc.ChoiceChip(icon: Icons.category,text: "Category",selected: issecondfiltertrue)),
        SizedBox( width: 10,),
        InkWell(onTap: (){setState(() {
          isfirstfiltertrue =false;
          issecondfiltertrue = false;
          isthirdfiltertrue = true;
        });},child: cc.ChoiceChip(icon: Icons.store,text: "Store",selected: isthirdfiltertrue)),

      ],
    );
    Widget beforeSearch =
    Container(

      child: Text("Feeling hungry? You have come to the right place. Explore and enjoy delicious food here.", style: TextStyle(fontSize: 15,color:Colors.white),),
    );
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor:Color.fromRGBO(255, 230, 204, 1),
      body:Column(
        children: <Widget>[
          Expanded(

            child: Column(
              children: <Widget>[
                Container(
                  child: Stack(

                    children: <Widget>[
                      Container(
                        height: 135,
                        width: double.infinity,
                        color: Colors.orange,
                      ),
                      Positioned(
                        bottom:50,
                        left:80
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
                      Positioned(
                        bottom:40,
                        left:-40
                        ,
                        child: Container(
                            width: 100,
                            height: 100,
                            decoration:BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(400)),
                                color: Colors.orangeAccent
                            )
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Hi there!"
                              ,style: TextStyle(fontSize: 31,color: Colors.white,fontWeight: FontWeight.bold),),
                            show_search_results && show_items ? InkWell(
                              onTap: (){

                                setState(() {
                                  if(sortByRating){

                                    item_list_final.sort((b,a)=> b[1]["item_details"]["cost"].compareTo(a[1]["item_details"]["cost"]));
                                    sortByRating=false;
                                  }
                                  else {
                                    item_list_final.sort((a,b)=> b[1]["item_details"]["actual_rating"].compareTo(a[1]["item_details"]["actual_rating"]));
                                    sortByRating=true;
                                  }

                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:BorderRadius.circular(15),
                                  color: Colors.orange,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),

                                child: sortByRating ? Text("Sort By : Rating",style: TextStyle(color: Colors.white),):Text("Sort By : Price",style: TextStyle(color: Colors.white),),
                              ),
                            ):Container(),



                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(18, 60, 0, 0),
                          //child: show_search_results?:
                          child:AnimatedCrossFade(
                            duration: Duration(milliseconds: 250),
                            firstChild: afterSearch,
                            secondChild: beforeSearch,
                            crossFadeState: FocusOnSearch ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          )
                      ),

                      Padding(
                        padding: EdgeInsets.only(left:12,right:12,bottom:10,top:110),
                        child: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.circular(10),

                          child: TextField(
                            controller: controllerforSearch,
                            focusNode: fNode,
                            style: TextStyle(
                              color: Colors.black87,fontSize: 18,
                            ),
                            onChanged: (val){
                              _search(val);
                              //notify a = new notify();
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: !show_search_results ? Icon(Icons.search, color: Colors.black45,size: 30,) :
                                InkWell(
                                  child: Icon(Icons.close, color: Colors.black45,size: 20,),
                                  onTap: (){
                                    _search("");
                                    setState(() {
                                      controllerforSearch.text="";
                                    });

                                  },
                                ),
                                contentPadding: EdgeInsets.only(left: 30,right: 5,bottom: 2,top: 12),
                                /*suffixIcon: InkWell(
                                  onTap: _speechRecognitionAvailable && !_isListening
                                      ? () => start()
                                      : null,
                                  child:Container(

                                    child:  Icon(Icons.mic,size: 30,color: Colors.deepOrange,),
                                  ),
                                ),*/

                                hintText: "Search..",
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
                    String item_id = item_list_final[i][2]["item_id"];
                    double item_rating = double.parse(item_list_final[i][1]["item_details"]["actual_rating"].toString());
                    //double item_rating = double.parse(item_list_final[i][2]["rating"].toString());

                    String searchKey;
                    if(isfirstfiltertrue){
                      searchKey = item_name;
                    }
                    else if (issecondfiltertrue){
                      searchKey = item_category;
                    }
                    else {
                      searchKey = _shop_name;
                    }
                    int no_of_results = 0;
                    bool myBool = searchKey.toLowerCase().contains(searchQueryFinal.toLowerCase());

                    if(myBool){
                      no_of_results++;

                      //_showSearchCount(no_of_results);
                      return Container(

                        child: GestureDetector(

                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => OneItemDetails(item_id: item_id,shop_username: _shop_username,shop_name: _shop_name,)),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 3,horizontal: 12),
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color:Colors.white,
                                boxShadow: [
                                  new BoxShadow(
                                    color: Colors.black12,
                                    offset: new Offset(0, 1),
                                  )
                                ]
                            ),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(item_name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black87),),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[

                                        Text(item_rating.toStringAsFixed(2)+" ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.orange),),
                                        Icon(Icons.star,size: 18,color: Colors.orange,)
                                      ],
                                    )

                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Rs. "+item_cost.toString(),style: TextStyle(fontSize: 17,color: Colors.black87),),
                                    Text(item_category,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.grey),)
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(_shop_name,style: TextStyle(fontSize: 17,color: Colors.black87),),

                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    else {
                      return SizedBox(height: 0,);
                      //Fake when no match
                    }


                  },itemCount: item_list_final.length,
                    //scrollDirection: Axis.vertical,

                  )
                  ,

                ):Expanded(

                  child: SingleChildScrollView(
                    child: item_list_final!=null ? Wrap(

                      children: <Widget>[

                        Container(

                          child: Text("Whats in the mess?",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                          margin: EdgeInsets.fromLTRB(15, 25, 0, 15),

                        ),
                        messMenu(),
                        
                        Container(

                          child: Text("All Categories",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                          margin: EdgeInsets.fromLTRB(15, 25, 0, 15),

                        ),

                        SizedBox(
                          height: 38,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: category_list_final.length,
                            itemBuilder: (context,i){
                              String item_category = category_list_final[i];
                              return ConstrainedBox(
                                constraints: new BoxConstraints(

                                ),
                                child: Container(
                                  child: GestureDetector(

                                    onTap: (){
                                      setState(() {
                                        controllerforSearch.text = item_category;
                                        _search(item_category);
                                        FocusOnSearch = true;
                                        isfirstfiltertrue =false;
                                        issecondfiltertrue = true;
                                        isthirdfiltertrue = false;
                                      });

                                    },
                                    child: ConstrainedBox(
                                      constraints: new BoxConstraints(

                                      ),
                                      child: Container(
                                        margin: i==0 ? EdgeInsets.fromLTRB(12, 0, 0, 1): EdgeInsets.fromLTRB(5, 0, 0, 1),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            color:Colors.white,
                                            boxShadow: [
                                              new BoxShadow(
                                                color: Colors.black12,

                                              )
                                            ]
                                          //border: Border(top: BorderSide(color: Colors.orange,width: 1))

                                        ),
                                        child: Text(item_category.substring(0,1).toUpperCase()+item_category.substring(1,item_category.length).toLowerCase()),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Top dishes",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                              InkWell(
                                onTap: (){

                                  setState(() {
                                    if(sortByRating){
                                      item_list_final.sort((b,a)=> b[1]["item_details"]["cost"].compareTo(a[1]["item_details"]["cost"]));
                                      sortByRating=false;
                                    }
                                    else {
                                      item_list_final.sort((a,b)=> b[1]["item_details"]["actual_rating"].compareTo(a[1]["item_details"]["actual_rating"]));
                                      sortByRating=true;
                                    }

                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:BorderRadius.circular(15),
                                    color: Colors.orange,
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),

                                  child: sortByRating ? Text("Sort By : Rating",style: TextStyle(color: Colors.white),):Text("Sort By : Price",style: TextStyle(color: Colors.white),),
                                ),
                              )
                            ],
                          ),
                          margin: EdgeInsets.fromLTRB(15, 35, 15, 15),

                        ),
                        SizedBox(
                          height:300,
                                                  child: ListView.builder(
                            // height: 100,
                            // itemBuilder: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: item_list_final.length,
                            //   itemBuilder: 
                            // ),
                            itemBuilder: (context,i){
                                String _shop_username = item_list_final[i][0]["shop_details"]["username"].toString();
                                String _shop_name = item_list_final[i][0]["shop_details"]["shop_name"].toString();
                                String item_name = item_list_final[i][1]["item_details"]["name"].toString();
                                String item_cost = item_list_final[i][1]["item_details"]["cost"].toString();
                                String item_category = item_list_final[i][1]["item_details"]["category"].toString();
                                bool item_checkbox = item_list_final[i][1]["item_details"]["checkbox"];
                                String item_id = item_list_final[i][2]["item_id"];
                                double item_rating = double.parse(item_list_final[i][1]["item_details"]["actual_rating"].toString());
                                return Container(
                                  // constraints: new BoxConstraints(
                                  //     maxHeight: 150,
                                  //     maxWidth: 250,
                                  //     minWidth: 200
                                  // ),

                                  child: Container(
                                    child: GestureDetector(

                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => OneItemDetails(item_id: item_id,shop_username: _shop_username,shop_name: _shop_name,)),
                                        );
                                      },
                                      child: Container(
                                        // constraints: new BoxConstraints(
                                        //   maxHeight: 250,

                                        // ),
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(12, 0, 0, 2),
                                          padding: EdgeInsets.all(15),

                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color:Colors.white,
                                              boxShadow: [
                                                new BoxShadow(
                                                  color: Colors.black12,
                                                  offset: new Offset(0, 1),
                                                )
                                              ]
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Container(width: MediaQuery.of(context).size.width*0.6,
                                                  child: Text(item_name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black87),)),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: <Widget>[

                                                      Text(item_rating.toStringAsFixed(2)+" ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.orange),),
                                                      Icon(Icons.star,size: 18,color: Colors.orange,)
                                                    ],
                                                  )

                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text("Rs. "+item_cost.toString(),style: TextStyle(fontSize: 17,color: Colors.black87),),
                                                  Text(item_category,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.grey),)
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text(_shop_name,style: TextStyle(fontSize: 17,color: Colors.black87),),

                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }, 
                              // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                          ),
                        ),
                      ],
                    ):Container(
                      margin: EdgeInsets.all(12),
                      child: Text("Loading...",textAlign: TextAlign.center,),
                    ),
                  ),
                )

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({String label, VoidCallback onPressed}) => new Padding( 
      padding: new EdgeInsets.all(12.0),
      child: new RaisedButton(
        color: Colors.cyan.shade600,
        onPressed: onPressed,
        child: new Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ));
  // void start() => _speech
  //     .listen(locale: 'en_US')
  //     .then((result) => print('_MyAppState.start => result $result'));
  // void cancel() =>
  //     _speech.cancel().then((result) => setState(() => _isListening = result));
  // void stop() => _speech.stop().then((result) {
  //   setState(() => _isListening = result);
  // });
  // void onSpeechAvailability(bool result) =>
  //     setState(() => _speechRecognitionAvailable = result);
  void onCurrentLocale(String locale) {
    //print('_MyAppState.onCurrentLocale... $locale');
  }
  void onRecognitionStarted() => setState(() => _isListening = true);
  void onRecognitionResult(String txt){
    setState(() {
      //transcription = txt;
      controllerforSearch.text = txt;
      _search(txt);
      FocusOnSearch = true;

    });
  }
  void onRecognitionComplete() => setState(() => _isListening = false);
  // void errorHandler() => activateSpeechRecognizer();
  _fetch(){
    GetData().get().then((QuerySnapshot docs) {
      int a = docs.documents.length;
      int num=0;
      List<String> shop_usernames_list = new List(a);
      for( var i = num ; i < a; i++ ) {
        String id = docs.documents[i].documentID.toString();
        String shop_n = docs.documents[i].data["shop_name"].toString();
        shop_usernames_list[i]=id+"@@@11@@@"+shop_n;
        if (i == a-1){
          setState(() {
            shop_names_list2 = shop_usernames_list;
          });
          int num2 = 0;
          List<List<Map>> item_list= [];
          List<String> category_list= [];
          for(int i2 = num2; i2<a; i2++){
            bool des = true;
            Firestore.instance.collection(shop_usernames_list[i2].split("@@@11@@@")[0]).getDocuments().then((QuerySnapshot docs) {
              int no_of_items_in_this_shop = docs.documents.length;
              int pp=0;
              int item_index=0;
              while(item_index<no_of_items_in_this_shop){
                List<Map> item =  [{"shop_details" : {
                  "username":shop_usernames_list[i2].split("@@@11@@@")[0],
                  "shop_name":shop_usernames_list[i2].split("@@@11@@@")[1]
                }},{"item_details":docs.documents[item_index].data },{"item_id":docs.documents[item_index].documentID.toString()},{"rating":docs.documents[item_index].data["actual_rating"]}]
                ;
                item_list.add(item);
                category_list.add(docs.documents[item_index].data["category"].toString().trim().toLowerCase());
                if(item_index==no_of_items_in_this_shop-1 && i2 == a-1){

                  setState(() {
                    show_items = true;
                    //item_list.shuffle();
                    item_list.sort((a,b)=>
                        b[1]["item_details"]["actual_rating"].compareTo(a[1]["item_details"]["actual_rating"])
                    );
                    item_list_final=item_list;
                    category_list_final=List.from(Set.from(category_list));



                  });
                }
                item_index++;
              }

            });

          }


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
      //_fetch();
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