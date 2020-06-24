import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void showAlert(BuildContext context, String title, String msg, String leftTitle,
    String rightTitle,
    {VoidCallback leftOnTap,
    VoidCallback rightOnTap,
    TextStyle leftStyle,
    TextStyle rightStyle}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Color textColor = Color(0xFF222222);
      Color lineColor = Colors.black;
      Color bgColor = Colors.white;
      var _brightness = MediaQuery.of(context).platformBrightness;
      if (_brightness == Brightness.dark) {
        textColor = Color(0xFF999999);
        lineColor = Colors.white;
        bgColor = Color(0xFF1A1A1A);
      }
      Widget content = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
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
              color: textColor,
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
              color: textColor,
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
              color: textColor,
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
            width: 270,
            color: bgColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  color: bgColor,
                  padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                  child: content,
                ),
                Container(
                  height: 0.1,
                  width: 270,
                  color: lineColor,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      AlterButton(
                        leftTitle,
                        onTap: leftOnTap,
                        textStyle: leftStyle,
                      ),
                      Container(
                        width: 0.1,
                        height: 44,
                        color: lineColor,
                      ),
                      AlterButton(
                        rightTitle,
                        onTap: rightOnTap,
                        textStyle: rightStyle,
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
  final TextStyle textStyle;
  AlterButton(this.title, {this.onTap, this.textStyle});
  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = textStyle;
    if (_textStyle == null) {
      _textStyle = TextStyle(
        fontWeight: FontWeight.normal,
        color: Color(0xFF1F93EA),
        fontSize: 17,
        decoration: TextDecoration.none,
      );
    }
    Color color = Colors.white;
    var _brightness = MediaQuery.of(context).platformBrightness;
    if (_brightness == Brightness.dark) {
      color = Color(0xFF1A1A1A);
    }
    return Expanded(
      child: GestureDetector(
        child: Container(
          height: 44,
          color: color,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Center(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _textStyle,
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
