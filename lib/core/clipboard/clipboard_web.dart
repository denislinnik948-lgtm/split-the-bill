// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Web clipboard write.
///
/// Uses a hidden, selected textarea with `execCommand('copy')`, executed
/// synchronously within the click gesture. This is more reliable than the async
/// Clipboard API, which can throw "Document is not focused" when Flutter's
/// canvas holds focus.
Future<void> copyTextToClipboard(String text) async {
  final textarea = html.TextAreaElement()
    ..value = text
    ..setAttribute('readonly', '')
    ..style.position = 'fixed'
    ..style.left = '-9999px'
    ..style.top = '0';
  html.document.body!.append(textarea);
  textarea.focus();
  textarea.select();
  textarea.setSelectionRange(0, text.length);
  try {
    html.document.execCommand('copy');
  } finally {
    textarea.remove();
  }
}
