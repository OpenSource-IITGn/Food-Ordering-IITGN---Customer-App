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
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class LoginPage extends StatefulWidget {

  LoginPage({Key key, this.title, this.auth, this.onSignIn}) : super(key: key);

  final String title;
  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _LoginPageState createState() => new _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  @override
  TextEditingController emailforlogincontroller = new TextEditingController();
  TextEditingController passwordforlogincontroller = new TextEditingController();

  Widget build(BuildContext context) {

    final loginButon = InkWell(
        onDoubleTap: (){
          login();
        },
        child:Material(
          elevation: 0.0,
          borderRadius: BorderRadius.circular(50.0),
          color: Colors.deepOrangeAccent,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(25,13,25,13),
            onPressed: () {
              login();
            },
            child: Text("Login",
                textAlign: TextAlign.center,

                style: TextStyle(color: Colors.white,fontSize: 20)),
          ),
        )


    );
    final signUpNavButon = InkWell(
        onDoubleTap: (){
          signup();
        },
        child:Material(
          elevation: 0.0,

          borderRadius: BorderRadius.circular(50.0),
          color: Colors.blue,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(25,13,25,13),
            onPressed: () {
              signup();
            },
            child: Text("Sign Up",
                textAlign: TextAlign.center,

                style: TextStyle(color: Colors.white,fontSize: 20)),
          ),
        )


    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
            child: Text(
              "Welcome",
              style: TextStyle(color: Colors.black87,fontSize: 30),
            ),
          )
          ,
          Container(
              padding: EdgeInsets.fromLTRB(25, 12, 25, 0),

              child:Text(

                "Feeling hungry? Don't worry you have come to the right place.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black87,fontSize: 15),
              )
          )
          ,
          Container(
            padding: EdgeInsets.fromLTRB(27, 150, 27, 20),
            child:TextFormField(
              controller: emailforlogincontroller,
              validator: (input) {
                if(input.isEmpty){
                  return 'Please provide an email ID.';
                }
              },

              style: TextStyle(color: Colors.black,fontSize: 20,),
              decoration: InputDecoration(

                  contentPadding: EdgeInsets.fromLTRB(25, 13, 25, 13),
                  hintText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.black26)
                  ),
                  hintStyle: TextStyle(color: Colors.black54,fontSize: 20)
              ),
            ),


          ),
          Container(

            padding: EdgeInsets.fromLTRB(27, 0, 27, 30),
            child:TextFormField(
              controller: passwordforlogincontroller,
              validator: (input) {
                if(input.isEmpty){
                  return 'Please provide password.';
                }
              },
              //onSaved: (input)=> password_for_login = input,
              style: TextStyle(color: Colors.black,fontSize: 20,),
              obscureText: true,
              decoration: InputDecoration(

                contentPadding: EdgeInsets.fromLTRB(25, 13, 25, 13),
                hintText: "Password",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.black26)
                ),

                hintStyle: TextStyle(color: Colors.black54,fontSize: 20)
                ,
              ),
            ),


          ),
          Container(
            padding: EdgeInsets.fromLTRB(27, 0, 27, 10),
            child: loginButon,
          ),
          Container(
            child: Text(
              "OR"
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(27, 10, 27, 0),
            child: signUpNavButon,
          ),
          FlatButton(
              padding: EdgeInsets.fromLTRB(0, 45, 0, 0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPassPage()),
                );
              },
              child:Text(
                "Forgot Password?"
                ,


                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.black87, fontSize: 18),
              )
          )
        ],
      ),
    );

  }

  login() async {
    String email = emailforlogincontroller.text;
    String password = passwordforlogincontroller.text;
    if(email.isEmpty||password.isEmpty){
      Fluttertoast.showToast(
          msg: "Please provide all the details",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else {
      try {
        String userID = await widget.auth.signIn(email, password);
        //FirebaseUser firebaseUser = FirebaseAuth.instance.currentUser() as FirebaseUser;
        //String userID2 = firebaseUser.uid.toString();
        //FirebaseUser firebaseUser =  await FirebaseAuth.instance.signInWithEmailAndPassword(email: email,password: password);

        widget.onSignIn();
      }
      catch(e){
        Fluttertoast.showToast(
            msg: "Please try again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
  }
  signup() async {
    String email = emailforlogincontroller.text;
    String password = passwordforlogincontroller.text;
    if(email.isEmpty||password.isEmpty){
      Fluttertoast.showToast(
          msg: "Please provide all the details",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else {
      try {
        String userID = await widget.auth.createUser(email, password);
        /*FirebaseUser firebaseUser =  await FirebaseAuth.instance.currentUser();
        DatabaseReference ref1 = FirebaseDatabase.instance.reference();
        List<String> username = firebaseUser.email.toString().split("@");
        String _name = username[0].split(".")[0];
        String name = _name[0].toUpperCase()+_name.substring(1).toLowerCase();
        var data = {
          "email":firebaseUser.email.toString(),
          "uid":firebaseUser.uid.toString(),
          "fullname":name
        };
        ref1.child("customer_info/"+userID).set(data);*/
        widget.onSignIn();
      }
      catch(e){
        Fluttertoast.showToast(
            msg: "Please try again or login.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
  }
}
class ForgotPassPage extends StatefulWidget {
  ForgotPassPage({this.auth});
  final BaseAuth auth;
  @override
  _ForgotPassPageState createState() => _ForgotPassPageState();
}
class _ForgotPassPageState extends State<ForgotPassPage> {
  @override
  TextEditingController emailforresetcontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final forgotPassButon = InkWell(
        onDoubleTap: (){
          resetpass();
        },
        child:Material(
          elevation: 0.0,
          borderRadius: BorderRadius.circular(50.0),
          color: Colors.deepOrangeAccent,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(25,13,25,13),
            onPressed: () {
              resetpass();
            },
            child: Text("Send Me Link",
                textAlign: TextAlign.center,

                style: TextStyle(color: Colors.white,fontSize: 20)),
          ),
        )


    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Back"),
          backgroundColor: Colors.black12,
          elevation: 0,
        ),
      backgroundColor: Colors.white,
      body: Column(

        children: <Widget>[

          Container(
            padding: EdgeInsets.fromLTRB(20, 130, 20, 0),
            child: Text(
              "Reset your password",
              style: TextStyle(color: Colors.black87,fontSize: 30),
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(25, 12, 25, 0),

              child:Text(

                "Please fill in your registered email ID and follow the instructions.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black87,fontSize: 15),
              )
          )
          ,

          Container(
            padding: EdgeInsets.fromLTRB(27, 60, 27, 20),
            child:TextField(
              controller: emailforresetcontroller,
              style: TextStyle(color: Colors.black,fontSize: 20,),
              decoration: InputDecoration(

                contentPadding: EdgeInsets.fromLTRB(25, 13, 25, 13),
                hintText: "Email",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.black26)
                ),

                hintStyle: TextStyle(color: Colors.black54,fontSize: 20)
                ,
              ),
            ),


          ),
          Container(
            padding: EdgeInsets.fromLTRB(27, 0, 27, 20),
            child: forgotPassButon,
          )
        ],
      ),
    );

  }
  void resetpass(){
    String email = emailforresetcontroller.text.toString();
    if(email.isEmpty){
      Fluttertoast.showToast(
          msg: "Please provide an email ID",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else {
      try{
        //emailforresetcontroller.text="";
        FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((v){
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: "Please check your email ID",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIos: 1,
              backgroundColor: Colors.blueAccent,
              textColor: Colors.white,
              fontSize: 16.0
          );
        });
      } catch(e){
        Fluttertoast.showToast(
            msg: "Please try again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
  }
}


