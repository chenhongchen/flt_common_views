import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void showAlert(BuildContext context, String title, String msg, String leftTitle,
    String rightTitle,
    {VoidCallback leftOnTap, VoidCallback rightOnTap}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Widget content = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF222222),
              fontSize: 18,
              decoration: TextDecoration.none,
            ),
          ),
          Container(
            height: 3,
          ),
          Text(
            msg,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Color(0xFF222222),
              fontSize: 14,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      );
      if (title.length <= 0) {
        content = Center(
          child: Text(
            msg,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Color(0xFF222222),
              fontSize: 14,
              decoration: TextDecoration.none,
            ),
          ),
        );
      } else if (msg.length <= 0) {
        content = Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF222222),
              fontSize: 18,
              decoration: TextDecoration.none,
            ),
          ),
        );
      }
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 280,
            color: Colors.black,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                  child: content,
                ),
                Container(
                  height: 0.1,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      AlterButton(
                        leftTitle,
                        onTap: leftOnTap,
                      ),
                      Container(
                        width: 0.1,
                      ),
                      AlterButton(
                        rightTitle,
                        onTap: rightOnTap,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class AlterButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  AlterButton(this.title, {this.onTap});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Color(0xFF1F93EA),
                fontSize: 18,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          if (onTap != null) {
            onTap();
          }
        },
      ),
    );
  }
}
