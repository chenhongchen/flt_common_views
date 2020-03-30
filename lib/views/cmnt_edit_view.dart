import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flt_system_info/flt_system_info.dart';

typedef SendCallback = void Function(String text);

class CmntEditView extends StatefulWidget {
  final FocusNode focusNode;
  final String placeholder;
  final SendCallback sendCallback;
  final Function() onDispose;
  final Color bgColor;
  final String sendTitle;

  CmntEditView(
      {this.focusNode,
      this.placeholder = '',
      this.sendCallback,
      this.onDispose,
      this.bgColor = Colors.transparent,
      this.sendTitle = '回复'});

  @override
  State<StatefulWidget> createState() {
    return _CmntEditViewState();
  }
}

class _CmntEditViewState extends State<CmntEditView>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _opacityAnimation;
  TextEditingController _teVc = TextEditingController();
  var _opacity = 0.0;
  double _keyboardBottom = 0;
  int _listenerId;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 233),
        animationBehavior: AnimationBehavior.preserve);
    _opacityAnimation = AnimationController(
        duration: const Duration(milliseconds: 233), vsync: this)
      ..addListener(() {
        setState(() {
          _opacity = _opacityAnimation.value;
        });
      });
    _teVc.addListener(() {
      if (_teVc.text.length > 140) {
        _teVc.text = _teVc.text.substring(0, 140);
      }
    });

    _listenerId = FltSystemInfo.addListener(FltSystemInfoListener(
      onWillChangeKeyboardBottom: (double keyboardBottom) {
        setState(() {
          _keyboardBottom = keyboardBottom;
        });
      },
    ));
  }

  @override
  void dispose() {
    if (_animationController != null) {
      _animationController.dispose();
    }
    if (_teVc != null) {
      _teVc.dispose();
    }
    if (_listenerId != null) {
      FltSystemInfo.removeListener(_listenerId);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = new Tween(begin: -176.0, end: _keyboardBottom)
        .animate(_animationController)
          ..addListener(() {
            setState(() {
              // the state that has changed here is the animation object’s value
            });
          });
    if (_keyboardBottom > 0) {
      _animationController.forward();
      _opacityAnimation.forward();
    } else {
      _animationController.reverse();
      _opacityAnimation.reverse();
    }

    return Stack(
      children: <Widget>[
        Offstage(
            offstage: _opacity <= 0,
            child: Opacity(
              opacity: _opacity,
              child: Opacity(
                  opacity: _opacity,
                  child: GestureDetector(
                    child: Container(
                      color: widget.bgColor,
                    ),
                    onTap: () {
                      widget.focusNode.unfocus();
                      if (widget.onDispose != null) {
                        widget.onDispose();
                      }
                    },
                  )),
            )),
        Positioned(
          bottom: animation.value,
          child: _buildTextEditView(),
        )
      ],
    );
  }

  Widget _buildTextEditView() {
    return Container(
      height: 176,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 20,
            top: 15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                color: Color(0xFFF6F6F6),
                height: 102,
                width: MediaQuery.of(context).size.width - 40,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: TextField(
                  maxLines: 10,
                  focusNode: widget.focusNode,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF888888),
                    fontSize: 13,
                    decoration: TextDecoration.none,
                  ),
                  controller: _teVc,
                  decoration: InputDecoration.collapsed(
                    hintText: widget.placeholder,
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF888888),
                      fontSize: 13,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  onSubmitted: _handleSubmitted,
                  onChanged: (String value) {
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 70,
            right: 30,
            child: Text(
              '${_teVc.text.length}/140',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Color(0xFF888888),
                fontSize: 13,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: GestureDetector(
                child: Container(
                  color: Color(0xFF4DA6EB),
                  width: 66,
                  height: 34,
                  child: Center(
                    child: Text(
                      widget.sendTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFFFFFFF),
                        fontSize: 13,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  _handleSubmitted(_teVc.text);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _handleSubmitted(String text) async {
    if (_teVc.text.length <= 0) {
      return;
    }
    if (widget.sendCallback != null) {
      widget.sendCallback(_teVc.text);
    }
    _teVc.text = '';
    widget.focusNode.unfocus();
    if (widget.onDispose != null) {
      widget.onDispose();
    }
    setState(() {});
  }
}
