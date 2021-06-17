import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BorderContainer extends StatelessWidget {
  BorderContainer({
    this.child,
    this.width,
    this.height,
    this.borderWidth = 0,
    this.borderColor = Colors.transparent,
    this.borderRadius = 0,
    this.backgroundColor = Colors.transparent,
    this.padding,
    this.margin,
  });

  final Widget? child;
  final double? width;
  final double? height;
  final double borderWidth;
  final Color borderColor;
  final double borderRadius;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        padding: padding,
        margin: margin,
        child: Container(
          width: width,
          height: height,
          color: backgroundColor,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: borderWidth,
                left: borderWidth,
                bottom: borderWidth,
                right: borderWidth,
                child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(borderRadius - borderWidth),
                    child: child),
              ),
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: borderColor, width: borderWidth), // 边色与边宽度
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
