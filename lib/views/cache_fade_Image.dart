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
  CacheFadeImage.network(
    this.src, {
    Key key,
    double scale = 1.0,
    this.placeholder = '',
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
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.filterQuality = FilterQuality.low,
    Map<String, String> headers,
  });

  final String src;
  final String placeholder;
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
  final ImageRepeat repeat;
  final Rect centerSlice;
  final bool matchTextDirection;
  final bool gaplessPlayback;
  final String semanticLabel;
  final bool excludeFromSemantics;
  final Alignment alignment;

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
      String md5Key = md5.convert(utf8.encode(widget.src)).toString();
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
          widget.placeholder,
          package: widget.package,
          width: widget.width,
          height: widget.height,
          color: widget.color,
          fit: widget.fit,
        );
        break;
      case LoadState.completed:
        if (_hasCache == false && widget.enableFade == true) {
          _fadeController.forward();
          return FadeTransition(
              opacity: _curved,
              child: ExtendedRawImage(
                image: state.extendedImageInfo?.image,
                width: widget.width,
                height: widget.height,
                color: widget.color,
                fit: widget.fit,
              ));
        } else {
          return ExtendedRawImage(
            image: state.extendedImageInfo?.image,
            width: widget.width,
            height: widget.height,
            color: widget.color,
            fit: widget.fit,
          );
        }
        break;
      default:
        _fadeController.reset();
        //remove memory cached
        state.imageProvider.evict();
        return Image.asset(
          widget.placeholder,
          package: widget.package,
          width: widget.width,
          height: widget.height,
          color: widget.color,
          fit: widget.fit,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      widget.src,
      width: widget.width,
      height: widget.height,
      color: widget.color,
      fit: widget.fit,
      loadStateChanged: getImage,
      cache: widget.cache,
    );
  }
}
