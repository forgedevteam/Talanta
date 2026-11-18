import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talanta/core/config/app_config.dart';

/// The API returns file URLs relative to itself unless a CDN serves them.
String resolveMediaUrl(String url) =>
    Uri.parse(AppConfig.apiBaseUrl).resolve(url).toString();

/// How pictures from the server are loaded. Cached on disk, so scrolling
/// back costs no data. Tests swap in an in-memory image.
final networkImageProvider = Provider<ImageProvider Function(String url)>(
  (ref) =>
      (url) => CachedNetworkImageProvider(resolveMediaUrl(url)),
);
