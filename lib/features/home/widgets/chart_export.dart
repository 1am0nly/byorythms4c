import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ChartExporter {
  static Future<Uint8List?> captureWidget(
      GlobalKey repaintKey, double pixelRatio) async {
    final boundary = repaintKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  static Future<void> shareAsPng(
    GlobalKey repaintKey, {
    double pixelRatio = 3.0,
    String? subject,
    String fallbackSubject = 'Мои биоритмы',
  }) async {
    final bytes = await captureWidget(repaintKey, pixelRatio);
    if (bytes == null) return;

    final dir = await getTemporaryDirectory();
    final file = File(
        '${dir.path}/biorhythm_${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: subject ?? fallbackSubject,
    );
  }

  static Future<void> shareAsText(String text, {String subject = 'Мои биоритмы'}) async {
    await Share.share(text, subject: subject);
  }
}
