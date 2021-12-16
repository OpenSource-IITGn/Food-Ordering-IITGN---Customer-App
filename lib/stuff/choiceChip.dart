
import 'package:flutter/material.dart';

class ChoiceChip extends StatefulWidget {
  final IconData icon;
  final String text;
  final bool selected;
  ChoiceChip({this.icon, this.text, this.selected});
  @override
  CCState createState() => CCState();
}

class CCState extends State<ChoiceChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: widget.selected
          ? BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20))
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            widget.icon,
            size: 20,
            color: Colors.white,
          ),
          SizedBox(
            width: 8,
          ),
          Text(widget.text,
              style: TextStyle(
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
