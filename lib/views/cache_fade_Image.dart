import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:extended_image/extended_image.dart';
export 'package:extended_image/extended_image.dart';

class CacheFadeImage extends StatefulWidget {
  static bool isOpenDarkMode = true;
  CacheFadeImage.network(
    this.src, {
    Key key,
    double scale = 1.0,
    this.placeholder = '',
    this.darkPlaceholder = '',
    this.package,
    this.enableFade = true,
    this.fadeDuration,
    this.cache = true,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.color,
    this.colorBlendMode,
    this.fit,
    this.placeholderFit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.filterQuality = FilterQuality.low,
    Map<String, String> headers,
  }) {
    _src = (src ?? '').replaceAll(' ', '');
    _src = _src.replaceAll('//', '/');
    _src = _src.replaceFirst(':/', '://');
  }

  final String src;
  final String placeholder;
  final String darkPlaceholder;
  final String package;
  final bool enableFade;
  final Duration fadeDuration;
  final bool cache;

  final double width;
  final double height;
  final Color color;
  final FilterQuality filterQuality;
  final BlendMode colorBlendMode;
  final BoxFit fit;
  final BoxFit placeholderFit;
  final ImageRepeat repeat;
  final Rect centerSlice;
  final bool matchTextDirection;
  final bool gaplessPlayback;
  final String semanticLabel;
  final bool excludeFromSemantics;
  final Alignment alignment;
  String _src;

  static Future<Directory> diskCacheDir() async {
    Directory cacheImagesDirectory =
        Directory(join((await getTemporaryDirectory()).path, "cacheimage"));
    return cacheImagesDirectory;
  }

  @override
  State<StatefulWidget> createState() {
    return CacheFadeImageState();
  }
}

class CacheFadeImageState extends State<CacheFadeImage>
    with TickerProviderStateMixin {
  AnimationController _fadeController;
  CurvedAnimation _curved; //曲线动画，动画插值，
  bool _hasCache = true;
  String _placeholder;
  Brightness _brightness = Brightness.light;

  @override
  void initState() {
//    _fade_controller = AnimationController(
//        vsync: this,
//        duration: widget.fadeDuration == null ? Duration(milliseconds: 333) : widget.fadeDuration,
//        lowerBound: 0.0,
//        upperBound: 1.0);

    _fadeController = AnimationController(
        vsync: this,
        duration: widget.fadeDuration == null
            ? Duration(milliseconds: 333)
            : widget.fadeDuration);

    _curved = new CurvedAnimation(
        parent: _fadeController, curve: Cubic(0.0, 0.0, 1.0, 0.0));
    _hasDiskCache();
    super.initState();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    debugPrint('销毁---cache_fade_image');
    super.dispose();
  }

  _hasDiskCache() async {
    Directory cacheImagesDirectory =
        Directory(join((await getTemporaryDirectory()).path, "cacheimage"));
    //exist, try to find cache image file
    if (cacheImagesDirectory.existsSync()) {
      String md5Key = md5.convert(utf8.encode(widget._src ?? '')).toString();
      File cacheFlie = File(join(cacheImagesDirectory.path, md5Key));
      if (cacheFlie.existsSync()) {
        _hasCache = true;
      } else {
        _hasCache = false;
      }
    } else {
      _hasCache = false;
    }
  }

  Widget getImage(ExtendedImageState state) {
    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        _fadeController.reset();
        return Image.asset(
          _placeholder,
          package: widget.package,
          width: widget.width,
          height: widget.height,
          color: widget.color,
          fit: widget.placeholderFit,
        );
        break;
      case LoadState.completed:
        double opacity = 0.0;
        if (CacheFadeImage.isOpenDarkMode && (_brightness == Brightness.dark)) {
          opacity = 0.35;
        }
        var rawImage = Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            ExtendedRawImage(
              image: state.extendedImageInfo?.image,
              width: widget.width,
              height: widget.height,
              color: widget.color,
              fit: widget.fit,
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                color: Colors.black.withOpacity(opacity),
              ),
            )
          ],
        );
        if (_hasCache == false && widget.enableFade == true) {
          _fadeController.forward();
          return FadeTransition(opacity: _curved, child: rawImage);
        } else {
          return rawImage;
        }
        break;
      default:
        _fadeController.reset();
        //remove memory cached
        state.imageProvider.evict();
        return Image.asset(
          _placeholder,
          package: widget.package,
          width: widget.width,
          height: widget.height,
          color: widget.color,
          fit: widget.placeholderFit,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _brightness = MediaQuery.of(context).platformBrightness;
    _placeholder =
        (widget.darkPlaceholder.length > 0 && _brightness == Brightness.dark)
            ? widget.darkPlaceholder
            : widget.placeholder;
    return ExtendedImage.network(
      widget._src ?? '',
      width: widget.width,
      height: widget.height,
      color: widget.color,
      fit: widget.fit,
      loadStateChanged: getImage,
      cache: widget.cache,
    );
  }
}
