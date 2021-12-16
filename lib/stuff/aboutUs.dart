import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AboutUs extends StatefulWidget {
  @override
  AboutUsS createState() => AboutUsS();
}

class AboutUsS extends State<AboutUs> {
  List contacts = [
    [
      "Praveen Venkatesh",
      'https://drive.google.com/uc?export=download&id=1SMPiQH8EBPIrrF9WD8RERArcoLbYjZlS'
    ],
    ["Nishikant Parmar", 'https://drive.google.com/uc?export=download&id=1SMPiQH8EBPIrrF9WD8RERArcoLbYjZlS']
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Developers",
          style: TextStyle(
              fontSize: 18, color: Colors.orange, fontFamily: "Raleway"),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: contacts[index][1],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      contacts[index][0],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: contacts.length,
        ),
      ),
    );
  }
}
