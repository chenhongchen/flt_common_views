import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
export 'package:pull_to_refresh/pull_to_refresh.dart';

class KTGifRefresher extends StatefulWidget {
  KTGifRefresher(
      {Key key,
      @required this.controller,
      this.child,
      this.enablePullDown: true,
      this.enablePullUp: false,
      this.enableTwoLevel: false,
      this.onRefresh,
      this.onLoading,
      this.onTwoLevel,
      this.color})
      : assert(controller != null),
        super(key: key) {
    if (color == null) {
      color = Color(0xFF1F93EA);
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _KTGifRefresherState();
  }

  //indicate your listView
  final Widget child;

  // This bool will affect whether or not to have the function of drop-up load.
  final bool enablePullUp;

  // controll whether open the second floor function
  final bool enableTwoLevel;

  //This bool will affect whether or not to have the function of drop-down refresh.
  final bool enablePullDown;

  // upper and downer callback when you drag out of the distance
  final Function onRefresh, onLoading, onTwoLevel;

  //controll inner state
  final RefreshController controller;

  Color color;
}

class _KTGifRefresherState extends State<KTGifRefresher>
    with TickerProviderStateMixin {
  AnimationController _scaleController;

  @override
  void initState() {
    _scaleController =
        AnimationController(value: 0.0, vsync: this, upperBound: 1.0);
    widget.controller.headerMode.addListener(() {
      if (widget.controller.headerStatus == RefreshStatus.idle) {
        _scaleController.value = 0.0;
      } else if (widget.controller.headerStatus == RefreshStatus.refreshing) {}
    });
    super.initState();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: widget.controller,
      onOffsetChange: _onOffsetChange,
      onRefresh: widget.onRefresh,
      onLoading: widget.onLoading,
      header: CustomHeader(
        refreshStyle: RefreshStyle.Follow,
        builder: _headerCreate,
      ),
      footer: CustomFooter(
        loadStyle: LoadStyle.ShowWhenLoading,
        builder: _footerCreate,
      ),
      enablePullDown: widget.enablePullDown,
      enablePullUp: widget.enablePullUp,
      child: widget.child,
    );
  }

  Widget _headerCreate(BuildContext context, RefreshStatus mode) {
    String imageName;
    if (mode == RefreshStatus.refreshing) {
      imageName = "images/list_load.gif";
    } else {
      imageName = "images/list_load_idle.gif";
    }
    return Container(
      child: ScaleTransition(
        scale: _scaleController,
        child: Image.asset(
          imageName,
          package: 'flt_common_views',
          filterQuality: FilterQuality.high,
          width: 40,
          height: 40,
          color: widget.color,
        ),
      ),
    );
  }

  Widget _footerCreate(BuildContext context, LoadStatus mode) {
    String imageName;
    if (mode == LoadStatus.loading) {
      imageName = "images/list_load.gif";
    } else {
      imageName = "images/list_load_idle.gif";
    }
    return Image.asset(
      imageName,
      package: 'flt_common_views',
      filterQuality: FilterQuality.high,
      width: 40,
      height: 40,
      color: widget.color,
    );
  }

  void _onOffsetChange(bool up, double offset) {
    if (up &&
        (widget.controller.headerStatus == RefreshStatus.idle ||
            widget.controller.headerStatus == RefreshStatus.canRefresh)) {
      // 80.0 is headerTriggerDistance default value
      _scaleController.value = (offset / 80.0);
    }
  }
}
