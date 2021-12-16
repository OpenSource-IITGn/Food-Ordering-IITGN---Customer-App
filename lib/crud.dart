import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudMethods {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }
  Future<void> addData(String collName,Object data) async{
    if(isLoggedIn()){
      Firestore.instance.collection(collName).add(data).catchError((e){
        print(e.toString());
      });
    }else {
      print("Not logged in");
    }
  }

  getData() async {
    return await Firestore.instance.collection('store_data').snapshots();
  }

  updateData( col,doc, newValues) {
    Firestore.instance
        .collection(col)
        .document(doc)
        .updateData(newValues)
        .catchError((e) {
      print(e);
    });
  }

  deleteData(col,docId) {
    Firestore.instance
        .collection(col)
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}