import 'package:flutter/services.dart';

/// Native clipboard write for mobile and desktop.
Future<void> copyTextToClipboard(String text) {
  return Clipboard.setData(ClipboardData(text: text));
}
