import 'dart:io';

import 'package:flutter/material.dart';

import '../constance/api_constants.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    this.imageUrl,
    this.localFile,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.person_rounded,
    this.fallbackColor,
    this.borderRadius,
  });

  final String? imageUrl;
  final File? localFile;
  final double? width;
  final double? height;
  final BoxFit fit;
  final IconData fallbackIcon;
  final Color? fallbackColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (localFile != null) {
      image = Image.file(
        localFile!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, error, stackTrace) => _fallback(),
      );
    } else {
      final normalizedUrl = ApiConstants.getFullImageUrl(imageUrl);
      image = normalizedUrl.isEmpty
          ? _fallback()
          : Image.network(
              normalizedUrl,
              width: width,
              height: height,
              fit: fit,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return _loading();
              },
              errorBuilder: (_, error, stackTrace) => _fallback(),
            );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }

  Widget _loading() {
    return SizedBox(
      width: width,
      height: height,
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  Widget _fallback() {
    return Container(
      width: width,
      height: height,
      color: fallbackColor ?? Colors.blueGrey.shade50,
      alignment: Alignment.center,
      child: Icon(
        fallbackIcon,
        color: Colors.blueGrey.shade400,
        size: _fallbackIconSize(),
      ),
    );
  }

  double _fallbackIconSize() {
    final smallestDimension = switch ((width, height)) {
      (final value?, null) => value,
      (null, final value?) => value,
      (final first?, final second?) => first < second ? first : second,
      (null, null) => 40,
    };
    return smallestDimension * 0.46;
  }
}

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.localFile,
    this.radius = 36,
    this.fallbackIcon = Icons.person_rounded,
    this.backgroundColor,
  });

  final String? imageUrl;
  final File? localFile;
  final double radius;
  final IconData fallbackIcon;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;
    return ClipOval(
      child: AppNetworkImage(
        imageUrl: imageUrl,
        localFile: localFile,
        width: size,
        height: size,
        fallbackIcon: fallbackIcon,
        fallbackColor: backgroundColor,
      ),
    );
  }
}
