import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetData {
  get() {
    return Firestore.instance.collection("store_data").getDocuments();
  }

  getItemData(String shop_username) {
    return Firestore.instance.collection("shop_username").getDocuments();
  }
}
class GetData2 {
  get(String shop_username, String _username) {
    return Firestore.instance
        .collection("orders")
        .where("customer_username", isEqualTo: _username)
        .where("shop_username", isEqualTo: shop_username)
        .where("status", isEqualTo: 0)
        .getDocuments();
  }
}
Future<bool> savetoCart(List<String> data) async {
  SharedPreferences pre = await SharedPreferences.getInstance();
  //await pre.clear();
  pre.setStringList(data[4], data);

  Fluttertoast.showToast(
      msg: "Added to cart",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 2,
      fontSize: 16.0);
  return pre.commit();
}

Future<List<String>> getfromCart(String key) async {
  SharedPreferences pre = await SharedPreferences.getInstance();
  return pre.getStringList(key);
}

Future<Set<String>> getKeysfromCart() async {
  SharedPreferences pre = await SharedPreferences.getInstance();
  Set<String> s = pre.getKeys();
  return s;
}
